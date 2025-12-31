--- Proposed interface (not yet implemented)

local datetime = require("@antiraid/datetime")
local lazy = require "@antiraid-core/lazy"
local typesext = require"@antiraid/typesext"

export type Content = { [string]: string }
export type LazyContent = lazy.Lazy<Content>

export type TenantState = {
    --- The list of events the guild is (globally) subscribed to
    events: {string},
    --- boolean flag dictating whether or not we’ve been banned
    banned: boolean,
    --- Extra data (which could include flags such as whether or not we need to fetch templates or not etc.
    data: {[any]: any} | nil,
}

--- Runtime plugin provides basic hooks into the AntiRaid template-worker runtime
export type Plugin = {
    --- Returns a list of VFS's that the runtime exposes
    getexposedvfs: (self: Plugin) -> { [string]: typesext.Vfs },

    --- @yields
    ---
    --- Fetches the TenantState or returns a suitable default
    gettenantstate: (self: Plugin) -> TenantState,

    --- @yields
    ---
    --- Sets the TenantState
    settenantstate: (self: Plugin, state: TenantState) -> (),

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