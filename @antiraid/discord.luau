local Primitives = require "@antiraid-core/primitives"
local Promise = require "@antiraid/promise"
local Stream = require "@antiraid/stream"
local discord = require "@discord-types/apiTypes"

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

--- A handle to a message in Discord, as represented by AntiRaid. Internal fields are subject to change
export type MessageHandle = {
    --- Gets the data of the message
    data: (self: MessageHandle) -> discord.MessageObject,
    --- Awaits a component interaction on the message
    await_component_interaction: (self: MessageHandle) -> Stream.LuaStream<MessageComponentHandle>,
}

--- A handle to a message component interaction in Discord, as represented by AntiRaid. Internal fields are subject to change
export type MessageComponentHandle = {
    --- The inner data of the message component interaction
    data: (self: MessageComponentHandle) -> discord.InteractionDataObject,
    --- The custom ID of the message component interaction
    custom_id: (self: MessageComponentHandle) -> string,
}

--- Options for sending a message in a channel in Discord
export type SendMessageChannelAction = {
    channel_id: discord.Snowflake,
    data: CreateMessage
}

--- DiscordExecutor allows templates to access/use the Discord API in a sandboxed form.
export type DiscordExecutor = {
    --- Gets the audit logs
    get_audit_logs: (self: DiscordExecutor, data: GetAuditLogOptions) -> Promise.LuaPromise<discord.AuditLogObject>,
    --- Gets a channel
    get_channel: (self: DiscordExecutor, data: GetChannelOptions) -> Promise.LuaPromise<discord.ChannelObject>,
    --- Edits a channel
    edit_channel: (self: DiscordExecutor, data: EditChannelOptions) -> Promise.LuaPromise<discord.ChannelObject>,
    --- Edits a thread
    edit_thread: (self: DiscordExecutor, data: EditThreadOptions) -> Promise.LuaPromise<discord.ChannelObject>,
    --- Deletes a channel
    delete_channel: (self: DiscordExecutor, data: DeleteChannelOptions) -> Promise.LuaPromise<discord.ChannelObject>,
    --- Creates a message
    create_message: (self: DiscordExecutor, data: SendMessageChannelAction) -> Promise.LuaPromise<MessageHandle>,
}

local function new(token: Primitives.TemplateContext): DiscordExecutor
    error("Implemented internally in AntiRaid runtime!")
end

return {
    new = new
}