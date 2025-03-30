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

    --- Finds records in the key-value store.
    --- @param query string The key to search for. % matches zero or more characters; _ matches a single character. To search anywhere in a string, surround {KEY} with %, e.g. %{KEY}%
    --- @return {KvRecord} The records.
    find: (self: KvExecutor, query: string) -> Promise.LuaPromise<KvRecordList>,
    --- Gets a value from the key-value store.
    --- @param key string The key of the record.
    --- @return any The value of the record.
    get: (self: KvExecutor, key: string) -> Promise.LuaPromise<any>,
    --- Gets a record from the key-value store.
    --- @param key string The key of the record.
    --- @return KvRecord The record.
    getrecord: (self: KvExecutor, key: string) -> Promise.LuaPromise<KvRecord>,
    --- Sets a record in the key-value store.
    --- @param key string The key of the record.
    --- @param value any The value of the record.
    --- @return KvRecord The record.
    set: (self: KvExecutor, key: string, value: any) -> Promise.LuaPromise<KvRecord>,
    --- Deletes a record from the key-value store.
    --- @param key string The key of the record.
    delete: (self: KvExecutor, key: string) -> Promise.LuaPromise<nil>,
}

local function new(token: Primitives.TemplateContext, scope: ExecutorScope.ExecutorScope?): KvExecutor
    error("Implemented internally in AntiRaid runtime!")
end

return {
    new = new
}