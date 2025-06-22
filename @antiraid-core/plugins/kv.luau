local khronosvalue = require "@antiraid-core/khronosvalue"
local datetime = require "@antiraid/datetime"

--- KvRecord represents a key-value record with metadata.
---@class KvRecord
export type KvRecord = {
    --- The ID of the record
    id: string,
    --- The key of the record.
    key: string,
    --- The value of the record. This can be any type, depending on what was stored.
    value: khronosvalue.KhronosValue,
    --- Indicates whether the record exists in the key-value store.
    exists: true,
    --- The scopes the key has
    scopes: {string},
    --- The timestamp when the record was created, in ISO 8601 format (e.g., "2023-10-01T12:00:00Z").
    created_at: datetime.DateTime,
    --- The timestamp when the record was last updated, in ISO 8601 format (e.g., "2023-10-01T12:00:00Z").
    last_updated_at: datetime.DateTime,
} | {
    --- The key of the record.
    key: string,
    --- Indicates whether the record exists in the key-value store.
    exists: false,
}

--- A list of KvRecords
export type KvRecordList = {KvRecord}

--- KvExecutor allows templates to get, store and find persistent data within a server.
---@class KvExecutor
export type KvExecutor = {
    --- The guild ID the executor will perform key-value operations on.
    read guild_id: string,
    --- The originating guild ID (the guild ID of the template itself).
    read origin_guild_id: string,

    --- Whether or not unscoped operations are allowed.
    --- Requires the kv.meta:unscoped_allowed:set to set this field
    --- and kv.meta:unscoped_allowed to get this field.
    unscoped_allowed: boolean,

    --- @yields
    ---
    --- Returns a list of all key-value scopes/
    --- This is only guaranteed to return scopes that actually have at least one key inside it.
    ---
    --- Needs the `kv.meta:list_scopes` capability to use
    list_scopes: (self: KvExecutor) -> {string},

    --- @yields
    ---
    --- Finds matching records in this key-value scope.
    --- @param query string The key to search for. % matches zero or more characters; _ matches a single character. To search anywhere in a string, surround {KEY} with %, e.g. %{KEY}%
    --- @return {KvRecord} The records.
    find: (self: KvExecutor, query: string, scopes: {string}?) -> KvRecordList,

    --- @yields
    ---
    --- Gets a value from this key-value scope.
    --- @param key string The key of the record.
    --- @return any The value of the record.
    get: (self: KvExecutor, key: string, scopes: {string}?) -> khronosvalue.KhronosValue,

    --- @yields
    ---
    --- Gets a record from this key-value scope.
    --- @param key string The key of the record.
    --- @return KvRecord The record.
    getrecord: (self: KvExecutor, key: string, scopes: {string}?) -> KvRecord,

    --- @yields
    ---
    --- Returns all keys present in this key-value scope.
    ---
    --- This needs the ``kv.meta[SCOPE]:keys`` capability for all scopes provided.
    keys: (self: KvExecutor, scopes: {string}?) -> KvRecordList,

    --- @yields
    ---
    --- Sets a record in the key-value store.
    --- @param key string The key of the record.
    --- @param value any The value of the record.
    --- @return KvRecord The record.
    set: (self: KvExecutor, key: string, value: khronosvalue.KhronosValue, scopes: {string}?) -> nil, -- TODO: Return the created record

    --- @yields
    ---
    --- Deletes a record from this key-value scope
    --- @param key string The key of the record.
    delete: (self: KvExecutor, key: string, scopes: {string}?) -> nil,
}

export type Plugin = KvExecutor

return {}