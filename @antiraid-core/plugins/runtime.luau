--- Proposed interface (not yet implemented)

local datetime = require("@antiraid/datetime")
local lazy = require "@antiraid-core/lazy"
local typesext = require"@antiraid/typesext"

type Content = { [string]: string }
type LazyContent = lazy.Lazy<Content>

type TemplateOwner = {
    type: "user",
    id: string
} | {
    type: "guild",
    id: string,
}

type TemplateSource = {
    type: "shop",

    --- The shop listing ID
    shop_listing: string,
} | {
    type: "custom",

    --- Name of the template
    name: string,

    --- Template language
    language: "luau",

    --- Template Content
    content: LazyContent
} | {
    type: "builtins" -- This is a virtual source used to denote the 'builtins' core template
}

--- A Template object.
export type Template = {
    --- The ID of the template attachment
    id: string,

    --- The owner of the template, usage wise
    owner: TemplateOwner,

    --- The template attachment source
    source: TemplateSource,

    --- The date and time when the template was created
    created_at: datetime.DateTime,

    --- The date and time when the template was last updated
    last_updated_at: datetime.DateTime,

    --- The capabilities allowed for this template
    allowed_caps: { string },

    --- The precomputed VFS of the template
    vfs: typesext.Vfs,

    --- Whether or not the template is paused
    paused: boolean,
}

type CreateTemplateSource = {
    type: "shop",

    --- The shop listing ID
    shop_listing: string,
} | {
    type: "custom",

    --- Name of the template
    name: string,

    --- Template language
    language: "luau",

    --- Template Content
    content: LazyContent
}

--- A CreateTemplate object.
export type CreateTemplate = {
    --- The template attachment source
    source: CreateTemplateSource,

    --- The capabilities allowed for this template
    allowed_caps: { string },

    --- Whether or not the template is paused
    paused: boolean,
}

export type TenantState = {
    --- The list of events the guild is (globally) subscribed to
    events: {string},
    --- boolean flag dictating whether or not we’ve been banned
    banned: boolean,
    --- a Luau-defined set of additional flags (includes whether or not we need to fetch templates or not etc.
    flags: number,
    --- boolean flag dictating whether we need to dispatch startup events for this guild or not
    startup_events: boolean,
}

--- Runtime plugin provides basic hooks into the AntiRaid template-worker runtime
export type Plugin = {
    --- @yields
    ---
    --- Lists all templates
    listtemplates: (self: Plugin) -> { Template },

    --- @yields
    ---
    --- Gets a template by name
    gettemplate: (self: Plugin, id: string) -> Template?,

    --- @yields
    ---
    --- Creates an existing template
    createtemplate: (self: Plugin, template: CreateTemplate) -> nil,

    --- @yields
    ---
    --- Creates an existing template
    updatetemplate: (self: Plugin, id: string, template: CreateTemplate) -> nil,

    --- @yields
    ---
    --- Deletes a template by name
    deletetemplate: (self: Plugin, id: string) -> nil,

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