--!strict

local khronosvalue = require "@antiraid-core/khronosvalue"
local datetime = require("@antiraid/datetime")

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
    --- @yields
    ---
    --- Returns the statistics of the bot.
    stats: () -> {
        total_cached_guilds: number,
        total_guilds: number,
        total_users: number,
        last_started_at: datetime.DateTime,
    }
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
}

export type Plugin = DataStoreExecutor

return {}
