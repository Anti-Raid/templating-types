local discord = require("@discord-types/apiTypes")

-- AntiRaid primitives, see https://docs.antiraid.xyz/user/templating/2-plugins#primitives
-- 
-- Last updated: December 30th 2024

-- Core types
export type u8 = number
export type u16 = number
export type u32 = number
export type u64 = number
export type i8 = number
export type i16 = number
export type i32 = number
export type i64 = number
export type f32 = number
export type f64 = number
export type bool = boolean
export type char = string
export type byte = number

--- An event that has been dispatched to the template. 
--- 
--- In templates, this is ``arg``.
export type Event = {
    --- The title name of the event.
    title: string,
    --- The base name of the event.
    base_name: string,
    --- The name of the event.
    name: string,
    --- The data of the event.
    data: any,
    --- Whether the event can be denied.
    is_deniable: boolean,
    --- The unique identifier ID of the event. Will be guaranteed to be unique at a per-guild level.
    uid: string,
    --- The author of the event, if any. If there is no known author, this field will either be `nil` or `null`.
    author: string?
}

--- TemplatePragma contains the pragma of the template. 
--- 
--- Note that the list of fields below in non-exhaustive as templates can define extra fields on the pragma as well
export type TemplatePragma = {
    --- The language of the template.
    lang: string,
    --- The allowed capabilities provided to the template
    allowed_caps: {string},
}

--- TemplateData
export type TemplateData = {
    --- The path of the template
    ---
    --- Official docs say "template token" but this is incorrect and a known doc inaccuracy
    path: string,
    --- The pragma of the template.
    pragma: TemplatePragma,
}

--- TemplateContext is a struct that represents the context of a template. 
--- 
--- Stores data including the templates data, pragma and what capabilities it should have access to. 
---
--- Passing a TemplateContext is often required when using AntiRaid plugins for security purposes.
---
--- **NOTE THAT ALL FIELDS IN TEMPLATECONTEXT ARE READONLY AND WILL NOT CHANGE EVEN IF ATTEMPTED MUTATION
--- DOES NOT RUNTIME ERROR**
export type TemplateContext = {
    --- The data associated with the template.
    read template_data: TemplateData,
    --- The current guild ID the template is running on.
    read guild_id: string,
    --- Returns AntiRaid's discord user object [the current discord bot user driving the template].
    read current_user: discord.UserObject
}


--- Scheduler primitive. Exposed via ``_G.scheduler`` (``@antiraid/concurrency`` re-exports this if you want to avoid casting).
export type Scheduler = {
    --- Adds a thread to the waiting queue
    read addWaiting: (th: thread, resume: f64) -> (),
    --- Adds a thread to the waiting queue with arguments
    read addWaitingWithArgs: (f: (any) -> () | thread, resume: f64, ...any) -> (),
    --- Removes a thread from the waiting queue, returning the number of threads removed
    read removeWaiting: (th: thread) -> u64,
    --- Adds a thread to the deferred queue at the front
    read addDeferredFront: (f: (any) -> () | thread, ...any) -> (),
    --- Adds a thread to the deferred queue at the back
    read addDeferredBack: (f: (any) -> () | thread, ...any) -> (),
    --- Removes a thread from the deferred queue returning the number of threads removed
    read removeDeferred: (th: thread) -> u64,
}

return {}