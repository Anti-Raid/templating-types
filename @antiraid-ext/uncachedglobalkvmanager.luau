--!strict
local Primitives = require"@antiraid-core/primitives"
local runtime = require"@antiraid-core/plugins/runtime"
local datetime = require"@antiraid/datetime"

--- KeyRecord represents a key-value of the record.
---@class KvRecord
export type GlobalKeyRecord<PublicMetadata> = {
    --- The key of the record.
    read key: string,

    --- The version of the record
    read version: number,

    --- The owner id of the record (for global kvs, this is the tenant id)
    read owner_id: string,

    --- The owner type of the record (user or guild)
    read owner_type: string,

    --- Short description of the record
    read short: string,

    --- Public metadata about the key-value
    read publicmetadata: PublicMetadata,

    --- Contents of vfs is readable or not (paid templates)
    read public_data: boolean,

    --- Review state of the record (pending, approved, rejected)
    read review_state: string,

    --- An optional long description of the record
    read long: string?,

    --- An optional price for the record (if the record is for sale)
    read price: number?,

    --- The timestamp when the record was created
    read createdat: datetime.DateTime,

    --- The timestamp when the record was last updated at
    read lastupdatedat: datetime.DateTime,
}

--- KeyRecord represents a key-value of the record.
---@class KvRecord
export type CreateGlobalKey<PublicMetadata, Data> = {
    --- The key of the record.
    read key: string,

    --- The version of the record
    read version: number,

    --- The owner id of the record (for global kvs, this is the tenant id)
    read owner_id: string,

    --- The owner type of the record (user or guild)
    read owner_type: string,

    --- Short description of the record
    read short: string,

    --- Public metadata about the key-value
    read publicmetadata: PublicMetadata,

    --- Contents of vfs is readable or not (paid templates)
    read public_data: boolean,

    --- An optional long description of the record
    read long: string?,

    --- The data to be stored in the record
    read data: Data,
}


--- An uncached key manager provides methods to add, remove and check keys with *no* caching
export type UncachedGlobalKeyManager<PublicMetadata, Data> = {
    --- Creates a new key
    read create: (data: CreateGlobalKey<PublicMetadata, Data>) -> (),

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

local function parseglobalkeyrecord<PublicMetadata>(record: runtime.StateExecResult): GlobalKeyRecord<PublicMetadata>
    return {
        key = record.key,
        version = record.value.version,
        owner_id = record.value.owner_id,
        owner_type = record.value.owner_type,
        short = record.value.short,
        publicmetadata = record.value.public_metadata,
        public_data = record.value.public_data,
        review_state = record.value.review_state,
        long = record.value.long,
        price = record.value.price,
        createdat = record.created_at,
        lastupdatedat = record.last_updated_at
    }
end


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

    local function create(data: CreateGlobalKey<PublicMetadata, Data>)
        ctx.Runtime:execstate({{
            op = "GlobalKvCreate",
            key = data.key,
            version = data.version,
            short = data.short,
            public_metadata = data.publicmetadata,
            scope = basescope,
            public_data = data.public_data,
            data = data.data
        }})
    end

    local function list(query: string?): (number, {[string]: GlobalKeyRecord<PublicMetadata>})
        local records = ctx.Runtime:execstate({{ op = "GlobalKvFind", query = query or "%%", scope = basescope }})
        local parsed: {[string]: GlobalKeyRecord<PublicMetadata>} = {}
        local count = 0
        for _, record in records do
            parsed[record.key] = parseglobalkeyrecord(record)
            count += 1
        end

        return count, parsed
    end

    local function listarr(query: string?): {GlobalKeyRecord<PublicMetadata>}
        local records = ctx.Runtime:execstate({{ op = "GlobalKvFind", query = query or "%%", scope = basescope }})
        local parsed: {GlobalKeyRecord<PublicMetadata>} = {}
        for _, record in records do
            table.insert(parsed, parseglobalkeyrecord(record))
        end

        return parsed
    end

    local function get(key: string, version: number): GlobalKeyRecord<PublicMetadata>?
        local records = ctx.Runtime:execstate({{ op = "GlobalKvGet", key = key, version = version, scope = basescope }})
        if #records == 0 then return nil end
        local record = records[1]
        return parseglobalkeyrecord(record)
    end

    local self: UncachedGlobalKeyManager<PublicMetadata, Data> = table.freeze{
        create = create,
        remove = remove,
        list = list,
        listarr = listarr,
        get = get,
    }

    return self
end

return UncachedGlobalKeyManager
