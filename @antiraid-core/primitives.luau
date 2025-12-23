local discord = require("@discord-types/apiTypes")
local datastoresP = require("@antiraid-core/plugins/datastores")
local discordP = require("@antiraid-core/plugins/discord")
local imgcaptchaP = require("@antiraid-core/plugins/img_captcha")
local kvP = require("@antiraid-core/plugins/kv")
local objectstorageP = require("@antiraid-core/plugins/objectstorage")
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
    --- The base name of the event.
    base_name: string,
    --- The name of the event.
    name: string,
    --- The scopes of the event or nil if no scopes are set.
    scopes: {string}?,
    --- The data of the event.
    data: any,
    --- The author of the event, if any.
    author: string?
}

export type ExtContextData = {
    template_name: string,
    events: {string},
}

export type With = {
    --- Capabilities that the template has access to.
    capabilities: {string},
    --- The TFlags to set
    tflags: {string}?,
    --- The extra context data to set
    ext_data: ExtContextData?,
}

--- TemplateContext is a struct that represents the context of a template. 
--- 
--- Stores key data including the templates data, pragma and what capabilities it should have access to. 
---
--- Passing a TemplateContext is often required when using AntiRaid plugins for getting the inner context
--- of a template.
export type TemplateContext = {
    --- DataStores plugin
    read DataStores: datastoresP.Plugin,
    --- Discord plugin
    read Discord: discordP.Plugin,
    --- Image Captcha plugin
    read ImageCaptcha: imgcaptchaP.Plugin,
    --- Key-Value plugin
    read KV: kvP.Plugin,
    --- Object Storage plugin
    read ObjectStorage: objectstorageP.Plugin,
    --- HTTP Client plugin
    read HTTPClient: httpclientP.Plugin,

    --- Returns the memory limit the VM has/the amount of memory the VM is allowed to use
    read memory_limit: u64,
    --- The current guild ID the template is running on.
    read guild_id: string,
    --- The name of the template itself
    read template_name: string,
    --- The events the template has access to
    read events: {string},
    --- The capabilities the template has access to.   
    read allowed_caps: {string},
    --- Returns AntiRaid's discord user object [the current discord bot user driving the template].
    read current_user: discord.UserObject,
    --- Returns if a template has a specific capability.
    read has_cap: (self: TemplateContext, cap: string) -> boolean,
    --- Returns if a template has any of the specified capabilities.
    read has_any_cap: (self: TemplateContext, caps: {string}) -> boolean,
    --- Returns a new TemplateContext with the specified limits which must be a strict subset
    --- of the current context's limits.
    read with: (self: TemplateContext, data: With) -> TemplateContext,
    --- Returns the event present within the TemplateContext
    read event: (self: TemplateContext) -> Event,

    --- The global/common store table shared across all templates within the same
    --- server
    store: {},
}

return {}
