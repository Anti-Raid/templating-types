local discord = require("@discord-types/apiTypes")
local runtimeP = require("@antiraid-core/plugins/runtime")
local discordP = require("@antiraid-core/plugins/discord")
local httpclientP = require("@antiraid-core/plugins/httpclient")

-- AntiRaid primitives
-- 
-- Last updated: June 22nd 2025

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
    --- The name of the event.
    name: string,
    --- The authorized author of the event.
    ---
    --- Will be nil for events that are not explicitly user-authorized (e.g. using the website)
    author: string?,
    --- The data of the event.
    data: any,
}

--- TemplateContext is a struct that represents the context of a template. 
--- 
--- Stores key data including the templates data, pragma and what capabilities it should have access to. 
---
--- Passing a TemplateContext is often required when using AntiRaid plugins for getting the inner context
--- of a template.
export type TemplateContext = {
    --- Runtime plugin
    read Runtime: runtimeP.Plugin,
    --- Discord plugin
    read Discord: discordP.Plugin,
    --- HTTP Client plugin
    read HTTPClient: httpclientP.Plugin,

    --- Returns the memory limit the VM has/the amount of memory the VM is allowed to use
    read memory_limit: u64,
    --- The capabilities the template has access to.   
    read allowed_caps: {string},
    --- Returns AntiRaid's discord user object [the current discord bot user driving the template].
    read current_user: discord.UserObject,

    --- The global/common store table shared across all templates within the same
    --- server
    store: {[any]: any},
}

return {}
