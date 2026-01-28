local Primitives = require"@antiraid-core/primitives"
local khronosvalue = require"@antiraid-core/khronosvalue"
local channel = require"@antiraid/channel"
local datetime = require"@antiraid/datetime"
local templateloopImpl = require"@antiraid-core/templateloop"
local typesext = require"@antiraid/typesext"

local MAX_KEYEXPIRY_KEY_LENGTH = 8 -- This sounds *small* but we have a-z, A-Z and 0-9 making for 62^8 combinations which is plenty
local KEYEXPIRY_RANDSTRING_LENGTH = 8

export type KeyExpiryData = {
    --- The data associated with this key expiry
    data: any?,
}

--- ExpiringKeyRecord represents a key-value that can record.
---@class KvRecord
export type ExpiringKeyRecord = {
    --- The key of the record.
    key: string,
    --- The value of the record. This can be any type, depending on what was stored.
    value: khronosvalue.KhronosValue,
    --- The timestamp when the record was created
    created_at: datetime.DateTime,
    --- The timestamp when the record will expire, 
    expires_at: datetime.DateTime,
}

--- A key expiry manager provides methods to add, remove and check keys with expiries
---
--- When a key expires, a key expiry event is dispatched to all templates.
---
--- Note that the associated data present should be small in size as all keys are loaded into memory.
export type KeyExpiryManager = {
    --- Makes a new key expiry, returning the generated key
    ---
    --- When the returned key expires after `expiresin`, a `KeyExpiry` event is dispatched to all templates with the key
    --- as part of the event data.
    ---
    --- Any data to be associated with the key expiry should be stored separately using the returned key (e.g. in the key-value store).
    read add: (expiresin: datetime.TimeDelta, data: any?) -> string,

    --- Same as ``add`` but takes in a DateTime expiresat instead of a TimeDelta
    read addat: (expiresat: datetime.DateTime, data: any?) -> string,

    --- Same as ``add`` but takes in a expiresin as seconds instead of a TimeDelta
    read addwithsecs: (expiresin: number, data: any?) -> string,

    --- Removes a key
    read remove: (key: string) -> (),

    --- Checks if a key exists and is not expired
    read exists: (key: string) -> boolean,

    --- Tries to synchronize key expiries from tenant state


    --- Finds all keys with their data
    ---
    --- Analogous to `ctx.KV:find` in the normal key-value store API.
    read find: () -> {ExpiringKeyRecord},
}

