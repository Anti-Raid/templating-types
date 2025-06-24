local discord = require("@discord-types/apiTypes")
local datastoresP = require("@antiraid-core/plugins/datastores")
local discordP = require("@antiraid-core/plugins/discord")
local imgcaptchaP = require("@antiraid-core/plugins/img_captcha")
local kvP = require("@antiraid-core/plugins/kv")
local lockdownsP = require("@antiraid-core/plugins/lockdowns")
local objectstorageP = require("@antiraid-core/plugins/objectstorage")
local pagesP = require("@antiraid-core/plugins/pages")
local userinfoP = require("@antiraid-core/plugins/userinfo")

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
    --- The data of the event.
    data: any,
    --- The author of the event, if any.
    author: string?
}

--- Information about a script
export type ScriptData = {
    --- The guild ID the template is in.
    guild_id: string,
    --- The name of the template.
    name: string,
    --- The description of the template.
    description: string?,
    --- The name of the template as it appears on the template shop listing.
    shop_name: string?,
    --- The owner of the template on the template shop.
    shop_owner: string?,
    --- The events that this template listens to.
    events: {string},
    --- The channel to send errors to.
    error_channel: string?,
    --- The language of the template.
    lang: string,
    --- The allowed capabilities the template has access to.
    allowed_caps: {string},
    --- The user who created the template.
    created_by: string,
    --- The time the template was created.
    created_at: string,
    --- The user who last updated the template.
    updated_by: string,
    --- The time the template was last updated.
    updated_at: string,
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
    --- Lockdowns plugin
    read Lockdowns: lockdownsP.Plugin,
    --- Object Storage plugin
    read ObjectStorage: objectstorageP.Plugin,
    --- Pages plugin
    read Pages: pagesP.Plugin,
    --- User Info plugin
    read UserInfo: userinfoP.Plugin,

    --- The public data associated with the script.
    read data: ScriptData,
    --- Returns the memory limit the VM has/the amount of memory the VM is allowed to use
    read memory_limit: u64,
    --- The current guild ID the template is running on.
    read guild_id: string,
    --- The owner guild ID of the template, if any. For shop templates, this will be the guild ID of the guild which owns the template on the shop
    --- For guild-owned templates, this will be the guild ID of the guild which owns the template [the same as guild_id]
    read owner_guild_id: string,
    --- The name of the template itself
    read template_name: string,
    --- The capabilities the template has access to.   
    read allowed_caps: {string},
    --- Returns AntiRaid's discord user object [the current discord bot user driving the template].
    read current_user: discord.UserObject,
    --- Returns if a template has a specific capability.
    read has_cap: (self: TemplateContext, cap: string) -> boolean,
    --- The global/common store table shared across all templates within the same
    --- server
    store: {},
}

return {}
