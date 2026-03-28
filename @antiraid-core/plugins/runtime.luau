--!strict
--- Proposed interface (not yet implemented)

local datetime = require("@antiraid/datetime")
local typesext = require"@antiraid/typesext"
local khronosvalue = require "@antiraid-core/khronosvalue"

--- A result from a state operation
export type StateExecResult = {
    op: "Kv",

    --- The key of the record.
    key: string,
    --- The value of the record. This can be any type, depending on what was stored.
    value: khronosvalue.KhronosValue,
    --- The scopes the key has
    scope: string,
    --- The timestamp when the record was created, in ISO 8601 format.
    created_at: datetime.DateTime,
    --- The timestamp when the record was last updated, in ISO 8601 format.
    last_updated_at: datetime.DateTime,
} | {
    op: "GlobalKv",

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
    read public_metadata: any,

    --- Contents of vfs is readable or not (paid templates)
    read public_data: boolean,

    --- Review state of the record (pending, approved, rejected)
    read review_state: string,

    --- An optional long description of the record
    read long: string?,

    --- An optional price for the record (if the record is for sale)
    read price: number?,

    --- The timestamp when the record was created
    read created_at: datetime.DateTime,

    --- The timestamp when the record was last updated at
    read last_updated_at: datetime.DateTime,
} | {
    op: "GlobalKvData",
    data: any
} | {
    op: "GlobalKvDataOpaque",
    data: any, -- todo: add opaque type,
}

export type TenantState = {
    --- The list of events the guild is (globally) subscribed to
    events: {string},
    --- Flags (such as whether we need to load in more data etc.)
    flags: number
}

export type StateOp = {
    op: "KvFind",
    query: string,
    scope: string
} | {
    op: "KvGet",
    key: string,
    scope: string
} | {
    op: "KvSet",
    key: string,
    scope: string,
    value: khronosvalue.KhronosValue
} | {
    op: "KvDelete",
    key: string,
    scope: string
} | {
    op: "UpdateTenantState",
    events: {string},
    flags: number
} | {
    op: "GlobalKvFind",
    query: string,
    scope: string
} | {
    op: "GlobalKvGet",
    key: string,
    version: number,
    scope: string
} | {
    op: "GlobalKvCreate",
    key: string,
    version: number,
    short: string,
    public_metadata: khronosvalue.KhronosValue,
    scope: string,
    public_data: boolean,
    long: string?,
    data: khronosvalue.KhronosValue
} | {
    op: "GlobalKvDelete",
    key: string,
    version: number,
    scope: string
}

--- Runtime plugin provides basic hooks into the AntiRaid template-worker runtime
export type Plugin = {
    --- Returns a list of VFS's that the runtime exposes
    getexposedvfs: (self: Plugin) -> { [string]: typesext.Vfs },

    --- @yields
    ---
    --- Executes a state operation
    execstate: (self: Plugin, op: {StateOp}) -> {StateExecResult},

    --- @yields
    ---
    --- Returns the statistics of the bot.
    stats: (self: Plugin) -> {
        total_cached_guilds: number,
        total_guilds: number,
        total_users: number,
        last_started_at: datetime.DateTime,
    },

    --- Returns various important links
    --- of the bot
    links: (self: Plugin) -> {
        support_server: string,
        api_url: string,
        frontend_url: string,
        docs_url: string,
    },

    --- Returns the list of events the bot can dispatch
    eventlist: (self: Plugin) -> {string},
}

return {}