--- A key expiry manager
---
--- A key expiry manager can be used to schedule events to be dispatched at a later time with associated data.
local function KeyExpiryManager(ctx: Primitives.TemplateContext, basescope: string, eventname: string): KeyExpiryManager
    local systemscope = "__kexs"..basescope -- System scope where kex's are stored
    local system = "__kex-"..basescope -- System name for subscribing to events

    local loop = templateloopImpl.getRunningLoop(ctx)
    loop.debugmanager.print("[KeyExpiryManager] Initializing KeyExpiryManager")

    local kexs = {} :: {[string]: {
        createdat: datetime.DateTime,
        expiresat: datetime.DateTime,
        data: any?,
    }}

    local handles: {[string]: channel.KeyHandle<string>} = {}
    local delayqueue = channel.DelayChannel() :: channel.DelayChannel<string> -- Delayqueue stores a queue of all the kvs we need to dispatch
    local th: thread? = nil

    local function remove(key: string) 
        local handle = handles[key]
        if handle then 
            handle:cancel() -- Cancel the handle
            handles[key] = nil
        end
        if kexs[key] then -- Remove associated key expiry + data
            loop.debugmanager.print("[KeyExpiryManager] Removing key expiry: "..key)
            kexs[key] = nil
            ctx.KV:delete(systemscope.."/"..key, {systemscope})
            if next(kexs) == nil and #delayqueue == 0 then 
                loop.unsubscribeEvent("OnStartup", system) -- No more key expiries, unsubscribe
            end
        end
    end

    local function _dispatchEvent(key: string) 
        -- Dispatch event to templates
        loop.debugmanager.print("[KeyExpiryManager] Key expired: "..key)

        -- Fetch associated data if any
        local kex = kexs[key]
        local ok, res = xpcall(loop.dispatchEvent, debug.traceback :: any, ctx, {name = eventname, data = { key = key, data = kex.data, created_at = kex.createdat, expires_at = kex.expiresat }, author = nil}, nil)
        if not ok then 
            loop.debugmanager.print("[KeyExpiryManager] Error dispatching KeyExpiry event for key "..key..": "..tostring(res))
        end

        -- Remove the key expiry only after dispatching
        handles[key] = nil
        remove(key)
    end

    local function _loop() 
        loop.debugmanager.print("[KeyExpiryManager] Key expiry loop started")
        while true do 
            local item = delayqueue:next()

            -- Dispatch events in a seperate thread to avoid blocking the loop
            task.spawn(_dispatchEvent, item)
        end
    end

    local function _loopwhile() 
        while true do
                local success, err = pcall(_loop)
                if not success then
                    loop.debugmanager.print("[KeyExpiryManager] Loop crashed: " .. tostring(err))
                    task.wait(1) -- Prevent CPU spin
                end
            end
    end

    --- Helper method to ensure the loop is running
    local function _ensureLoopRunning()
        loop.debugmanager.print("[KeyExpiryManager] Ensuring key expiry loop is running")
        if not th or coroutine.status(th) == "dead" then th = task.spawn(_loopwhile) end
    end

    local function exists(id: string): boolean 
        return kexs[id] ~= nil and handles[id] ~= nil
    end

    local function _createkey(): string 
        local key = typesext.randstring(KEYEXPIRY_RANDSTRING_LENGTH)
        while true do 
            if exists(key) then
                key = typesext.randstring(KEYEXPIRY_RANDSTRING_LENGTH)
            else
                break
            end
        end
        return key
    end

    local function addat(expiresat: datetime.DateTime, data: any?)
        local key = _createkey()
        assert(#key <= MAX_KEYEXPIRY_KEY_LENGTH, "Generated key exceeds maximum key length")
        assert(not exists(key), `Generated KeyExpiry key \`{key}\` already exists, this should be impossible`)
        assert(expiresat.timezone == datetime.UTC, "expiresat must be in UTC timezone")

        -- Check if we've already expired either due to initial input or otherwise
        if expiresat <= datetime.UTC:now() then 
            -- Already expired, add with a random delay of 1-6s instead
            expiresat = datetime.UTC:now() + datetime.timedelta_seconds((math.random() * 5) + 1)
        end

        -- Record in kv store
        local tdata = {
            createdat = datetime.UTC:now(),
            expiresat = expiresat,
            data = data,
        }
        kexs[key] = tdata
        loop.subscribeEvent("OnStartup", system)
        ctx.KV:set(systemscope.."/"..key, tdata, {systemscope})

        handles[key] = delayqueue:add(key, expiresat:duration_since(datetime.UTC:now()))
        _ensureLoopRunning()

        return key
    end

    -- Just calls addat with a TimeDelta
    local function add(expiresin: datetime.TimeDelta, data: any?)
        local expiresat = (datetime.UTC:now() + expiresin)
        return addat(expiresat, data)
    end

    local function addwithsecs(expiresin: number, data: any?)
        local expiresat = (datetime.UTC:now() + datetime.timedelta_seconds(expiresin))
        return addat(expiresat, data)
    end

    local function find(): {ExpiringKeyRecord}
        local result = {} :: {ExpiringKeyRecord}
        for key, record in kexs do
            table.insert(result, {
                key = key,
                value = record.data,
                created_at = record.createdat,
                expires_at = record.expiresat,
            })
        end
        return result
    end

    --- Synchronize key expiries from KV store
    local function sync() 
        if #delayqueue > 0 then delayqueue:clear() end -- Clear existing delayqueue entries
        -- Fetch existing key expiries from kv
        loop.debugmanager.print("[KeyExpiryManager] Syncing key expiries from tenant state")
        local kexdata = ctx.KV:find("%%", {systemscope})
        for _, item in kexdata do
            if item.exists then
                local record = item.value :: {
                    expiresat: datetime.DateTime,
                    hd: {string}?,
                    data: any?,
                }
                kexs[item.key] = {
                    createdat = item.created_at,
                    expiresat = record.expiresat,
                    hd = item.scopes,
                    data = record.data,
                }
            end
        end

        -- Setup delayqueue
        _ensureLoopRunning()
        local count = 0
        for key, data in kexs do
            count += 1
            if count % 200 == 0 then 
                task.wait(0.1) -- Yield to avoid blocking too long
            end
            if data.expiresat <= datetime.UTC:now() then 
                -- Already expired, add with a random delay > 20 seconds to avoid thundering herd
                data.expiresat = datetime.UTC:now() + datetime.timedelta_seconds(20 + math.random(5, 120))
            end
            handles[key] = delayqueue:add(key, data.expiresat:duration_since(datetime.UTC:now()))
        end    
    end

    -- Only sync if we're subscribed to OnStartup explicitly.
    if loop.isSubscribed("OnStartup", system) then
        task.spawn(sync)
    end

    return table.freeze{
        add = add,
        addwithsecs = addwithsecs,
        addat = addat,
        remove = remove,
        exists = exists,
        sync = sync,
        find = find,
    }
end

return KeyExpiryManager