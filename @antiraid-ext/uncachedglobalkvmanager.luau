--!strict
local Primitives = require"@antiraid-core/primitives"
local datetime = require"@antiraid/datetime"

export type GlobalKvData<PublicMetadata> = { short: string, public_metadata: PublicMetadata, public_data: boolean }

--- KeyRecord represents a key-value of the record.
---@class KvRecord
export type GlobalKeyRecord<PublicMetadata> = {
    --- The key of the record.
    read key: string,
    --- The value returned by the runtime
    read value: any,
    --- Public metadata about the key-value
    read publicmetadata: PublicMetadata,
    --- The timestamp when the record was created
    read createdat: datetime.DateTime,
    --- The timestamp when the record was last updated at
    read lastupdatedat: datetime.DateTime,
}

--- An uncached key manager provides methods to add, remove and check keys with *no* caching
export type UncachedGlobalKeyManager<PublicMetadata, Data> = {
    --- Inserts a new key
    read set: (key: string, metadata: GlobalKvData<PublicMetadata>, data: Data, version: number) -> (),

    --- Removes a key
    read remove: (key: string, version: number) -> (),

    --- Lists all keys with their data
    ---
    --- If query is passed, will use said query (sql ilike syntax for query) for listing, otherwise, will use `%%` to get all keys
    read list: (query: string?) -> (number, {[string]: GlobalKeyRecord<PublicMetadata>}),

    --- Same as list but returns an array
    read listarr: (query: string?) -> {GlobalKeyRecord<PublicMetadata>},

    --- Gets a specific key's data
    read get: (key: string, version: number) -> GlobalKeyRecord<PublicMetadata>?,
}

--- An uncached key manager
---
--- A uncached key manager can be used to handle data *without* caching (similar to KeyManager but without caching)
---
--- Notes:
--- 1. Unlike KeyManager, it is guaranteed that creating a UncachedKeyManager will *not* yield
local function UncachedGlobalKeyManager<PublicMetadata, Data>(ctx: Primitives.TemplateContext, basescope: string): UncachedGlobalKeyManager<PublicMetadata, Data>
    local function remove(key: string, version: number)
        ctx.Runtime:execstate({{ op = "GlobalKvDelete", key = key, version = version, scope = basescope }})
    end

    local function set(key: string, metadata: GlobalKvData<PublicMetadata>, data: Data, version: number)
        ctx.Runtime:execstate({{
            op = "GlobalKvCreate",
            key = key,
            version = version,
            short = metadata.short,
            public_metadata = metadata.public_metadata,
            scope = basescope,
            public_data = metadata.public_data,
            data = data
        }})
    end

    local function list(query: string?): (number, {[string]: GlobalKeyRecord<PublicMetadata>})
        local records = ctx.Runtime:execstate({{ op = "GlobalKvFind", query = query or "%%", scope = basescope }})
        local parsed: {[string]: GlobalKeyRecord<PublicMetadata>} = {}
        local count = 0
        for _, record in records do
            parsed[record.key] = {
                key = record.key,
                value = record.value,
                publicmetadata = record.value.public_metadata,
                createdat = record.created_at,
                lastupdatedat = record.last_updated_at
            }
            count += 1
        end

        return count, parsed
    end

    local function listarr(query: string?): {GlobalKeyRecord<PublicMetadata>}
        local records = ctx.Runtime:execstate({{ op = "GlobalKvFind", query = query or "%%", scope = basescope }})
        local parsed: {GlobalKeyRecord<PublicMetadata>} = {}
        for _, record in records do
            table.insert(parsed, {
                key = record.key,
                value = record.value,
                publicmetadata = record.value.public_metadata,
                createdat = record.created_at,
                lastupdatedat = record.last_updated_at
            })
        end

        return parsed
    end

    local function get(key: string, version: number): GlobalKeyRecord<PublicMetadata>?
        local records = ctx.Runtime:execstate({{ op = "GlobalKvGet", key = key, version = version, scope = basescope }})
        if #records == 0 then return nil end
        local record = records[1]
        return {
            key = record.key,
            value = record.value,
            publicmetadata = record.value.public_metadata,
            createdat = record.created_at,
            lastupdatedat = record.last_updated_at
        }
    end

    local self: UncachedGlobalKeyManager<PublicMetadata, Data> = table.freeze{
        set = set,
        remove = remove,
        list = list,
        listarr = listarr,
        get = get,
    }

    return self
end

return UncachedGlobalKeyManager
