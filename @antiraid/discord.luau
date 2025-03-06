local Primitives = require "@antiraid-core/primitives"
local discord = require "@discord-types/apiTypes"
local discordRest = require "@discord-types/restTypes"
local lazy = require "@antiraid/lazy"
local promise = require "@antiraid/promise"
local typesext = require "@antiraid/typesext"
local ExecutorScope = require "@antiraid-core/executorscope"

--- Options for getting audit logs in Discord
export type GetAuditLogOptions = {
    --- The action type to filter by
    action_type: discord.AuditLogEventType?,
    --- The user ID to filter by
    user_id: discord.Snowflake?,
    --- The audit log entry ID to filter
    before: discord.Snowflake?,
    --- The number of entries to return
    limit: number?
}

--- Options for getting an auto moderation rule in Discord
export type GetAutoModerationRuleOptions = {
    --- The rule ID
    rule_id: discord.Snowflake
}

--- Options for creating an auto moderation rule in Discord
export type CreateAutoModerationRuleOptions = {
    --- The reason for creating the rule
    reason: string,
    --- The data to create the rule with
    data: discordRest.CreateAutoModerationRuleRequest
}

--- Options for editing an auto moderation rule in Discord
export type EditAutoModerationRuleOptions = {
    --- The rule ID
    rule_id: discord.Snowflake,
    --- The reason for editing the rule
    reason: string,
    --- The data to edit the rule with
    data: discordRest.ModifyAutoModerationRuleRequest
}

--- Options for deleting an auto moderation rule in Discord
export type DeleteAutoModerationRuleOptions = {
    --- The rule ID
    rule_id: discord.Snowflake,
    --- The reason for deleting the rule
    reason: string
}

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

--- Options for editting channel permissions
export type EditChannelPermissionsOptions = {
    --- The channel ID
    channel_id: discord.Snowflake,
    --- The target ID to edit permissions of
    target_id: discord.Snowflake,
    --- The allow permissions
    allow: typesext.MultiOption<string>,
    --- The deny permissions
    deny: typesext.MultiOption<string>,
    --- The type of the target
    kind: discord.OverwriteObjectType,
    --- The reason for the edit
    reason: string,
}

--- Options for adding a role to a member
export type AddGuildMemberRoleOptions = {
    --- The member ID
    user_id: discord.Snowflake,
    --- The role ID
    role_id: discord.Snowflake,
    --- The reason for adding the role
    reason: string
}

--- Options for removing a role from a member
export type RemoveGuildMemberRoleOptions = {
    --- The member ID
    user_id: discord.Snowflake,
    --- The role ID
    role_id: discord.Snowflake,
    --- The reason for adding the role
    reason: string
}

--- Options for removing a member from a guild
export type RemoveGuildMemberOptions = {
    --- The member ID
    user_id: discord.Snowflake,
    --- The reason for removing the member
    reason: string
}

