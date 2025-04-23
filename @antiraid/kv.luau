local Promise = require("@antiraid/promise")
local Primitives = require "@antiraid-core/primitives"
local ExecutorScope = require "@antiraid-core/executorscope"

--- KvRecord represents a key-value record with metadata.
---@class KvRecord
export type KvRecord = {
    --- The key of the record.
    key: string,
    --- The value of the record. This can be any type, depending on what was stored.
    value: any,
    --- Indicates whether the record exists in the key-value store.
    exists: boolean,
    --- The timestamp when the record was created, in ISO 8601 format (e.g., "2023-10-01T12:00:00Z").
    created_at: string,
    --- The timestamp when the record was last updated, in ISO 8601 format (e.g., "2023-10-01T12:00:00Z").
    last_updated_at: string,
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
    --- The scope of the executor.
    read scope: ExecutorScope.ExecutorScope,

    --- Returns a list of all key-value scopes/
    --- This is only guaranteed to return scopes that actually have at least one key inside it.
    ---
    --- Needs the `kv.meta:list_scopes` capability to use
    list_scopes: (self: KvExecutor) -> {string},

    --- Finds matching records in this key-value scope.
    --- @param query string The key to search for. % matches zero or more characters; _ matches a single character. To search anywhere in a string, surround {KEY} with %, e.g. %{KEY}%
    --- @return {KvRecord} The records.
    find: (self: KvExecutor, query: string) -> Promise.LuaPromise<KvRecordList>,
    --- Gets a value from this key-value scope.
    --- @param key string The key of the record.
    --- @return any The value of the record.
    get: (self: KvExecutor, key: string) -> Promise.LuaPromise<any>,
    --- Gets a record from this key-value scope.
    --- @param key string The key of the record.
    --- @return KvRecord The record.
    getrecord: (self: KvExecutor, key: string) -> Promise.LuaPromise<KvRecord>,
    --- Returns all keys present in this key-value scope.
    ---
    --- This needs the ``kv.meta:{SCOPE}:keys`` capability where `{SCOPE}` is the name of the scope
    --- being accessed
    keys: (self: KvExecutor) -> Promise.LuaPromise<KvRecordList>,
    --- Sets a record in the key-value store.
    --- @param key string The key of the record.
    --- @param value any The value of the record.
    --- @return KvRecord The record.
    set: (self: KvExecutor, key: string, value: any) -> Promise.LuaPromise<nil>, -- TODO: Return the created record
    --- Deletes a record from this key-value scope
    --- @param key string The key of the record.
    delete: (self: KvExecutor, key: string) -> Promise.LuaPromise<nil>,
}

--- Creates a new key-value executor with the desired executor scope and the desired kv scope
---
--- KV scopes allow for fast access to getting/setting/listing keys within a scope without needing expensive and potentially
--- heavily internally ratelimited operations like find() etc. as well as allowing for isolated
--- get/sets (as operations within one scope do not affect other scopes)
---
--- Note that the all keys are scoped. The default scope with the name `unscoped` is used when an explicit named
--- scope is not provided
local function new(token: Primitives.TemplateContext, scope: ExecutorScope.ExecutorScope?, kv_scope: string?): KvExecutor
    error("Implemented internally in AntiRaid runtime!")
end

return {
    new = new
}