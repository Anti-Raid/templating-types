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
export type UncachedGlobalKeyManager<T> = {
    --- Inserts a new key
    read set: (key: string, data: T, version: number) -> (),

    --- Removes a key
    read remove: (key: string, version: number) -> (),

    --- Lists all keys with their data
    ---
    --- If query is passed, will use said query (sql ilike syntax for query) for listing, otherwise, will use `%%` to get all keys
    read list: (query: string?) -> (number, {[string]: KeyRecord<T>}),

    --- Same as list but returns an array
    read listarr: (query: string?) -> {KeyRecord<T>},

    --- Gets a specific key's data
    read get: (key: string, version: number) -> KeyRecord<T>?,
}

--- An uncached key manager
---
--- A uncached key manager can be used to handle data *without* caching (similar to KeyManager but without caching)
---
--- Notes:
--- 1. Unlike KeyManager, it is guaranteed that creating a UncachedKeyManager will *not* yield
local function UncachedGlobalKeyManager<T>(ctx: Primitives.TemplateContext, basescope: string): UncachedGlobalKeyManager<T>
    local function remove(key: string, version: number) 
        ctx.Runtime:execstate({{ op = "GlobalKvDelete", key = key, version = version, scope = basescope }})
    end

    local function set(key: string, data: T, version: number)
        ctx.Runtime:execstate({{
            op = "GlobalKvCreate",
            key = key,
            version = version,
            short = "",
            public_metadata = {},
            scope = basescope,
            public_data = false,
            data = data
        }})
    end

    local function list(query: string?): (number, {[string]: KeyRecord<T>})
        local records = ctx.Runtime:execstate({{ op = "GlobalKvFind", query = query or "%%", scope = basescope }})
        local parsed: {[string]: KeyRecord<T>} = {}
        local count = 0
        for _, record in records do 
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
        local records = ctx.Runtime:execstate({{ op = "GlobalKvFind", query = query or "%%", scope = basescope }})
        local parsed: {KeyRecord<T>} = {}
        for _, record in records do 
            table.insert(parsed, {
                key = record.key,
                value = record.value,
                createdat = record.created_at,
                lastupdatedat = record.last_updated_at
            })
        end

        return parsed
    end

    local function get(key: string, version: number): KeyRecord<T>?
        local records = ctx.Runtime:execstate({{ op = "GlobalKvGet", key = key, version = version, scope = basescope }})
        if #records == 0 then return nil end
        local record = records[1]
        return {
            key = record.key,
            value = record.value,
            createdat = record.created_at,
            lastupdatedat = record.last_updated_at
        }
    end

    local self: UncachedGlobalKeyManager<T> = table.freeze{
        set = set,
        remove = remove,
        list = list,
        listarr = listarr,
        get = get,
    }

    return self
end

return UncachedGlobalKeyManager
