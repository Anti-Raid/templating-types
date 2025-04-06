assert(require)
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
    --- The base name of the event.
    base_name: string,
    --- The name of the event.
    name: string,
    --- The data of the event.
    data: any,
    --- The author of the event, if any.
    author: string?
}

--[[
    /// The guild id the template is in
    pub guild_id: serenity::all::GuildId,
    /// The name of the template
    pub name: String,
    /// The description of the template
    pub description: Option<String>,
    /// The name of the template as it appears on the template shop listing
    pub shop_name: Option<String>,
    /// The owner of the template on the template shop
    pub shop_owner: Option<serenity::all::GuildId>,
    /// The events that this template listens to
    pub events: Vec<String>,
    /// The channel to send errors to
    pub error_channel: Option<serenity::all::ChannelId>,
    /// The content of the template
    pub content: String,
    /// The language of the template
    pub lang: TemplateLanguage,
    /// The allowed capabilities the template has access to
    pub allowed_caps: Vec<String>,
    /// The user who created the template
    pub created_by: String,
    /// The time the template was created
    pub created_at: chrono::DateTime<chrono::Utc>,
    /// The user who last updated the template
    pub updated_by: String,
    /// The time the template was last updated
    pub updated_at: chrono::DateTime<chrono::Utc>,
]]--

--- Template data. This is subject to change and should only be used for debugging purposes.
export type Template = {
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
    --- The content of the template.
    content: string,
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
    --- The data associated with the template. Subject to change and should only be used for debugging purposes.
    read data: Template,
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
}


--- Scheduler primitive. Exposed via ``_G.scheduler`` (``@antiraid/concurrency`` re-exports this if you want to avoid casting).
export type Scheduler = {
    --- Adds a thread to the waiting queue
    read addWaitingWait: (th: thread, resume: f64) -> (),
    --- Adds a thread to the waiting queue with arguments
    read addWaitingDelay: (f: (any) -> () | thread, resume: f64, ...any) -> (),
    --- Removes a thread from the waiting queue, returning the number of threads removed
    read removeWaiting: (th: thread) -> u64,
    --- Adds a thread to the deferred queue at the front
    read addDeferredFront: (f: (any) -> () | thread, ...any) -> (),
    --- Adds a thread to the deferred queue at the back
    read addDeferredBack: (f: (any) -> () | thread, ...any) -> (),
    --- Removes a thread from the deferred queue returning the number of threads removed
    read removeDeferred: (th: thread) -> u64,
}

local function scheduler(): Scheduler
    return (_G["scheduler"] :: Scheduler) or error("Scheduler not found")
end

return {
    scheduler = scheduler,
}
