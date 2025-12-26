--!strict

local datetime = require("@antiraid/datetime")
local lazy = require "@antiraid-core/lazy"

--- A Base DataStore object.
export type DataStore = {
    --- The name of the DataStore
    name: string,
    --- Whether or not a specific operation needs capabilities (either ``datastore:{name}`` or ``datastore:{name}:{operation}``)
    needs_caps: (op: string) -> boolean,
    --- The methods exposed by the DataStore
    methods: () -> { string },
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
        support_server: string,
        api_url: string,
        frontend_url: string,
        docs_url: string,
    },
    event_list: () -> { string },
}

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

--- A TemplateStore object.
export type TemplateStore = DataStore & {
    --- @yields
    ---
    --- Lists all templates
    list: () -> { Template },

    --- @yields
    ---
    --- Gets a template by name
    get: (name: string) -> Template?,

    --- @yields
    ---
    --- Creates a new template
    create: (template: CreateTemplate) -> nil,

    --- @yields
    ---
    --- Updates an existing template
    update: (template: CreateTemplate) -> nil,

    --- @yields
    ---
    --- Deletes a template by name
    delete: (name: string) -> nil,
}

--- A datastore executor holds DataStore's 
export type DataStoreExecutor = {
    StatsStore: StatsStore?, -- AntiRaid bot only (CLI not supported)
    LinksStore: LinksStore?, -- AntiRaid bot only (CLI not supported)
    TemplateStore: TemplateStore?, -- AntiRaid bot only (CLI not supported)
}

export type Plugin = DataStoreExecutor

return {}
