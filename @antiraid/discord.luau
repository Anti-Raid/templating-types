local Primitives = require "@antiraid-core/primitives"
local discord = require "@discord-types/apiTypes"
local discordRest = require "@discord-types/restTypes"
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

--[[
#[derive(serde::Serialize, Default, serde::Deserialize)]
pub struct EditChannelOptions {
    pub channel_id: serenity::all::ChannelId,
    pub reason: String,
    pub data: EditChannel,
}

#[derive(serde::Serialize, Default, serde::Deserialize)]
pub struct DeleteChannelOptions {
    pub channel_id: serenity::all::ChannelId,
    pub reason: String,
}

#[derive(serde::Serialize, Default, serde::Deserialize)]
pub struct CreateMessageOptions {
    pub channel_id: serenity::all::ChannelId, // Channel *must* be in the same guild
    pub data: CreateMessage,
}

#[derive(serde::Serialize, Default, serde::Deserialize)]
pub struct CreateCommandOptions {
    pub data: CreateCommand,
}

#[derive(serde::Serialize, Default, serde::Deserialize)]
pub struct CreateInteractionResponseOptions {
    pub interaction_id: serenity::all::InteractionId,
    pub interaction_token: String,
    pub data: CreateInteractionResponse,
}
]]--

--- Options for getting a channel in Discord
export type GetChannelOptions = {
    --- The channel ID
    channel_id: discord.Snowflake
}

--- Options for editing a channel in Discord
export type EditChannelOptions = {
    --- The channel ID
    channel_id: discord.Snowflake,
    --- The reason for the edit
    reason: string,
    --- The data to edit the channel with
    data: discordRest.ModifyChannelRequest
}

--- Options for deleting a channel in Discord
export type DeleteChannelOptions = {
    --- The channel ID
    channel_id: discord.Snowflake,
    --- The reason for the deletion
    reason: string
}

--- Options for sending a message to a channel in Discord
export type CreateMessageOptions = {
    --- The channel ID
    channel_id: discord.Snowflake,
    --- The data to send the message with
    data: discordRest.CreateMessageRequest
}

--- Options for creating a command in Discord
export type CreateCommandOptions = {
    --- The data to create the command with
    data: discordRest.CreateGuildApplicationCommandRequest
}

--- Options for creating an interaction response in Discord
export type CreateInteractionResponseOptions = {
    --- The interaction ID
    interaction_id: discord.Snowflake,
    --- The interaction token
    interaction_token: string,
    --- The data to create the interaction response with
    data: discordRest.CreateInteractionRequest
}

--- Lazy<discord.AuditLogObject>
type LazyAuditLogObject = lazy.Lazy<discord.AuditLogObject>
--- Lazy<discord.ChannelObject>
type LazyChannelObject = lazy.Lazy<discord.ChannelObject>
--- Lazy<discord.MessageObject> 
type LazyMessageObject = lazy.Lazy<discord.MessageObject>
--- Lazy<discord.ApplicationCommandObject>
type LazyApplicationCommandObject = lazy.Lazy<discord.ApplicationCommandObject>

--- DiscordExecutor allows templates to access/use the Discord API in a sandboxed form.
export type DiscordExecutor = {
    --- Gets the audit logs
    get_audit_logs: (self: DiscordExecutor, data: GetAuditLogOptions) -> promise.LuaPromise<LazyAuditLogObject>,
    --- Gets a channel
    get_channel: (self: DiscordExecutor, data: GetChannelOptions) -> promise.LuaPromise<LazyChannelObject>, 
    --- Edits a channel
    edit_channel: (self: DiscordExecutor, data: EditChannelOptions) -> promise.LuaPromise<LazyChannelObject>,
    --- Deletes a channel
    delete_channel: (self: DiscordExecutor, data: DeleteChannelOptions) -> promise.LuaPromise<LazyChannelObject>,
    --- Creates a message
    create_message: (self: DiscordExecutor, data: CreateMessageOptions) -> promise.LuaPromise<LazyMessageObject>,
    --- Creates an interaction response
    create_interaction_response: (self: DiscordExecutor, data: CreateInteractionResponseOptions) -> promise.LuaPromise<nil>,
    --- Gets the original interaction response
    get_original_interaction_response: (self: DiscordExecutor, interaction_token: string) -> promise.LuaPromise<LazyMessageObject>,
    --- Gets all guild commands currently registered
    get_guild_commands: (self: DiscordExecutor) -> promise.LuaPromise<LazyApplicationCommandObject>,
    --- Creates a guild command
    create_guild_command: (self: DiscordExecutor, data: CreateCommandOptions) -> promise.LuaPromise<LazyApplicationCommandObject>,
}
 
local function new(token: Primitives.TemplateContext): DiscordExecutor
    error("Implemented internally in AntiRaid runtime!")
end

return {
    new = new
}