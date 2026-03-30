--!strict
local Primitives = require"@antiraid-core/primitives"
local datetime = require"@antiraid/datetime"

--- KeyRecord represents a key-value of the record.
---@class KvRecord
export type KeyRecord<T> = {
    --- The key of the record.
    read key: string,
    --- The value of the record. This can be any type, depending on what was stored.
    read value: T,
    --- The timestamp when the record was created
    read createdat: datetime.DateTime,
    --- The timestamp when the record was last updated at
    read lastupdatedat: datetime.DateTime,
}

--- An uncached key manager provides methods to add, remove and check keys with *no* caching
export type UncachedKeyManager<T> = {
    --- Inserts or updates a new key
    read set: (key: string, data: T) -> (),

    --- Removes a key
    read remove: (key: string) -> (),

    --- Lists all keys with their data
    ---
    --- If query is passed, will use said query (sql ilike syntax for query) for listing, otherwise, will use `%%` to get all keys
    read list: (query: string?) -> (number, {[string]: KeyRecord<T>}),

    --- Same as list but returns an array
    read listarr: (query: string?) -> {KeyRecord<T>},

    --- Gets a specific key's data
    read get: (key: string) -> KeyRecord<T>?,
}

--- An uncached key manager
---
--- A uncached key manager can be used to handle data *without* caching (similar to KeyManager but without caching)
---
--- Notes:
--- 1. Unlike KeyManager, it is guaranteed that creating a UncachedKeyManager will *not* yield
local function UncachedKeyManager<T>(ctx: Primitives.TemplateContext, basescope: string): UncachedKeyManager<T>
    local function remove(key: string) 
        ctx.Runtime:syscall({op="State", ops={{ op = "KvDelete", key = key, scope = basescope }}})
    end

    local function set(key: string, data: T)
        ctx.Runtime:syscall({op="State", ops={{ op = "KvSet", key = key, scope = basescope, value = data }}})
    end

    local function list(query: string?): (number, {[string]: KeyRecord<T>})
        local records = ctx.Runtime:syscall({op="State", ops={{ op = "KvFind", query = query or "%%", scope = basescope }}})
        assert(records.op == "State")
        local parsed: {[string]: KeyRecord<T>} = {}
        local count = 0
        for _, record in records.res do 
            if record.op ~= "Kv" then continue end
            parsed[record.key] = {
                key = record.key,
                value = record.value,
                createdat = record.created_at,
                lastupdatedat = record.last_updated_at
            }
            count += 1
        end

        return count, parsed
    end

    local function listarr(query: string?): {KeyRecord<T>}
        local records = ctx.Runtime:syscall({op="State", ops={{ op = "KvFind", query = query or "%%", scope = basescope }}})
        assert(records.op == "State")
        local parsed: {KeyRecord<T>} = {}
        for _, record in records.res do 
            if record.op ~= "Kv" then continue end
            table.insert(parsed, {
                key = record.key,
                value = record.value,
                createdat = record.created_at,
                lastupdatedat = record.last_updated_at
            })
        end

        return parsed
    end

    local function get(key: string): KeyRecord<T>?
        local records = ctx.Runtime:syscall({op="State", ops={{ op = "KvGet", key = key, scope = basescope }}})
        assert(records.op == "State")
        if #records.res == 0 then return nil end
        local record = records.res[1]
        if record.op ~= "Kv" then return nil end
        return {
            key = record.key,
            value = record.value,
            createdat = record.created_at,
            lastupdatedat = record.last_updated_at
        }
    end

    local self: UncachedKeyManager<T> = table.freeze{
        set = set,
        remove = remove,
        list = list,
        listarr = listarr,
        get = get,
    }

    return self
end

return UncachedKeyManager