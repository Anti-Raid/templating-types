local Promise = require("@antiraid/promise")
local Primitives = require "@antiraid-core/primitives"
local ExecutorScope = require "@antiraid-core/executorscope"

--- KvRecord represents a key-value record with metadata.
---@class KvRecord
---@field key string The key of the record.
---@field value any The value of the record.
---@field exists boolean Whether the record exists.
---@field created_at string The timestamp when the record was created.
---@field last_updated_at string The timestamp when the record was last updated.
export type KvRecord = {
    key: string,
    value: any,
    exists: boolean,
    created_at: string,
    last_updated_at: string,
}

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
    find: (self: KvExecutor, query: string) -> Promise.LuaPromise<{KvRecord}>,
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