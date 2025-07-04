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
        support_server: string,
        api_url: string,
        frontend_url: string,
        docs_url: string,
    }
}

-- Jobserver

export type Spawn = {
    --- The name of the job
    name: string,
    --- The data to be used in the job
    data: khronosvalue.KhronosValue,
    --- Whether or not to create the job if it does not exist
    create: boolean,
    --- Whether or not to execute the job immediately
    execute: boolean,
    --- If create is false, this is required
    id: string?,
}

--- Jobsrver Status
export type Statuses = {
    level: string,
    msg: string,
    --- Timestamp in seconds
    ts: number,
    --- ptional list of fields to ignore
    bot_display_ignore: { string }?,
    -- Extra information as a key-value map 
    extra_info: { [string]: khronosvalue.KhronosValue }, 
}

export type Output = {
    filename: string,
    --- Temporary flag for migrations
    perguild: boolean? 
}

--- Jobserver Job
export type Job = {
    id: string,
    name: string,
    output: Output?,
    fields: { [string]: any },
    statuses: {Statuses},
    guild_id: string,
    expiry: datetime.TimeDelta?,
    state: string,
    resumable: boolean,
    created_at: datetime.DateTime,
    job_path: string,
    job_file_path: string?
}

export type JobServerStore = DataStore & {
    --- @yields
    ---
    --- Spawns a new job on the jobserver returning the job ID.
    spawn: (spawn: Spawn) -> string,

    --- @yields
    ---
    --- Lists all jobs created for this server
    ---
    --- If needs_statuses is set to true, then statuses are sent, otherwise
    ---- the statuses will be an empty table to reduce memory consumption
    list: (needs_statuses: boolean?) -> {Job},

    --- @yields
    ---
    --- Lists all jobs created for this server with the given task name
    ---
    --- If needs_statuses is set to true, then statuses are sent, otherwise
    ---- the statuses will be an empty table to reduce memory consumption
    list_named: (name: string, needs_statuses: boolean?) -> {Job},

    --- @yields
    ---
    --- Gets a job from jobserver given its job ID
    ---
    --- If needs_statuses is set to true, then statuses are sent, otherwise
    ---- the statuses will be an empty table to reduce memory consumption
    get: (id: string, needs_statuses: boolean?) -> Job,

    --- @yields
    ---
    --- Deletes a job given its job ID
    delete: (id: string) -> nil
}

--- A Template object.
export type Template = {
    --- The name of the template
    name: string,
    --- The events that trigger the template
    events: { string },
    --- The channel to send errors to
    error_channel: string?,
    --- The content of the template
    content: { [string]: string },
    --- The language of the template
    lang: string,
    --- The capabilities allowed for this template
    allowed_caps: { string },
    --- The date and time when the template was created
    created_at: datetime.DateTime,
    --- The date and time when the template was last updated
    updated_at: datetime.DateTime,
    --- Whether or not the template is paused
    paused: boolean,
}

--- A CreateTemplate object.
export type CreateTemplate = {
    --- The name of the template
    name: string,
    --- The events that trigger the template
    events: { string },
    --- The channel to send errors to
    error_channel: string?,
    --- The content of the template
    content: { [string]: string },
    --- The language of the template
    lang: string,
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
    CopyDataStore: CopyDataStore?, -- Should be present
    LinksStore: LinksStore?, -- AntiRaid bot only (CLI not supported)
    JobServerStore: JobServerStore?, -- AntiRaid bot only (CLI not supported)
    TemplateStore: TemplateStore?, -- AntiRaid bot only (CLI not supported)
}

export type Plugin = DataStoreExecutor

return {}
