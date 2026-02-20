local Primitives = require"@antiraid-core/primitives"
local datetime = require"@antiraid/datetime"
local templateloopImpl = require"@antiraid-core/templateloop"
local typesext = require"@antiraid/typesext"

local KEY_RANDSTRING_LENGTH = 8

--- KeyRecord represents a key-value of the record.
---@class KvRecord
export type KeyRecord<T> = {
    --- The key of the record.
    read key: string,
    --- The value of the record. This can be any type, depending on what was stored.
    read value: T,
    --- The timestamp when the record was created
    read createdat: datetime.DateTime,
}

--- A key manager provides methods to add, remove and check keys with builtin caching
---
--- Note that the associated data present should be small in size as all keys are loaded into memory.
export type KeyManager<T> = {
    --- Makes a new key, returning the generated key
    read add: (data: T, key: string?) -> string,

    --- Updates the data associated with a key. Does not affect anything but the data.
    read updatedata: (key: string, data: T) -> (),

    --- Removes a key
    read remove: (key: string) -> (),

    --- Checks if a key exists and is not expired
    read exists: (key: string) -> boolean,

    --- Tries to synchronize key expiries from tenant state


    --- Lists all keys with their data
    ---
    --- Analogous to `ctx.KV:find` in the normal key-value store API but doesn't support pattern matching
    ---
    --- Note that the data returned is not cloned, so modifying it may modify actual stored data. This is for performance reasons since the data can be large, 
    --- but be aware of this when using the list method.
    read list: () -> {[string]: KeyRecord<T>},

    --- Gets a specific key's data
    ---
    --- Analogous to `ctx.KV:getrecord` in the normal key-value store API.
    read get: (key: string) -> KeyRecord<T>?,

    --- Returns the number of keys currently stored (approximate)
    read count: () -> number,
}

--- A key manager
---
--- A key manager can be used to handle data with caching. Similar to KeyExpiryManager but without the expiry functionality
local function KeyManager<T>(
    ctx: Primitives.TemplateContext, 
    basescope: string, 
    oninit: ((loop: templateloopImpl.TemplateLoopManager, records: {[string]: KeyRecord<T>}, km: KeyManager<T>) -> any)?
): KeyManager<T>
    local loop = templateloopImpl.getRunningLoop(ctx)
    loop.debugmanager.print("[KeyManager] Initializing KeyManager")

    local kexs = {} :: {[string]: KeyRecord<T>}
    local count = 0

    local function remove(key: string) 
        if kexs[key] then -- Remove associated key + data
            loop.debugmanager.print("[KeyManager] Removing key: "..key)
            kexs[key] = nil
            ctx.KV:delete(key, {basescope})
            count = count - 1
            if next(kexs) == nil then 
                loop.unsubscribeEvent("@keym", basescope) -- No more keys, unsubscribe
            end
        end
    end

    local function exists(id: string): boolean 
        return kexs[id] ~= nil
    end

    local function _createkey(): string 
        local key = typesext.randstring(KEY_RANDSTRING_LENGTH)
        while true do 
            if exists(key) then
                key = typesext.randstring(KEY_RANDSTRING_LENGTH)
            else
                break
            end
        end
        return key
    end

    local function add(data: T, ckey: string?)
        local key = ckey or _createkey()
        assert(not exists(key), `Generated key \`{key}\` already exists`)

        -- Record in kv store
        loop.subscribeEvent("@keym", basescope)
        ctx.KV:set(key, data, {basescope})
        count = count + 1
        kexs[key] = table.freeze{
            key = key,
            createdat = datetime.UTC:now(),
            value = data,
        }

        return key
    end

    local function updatedata(key: string, data: T)
        if not exists(key) then 
            loop.debugmanager.print("[KeyManager] Attempted to update data for non-existent key: "..key)
            return
        end

        -- Update in kv store, note that the delayqueue only stores key so we don't need to update it
        local record = kexs[key]
        ctx.KV:set(key, data, {basescope})
        kexs[key] = table.freeze{
            key = key,
            createdat = record.createdat,
            value = data,
        }
    end

    local function list(): {[string]: KeyRecord<T>}
        return kexs
    end

    local function get(key: string): KeyRecord<T>?
        local record = kexs[key]
        if not record then return nil end
        return record
    end

    local self = {} :: KeyManager<T>

    --- Synchronize key expiries from KV store
    local function sync() 
        -- Fetch existing key expiries from kv
        loop.debugmanager.print("[KeyManager] Syncing keys from tenant state")
        local kexdata = ctx.KV:find("%%", {basescope})
        local newkexs: {[string]: KeyRecord<T>} = {}
        local newcount = 0
        for _, item in kexdata do
            if item.exists then
                local record = item.value :: T
                newkexs[item.key] = table.freeze{
                    key = item.key,
                    value = record,
                    createdat = item.created_at,
                }
                newcount = newcount + 1
            end
        end
        kexs = newkexs -- Replace with new data
        count = newcount
        loop.debugmanager.print("[KeyManager] Synced keys. Count: "..count)

        -- Call oninit callback if provided
        if oninit then 
            task.spawn(function()
                if not oninit then return end -- needed for luau new type solver
                local ok, res = xpcall(oninit, debug.traceback :: any, loop, kexs, self)
                if not ok then 
                    loop.debugmanager.print("[KeyManager] Error in oninit callback: "..tostring(res))
                end
            end)
        end
    end

    local function countkeys(): number 
        return count
    end

    local _self: KeyManager<T> = table.freeze{
        add = add,
        remove = remove,
        exists = exists,
        sync = sync,
        list = list,
        get = get,
        updatedata = updatedata,
        count = countkeys,
    }
    self = _self -- For luau type reasons

    -- Initially sync if we're subscribed to OnStartup explicitly.
    if loop.isSubscribed("@keym", basescope) then
        task.spawn(sync)
    end

    return _self
end

return KeyManager