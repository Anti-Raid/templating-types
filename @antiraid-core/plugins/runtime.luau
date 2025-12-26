--- Proposed interface (not yet implemented)

local datetime = require("@antiraid/datetime")
local lazy = require "@antiraid-core/lazy"

--- A Template object.
export type Template = {
    --- The name of the template
    name: string,
    --- The content of the template
    content: LazyContent,
    --- The language of the template
    language: string,
    --- The capabilities allowed for this template
    allowed_caps: { string },
    --- The date and time when the template was created
    created_at: datetime.DateTime,
    --- The date and time when the template was last updated
    updated_at: datetime.DateTime,
    --- Whether or not the template is paused
    paused: boolean,
}

type Content = { [string]: string }
type LazyContent = lazy.Lazy<Content>

--- A CreateTemplate object.
export type CreateTemplate = {
    --- The name of the template
    name: string,
    --- The content of the template
    content: { [string]: string } | LazyContent,
    --- The language of the template
    language: string,
    --- The capabilities allowed for this template
    allowed_caps: { string },
    --- Whether or not the template is paused
    paused: boolean,
}

type TenantState = {
    --- The list of events the guild is (globally) subscribed to
    events: {string},
    --- boolean flag dictating whether or not we’ve been banned
    banned: boolean,
    --- a Luau-defined set of additional flags (includes whether or not we need to fetch templates or not etc.
    flags: number,
    --- boolean flag dictating whether we need to dispatch startup events for this guild or not
    startup_events: boolean,
}

--- A TemplateExecutor object.
export type RuntimeService = {
    --- @yields
    ---
    --- Lists all templates
    listtemplates: () -> { Template },

    --- @yields
    ---
    --- Gets a template by name
    gettemplate: (name: string) -> Template?,

    --- @yields
    ---
    --- Creates or updates an existing template
    settemplate: (template: CreateTemplate) -> nil,

    --- @yields
    ---
    --- Deletes a template by name
    deletetemplate: (name: string) -> nil,

    --- @yields
    ---
    --- Fetches the TenantState
    gettenantstate: () -> TenantState?,
    --- @yields
    ---
    --- Sets the TenantState
    settenantstate: (state: TenantState) -> (),

    --- @yields
    ---
    --- Returns the statistics of the bot.
    stats: () -> {
        total_cached_guilds: number,
        total_guilds: number,
        total_users: number,
        last_started_at: datetime.DateTime,
    },

    --- Returns various important links
    --- of the bot
    links: () -> {
        support_server: string,
        api_url: string,
        frontend_url: string,
        docs_url: string,
    },

    --- Returns the list of events the bot can dispatch
    event_list: () -> {string},
}
