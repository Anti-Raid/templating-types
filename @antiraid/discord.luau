local Primitives = require "@antiraid-core/primitives"
local discord = require "@discord-types/apiTypes"
local lazy = require "@antiraid/lazy"
local promise = require "@antiraid/promise"
 
--- @class GetAuditLogOptions
--- @field action_type discord.AuditLogEventType? The action type to filter by
--- @field user_id discord.Snowflake? The user ID to filter by
--- @field before discord.Snowflake? The audit log entry ID to filter before
--- @field limit number? The number of entries to return
--- Options for getting audit logs in Discord
export type GetAuditLogOptions = {
    --- The action type to filter by
    action_type: discord.AuditLogEventType?,
    user_id: discord.Snowflake?,
    before: discord.Snowflake?,
    limit: number?
}

--- Options for getting a channel in Discord
export type GetChannelOptions = {
    --- The channel ID
    channel_id: discord.Snowflake
}

--- Options for editing a channel in Discord
export type EditChannelOptions = {
    channel_id: discord.Snowflake,
    reason: string,
    name: string?,
    type: number?,
    position: number?,
    topic: string?,
    nsfw: boolean?,
    rate_limit_per_user: number?,
    bitrate: number?,
    permission_overwrites: discord.OverwriteObject?,
    parent_id: discord.Snowflake?,
    rtc_region: string?,
    video_quality_mode: number?,
    default_auto_archive_duration: number?,
    flags: string?,
    available_tags: discord.ForumTagObject?,
    default_reaction_emoji: discord.DefaultReactionObject?,
    default_thread_rate_limit_per_user: number?,
    default_sort_order: number?,
    default_forum_layout: number?
}

--- Options for editing a thread in Discord
export type EditThreadOptions = {
    channel_id: discord.Snowflake,
    reason: string,
    name: string?,
    archived: boolean?,
    auto_archive_duration: number?,
    locked: boolean?,
    invitable: boolean?,
    rate_limit_per_user: number?,
    flags: string?,
    applied_tags: discord.ForumTagObject?
}

--- Options for deleting a channel in Discord
export type DeleteChannelOptions = {
    channel_id: discord.Snowflake,
    reason: string
}

--- Options for creating a message in Discord
export type CreateMessage = {
    --- The embeds of the message
    embeds: {CreateMessageEmbed}?,
    --- The content of the message
    content: string?,
    --- The attachments of the message  
    attachments: {CreateMessageAttachment}?,
}  

--- An embed in a message
export type CreateMessageEmbed = {
    --- The title of the embed
    title: string?,
    --- The description of the embed
    description: string?,
    --- The URL of the embed
    url: string?,
    --- The timestamp of the embed
    timestamp: string?,
    --- The color of the embed
    color: number?,
    --- The footer of the embed
    footer: CreateMessageEmbedFooter?,
    --- The image URL of the embed
    image: string?,
    --- The thumbnail URL of the embed
    thumbnail: string?,
    --- The author of the embed
    author: CreateMessageEmbedAuthor?,
    --- The fields of the embed
    fields: {CreateMessageEmbedField}?,
}

--- A footer in a message embed
export type CreateMessageEmbedFooter = {
    --- The text of the footer
    text: string,
    --- The icon URL of the footer
    icon_url: string?,
}

--- An author in a message embed
export type CreateMessageEmbedAuthor = {
    --- The name of the author
    name: string,
    --- The URL of the author
    url: string?,
    --- The icon URL of the author
    icon_url: string?,
}

--- A field in a message embed
export type CreateMessageEmbedField = {
    --- The name of the field
    name: string,
    --- The value of the field
    value: string,
    --- Whether the field should be inline
    inline: boolean?,
}

--- An attachment in a message
export type CreateMessageAttachment = {
    --- The filename of the attachment
    filename: string,
    --- The description (if any) of the attachment
    description: string?,
    --- The content of the attachment
    content: {Primitives.byte},
}

--- Options for sending a message in a channel in Discord
export type SendMessageChannelAction = {
    channel_id: discord.Snowflake,
    data: CreateMessage
}

type LazyAuditLogObject = lazy.Lazy<discord.AuditLogObject>
type LazyChannelObject = lazy.Lazy<discord.ChannelObject> 
type LazyMessageObject = lazy.Lazy<discord.MessageObject>

--- DiscordExecutor allows templates to access/use the Discord API in a sandboxed form.
export type DiscordExecutor = {
    --- Gets the audit logs
    get_audit_logs: (self: DiscordExecutor, data: GetAuditLogOptions) -> promise.LuaPromise<LazyAuditLogObject>,
    --- Gets a channel
    get_channel: (self: DiscordExecutor, data: GetChannelOptions) -> promise.LuaPromise<LazyChannelObject>, 
    --- Edits a channel
    edit_channel: (self: DiscordExecutor, data: EditChannelOptions) -> promise.LuaPromise<LazyChannelObject>,
    --- Edits a thread
    edit_thread: (self: DiscordExecutor, data: EditThreadOptions) -> promise.LuaPromise<LazyChannelObject>,
    --- Deletes a channel
    delete_channel: (self: DiscordExecutor, data: DeleteChannelOptions) -> promise.LuaPromise<LazyChannelObject>,
    --- Creates a message
    create_message: (self: DiscordExecutor, data: SendMessageChannelAction) -> promise.LuaPromise<LazyMessageObject>,
}
 
local function new(token: Primitives.TemplateContext): DiscordExecutor
    error("Implemented internally in AntiRaid runtime!")
end

return {
    new = new
}