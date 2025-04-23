--!strict

local khronosvalue = require "@antiraid-core/khronosvalue"
local Promise = require("@antiraid/promise")
local Primitives = require "@antiraid-core/primitives"
local ExecutorScope = require "@antiraid-core/executorscope"

--- A Base DataStore object.
export type DataStore = {
    --- The name of the DataStore
    name: string,
    --- Whether or not a specific operation needs capabilities (either ``datastore:{name}`` or ``datastore:{name}:{operation}``)
    needs_caps: (op: string) -> boolean,
    --- The methods exposed by the DataStore
    methods: () -> { string },
}

--- Datastore to copy a KhronosValue to another KhronosValue
export type CopyDataStore = DataStore & {
    copy: (...khronosvalue.KhronosValue) -> khronosvalue.KhronosValue
}

--- Datastore providing basic statistics
export type StatsStore = DataStore & {
    stats: () -> Promise.LuaPromise<{
        total_cached_guilds: number,
        total_guilds: number,
        total_users: number
    }>
}

export type LinksStore = DataStore & {
    links: () -> {
        support_server: string
    }
}

--- A datastore executor holds DataStore's 
export type DataStoreExecutor = {
    StatsStore: StatsStore?, -- AntiRaid bot only (CLI not supported)
    CopyDataStore: CopyDataStore?, -- Should be present
    LinksStore: LinksStore?, -- AntiRaid bot only (CLI not supported)
    [string]: DataStore?
}

--- Creates a new key-value executor with the desired executor scope and the desired kv scope
---
--- KV scopes allow for fast access to getting/setting/listing keys within a scope without needing expensive and potentially
--- heavily internally ratelimited operations like find() etc. as well as allowing for isolated
--- get/sets (as operations within one scope do not affect other scopes)
---
--- Note that the all keys are scoped. The default scope with the name `unscoped` is used when an explicit named
--- scope is not provided
local function new(token: Primitives.TemplateContext, scope: ExecutorScope.ExecutorScope?): DataStoreExecutor
    error("Implemented internally in AntiRaid runtime!")
end

--- Test code to ensure typings work
--- @skip
local function _test(token: Primitives.TemplateContext) 
    local nd: DataStoreExecutor = new(token) -- Note: due to new type solver things, an explicit type set of DataStoreExecutor is needed
    if nd.StatsStore then 
        nd.StatsStore.stats()
    end
    if nd.CopyDataStore then
        local copy = nd.CopyDataStore.copy(123, "abc", nil, { a = 1, b = 2 }, vector.create(1, 2, 3))
        assert(copy)
    end
end

return {
    new = new
}