--- Options for getting guild bans
---
--- Note: If both `before` and `after` are provided, `before` will take precedence.
export type GetGuildBansOptions = {
    --- The limit of bans to get (max 100)
    limit: number?,
    --- Before a certain user ID
    before: discord.Snowflake?,
    --- After a certain user ID
    after: discord.Snowflake?
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

--- Options for creating a followup message in Discord
export type CreateFollowupMessageOptions = {
    --- The interaction token
    interaction_token: string,
    --- The data to create the followup message with
    data: discordRest.CreateFollowupMessageRequest
}

--- A message pagination object
export type MessagePagination = { type: "After" | "Around" | "Before", id: discord.Snowflake }

--- Options for getting messages in Discord
export type GetMessagesOptions = {
    --- The channel ID
    channel_id: discord.Snowflake,
    --- The target message
    target: MessagePagination?,
    --- The limit of messages to get
    limit: number?
}

--- Options for getting a message in Discord
export type GetMessageOptions = {
    --- The channel ID
    channel_id: discord.Snowflake,
    --- The message ID
    message_id: discord.Snowflake
}

--- Lazy<discord.AuditLogObject>
type LazyAuditLogObject = lazy.Lazy<discord.AuditLogObject>
--- Lazy<discord.ChannelObject>
type LazyChannelObject = lazy.Lazy<discord.ChannelObject>
--- Lazy<discord.MessageObject> 
type LazyMessageObject = lazy.Lazy<discord.MessageObject>
--- Lazy<{discord.MessageObject}>
type LazyMessagesObject = lazy.Lazy<{discord.MessageObject}>
--- Lazy<discord.ApplicationCommandObject>
type LazyApplicationCommandObject = lazy.Lazy<discord.ApplicationCommandObject>

--- Lazy<{discord.AutomoderationRuleObject}>
type LazyAutomoderationRuleObjectList = lazy.Lazy<{discord.AutomoderationRuleObject}>
--- Lazy<discord.AutomoderationRuleObject>
type LazyAutomoderationRuleObject = lazy.Lazy<discord.AutomoderationRuleObject>

--- Lazy<{discord.GuildBanObject}>
type LazyBanObjectList = lazy.Lazy<{discord.BanObject}>

--- DiscordExecutor allows templates to access/use the Discord API in a sandboxed form.
export type DiscordExecutor = {
    --- Gets the audit logs
    get_audit_logs: (self: DiscordExecutor, data: GetAuditLogOptions) -> promise.LuaPromise<LazyAuditLogObject>,
    --- Lists the auto moderation rules available
    list_auto_moderation_rules: (self: DiscordExecutor) -> promise.LuaPromise<LazyAutomoderationRuleObjectList>,
    --- Gets an auto moderation rule by ID
    get_auto_moderation_rule: (self: DiscordExecutor, data: GetAutoModerationRuleOptions) -> promise.LuaPromise<LazyAutomoderationRuleObject>,
    --- Creates an auto moderation rule
    create_auto_moderation_rule: (self: DiscordExecutor, data: CreateAutoModerationRuleOptions) -> promise.LuaPromise<LazyAutomoderationRuleObject>,
    --- Edits an auto moderation rule
    edit_auto_moderation_rule: (self: DiscordExecutor, data: EditAutoModerationRuleOptions) -> promise.LuaPromise<LazyAutomoderationRuleObject>,
    --- Deletes an auto moderation rule
    delete_auto_moderation_rule: (self: DiscordExecutor, data: DeleteAutoModerationRuleOptions) -> promise.LuaPromise<LazyAutomoderationRuleObject>,
    --- Gets a channel
    get_channel: (self: DiscordExecutor, data: GetChannelOptions) -> promise.LuaPromise<LazyChannelObject>, 
    --- Edits a channel
    edit_channel: (self: DiscordExecutor, data: EditChannelOptions) -> promise.LuaPromise<LazyChannelObject>,
    --- Deletes a channel
    delete_channel: (self: DiscordExecutor, data: DeleteChannelOptions) -> promise.LuaPromise<LazyChannelObject>,
    --- Edits channel permissions for a target
    edit_channel_permissions: (self: DiscordExecutor, data: EditChannelPermissionsOptions) -> promise.LuaPromise<nil>,
    --- Adds a role to a member
    add_guild_member_role: (self: DiscordExecutor, data: AddGuildMemberRoleOptions) -> promise.LuaPromise<nil>,
    --- Removes a role from a member
    remove_guild_member_role: (self: DiscordExecutor, data: RemoveGuildMemberRoleOptions) -> promise.LuaPromise<nil>,
    -- Removes a member from a guild
    remove_guild_member: (self: DiscordExecutor, data: RemoveGuildMemberOptions) -> promise.LuaPromise<nil>,
    --- Gets guild bans
    get_guild_bans: (self: DiscordExecutor, data: GetGuildBansOptions) -> promise.LuaPromise<LazyBanObjectList>,
    --- Gets messages from a channel
    get_messages: (self: DiscordExecutor, data: GetMessagesOptions) -> promise.LuaPromise<LazyMessagesObject>,
    --- Gets a message
    get_message: (self: DiscordExecutor, data: GetMessageOptions) -> promise.LuaPromise<LazyMessageObject>,
    --- Creates a message
    create_message: (self: DiscordExecutor, data: CreateMessageOptions) -> promise.LuaPromise<LazyMessageObject>,
    --- Creates an interaction response
    create_interaction_response: (self: DiscordExecutor, data: CreateInteractionResponseOptions) -> promise.LuaPromise<nil>,
    --- Creates a followup interaction response
    create_followup_message: (self: DiscordExecutor, data: CreateFollowupMessageOptions) -> promise.LuaPromise<LazyMessageObject>,
    --- Gets the original interaction response
    get_original_interaction_response: (self: DiscordExecutor, interaction_token: string) -> promise.LuaPromise<LazyMessageObject>,
    --- Gets all guild commands currently registered
    get_guild_commands: (self: DiscordExecutor) -> promise.LuaPromise<LazyApplicationCommandObject>,
    --- Creates a guild command
    create_guild_command: (self: DiscordExecutor, data: CreateCommandOptions) -> promise.LuaPromise<LazyApplicationCommandObject>,
}
 
local function new(token: Primitives.TemplateContext, scope: ExecutorScope.ExecutorScope?): DiscordExecutor
    error("Implemented internally in AntiRaid runtime!")
end

return {
    new = new
}