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

--- Options for editing a channel in Discord
export type CreateChannelOptions = {
    --- The reason for the create
    reason: string,
    --- The data to edit the channel with
    data: discordRest.CreateGuildChannelRequest
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

--- Options for creating multiple command in Discord
export type CreateCommandsOptions = {
    --- The data to create the command with
    data: {discordRest.CreateGuildApplicationCommandRequest}
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

--- Options for creating a guild ban in Discord
export type CreateGuildBanOptions = {
    --- The user ID to ban
    user_id: discord.Snowflake,
    --- The reason for the ban
    reason: string,
    --- The number of seconds to delete messages from
    delete_message_seconds: number?
}

--- Options for removing a guild ban in Discord
export type RemoveGuildBanOptions = {
    --- The user ID to unban
    user_id: discord.Snowflake,
    --- The reason for the unban
    reason: string
}

--- Options for getting guild members
export type GetGuildMembersOptions = {
    --- The limit of members to get
    limit: number?,
    --- The user ID to get members after
    after: discord.Snowflake?
}

--- Options for searching guild members
export type SearchGuildMembersOptions = {
    --- The query to search for
    query: string,
    --- The limit of members to get
    limit: number?,
}

--- Options for modifying a guild member
export type ModifyGuildMemberOptions = {
    --- The user ID to modify
    user_id: discord.Snowflake,
    --- The reason for the modification
    reason: string,
    --- The data to modify the member with
    data: discordRest.ModifyGuildMemberRequest
}

--- Options for modifying a guild
export type ModifyGuildOptions = {
    data: discordRest.ModifyGuildRequest,
    reason: string
}

--- Options for checking if a user has the needed Discord permissions to perform an action
export type AntiRaidCheckPermissionsOptions = {
    --- The user ID to check permissions for
    user_id: discord.Snowflake,
    --- The needed permissions
    needed_permissions: typesext.MultiOption<string>
}

--- Options for checking if a user has the needed Discord permissions to perform an action 
--- and is above the target user in terms of hierarchy
export type AntiRaidCheckPermissionsAndHierarchyOptions = {
    --- The user ID to check permissions for
    user_id: discord.Snowflake,
    --- The target ID to check permissions for
    target_id: discord.Snowflake,
    --- The needed permissions
    needed_permissions: typesext.MultiOption<string>
}

--- Extra/additional success response for checking if a user has the needed Discord permissions to perform an action
export type AntiRaidCheckPermissionsResponse = {
    --- The partial guild
    partial_guild: discord.Partial<discord.GuildObject>,
    --- The member
    member: discord.GuildMemberObject,
    --- The permissions
    permissions: typesext.MultiOption<string>
}

--- Options for creating a guild role
export type CreateGuildRoleOptions = {
    --- The reason for the creation
    reason: string,
    --- The data to create the role with
    data: discordRest.CreateGuildRoleRequest
}

--- Options for modifying a guild role position
export type ModifyRolePositionOptions = {
    --- The data to modify the role position with
    data: {discordRest.ModifyGuildRolePositionsRequest},
    --- The reason for the modification
    reason: string
}

--- Lazy<discord.AuditLogObject>
type LazyAuditLogObject = lazy.Lazy<discord.AuditLogObject>
--- Lazy<discord.ChannelObject>
type LazyChannelObject = lazy.Lazy<discord.ChannelObject>
--- Lazy<{discord.ChannelObject}>
type LazyChannelsObject = lazy.Lazy<{discord.ChannelObject}>
--- Lazy<discord.MessageObject> 
type LazyMessageObject = lazy.Lazy<discord.MessageObject>
--- Lazy<{discord.MessageObject}>
type LazyMessagesObject = lazy.Lazy<{discord.MessageObject}>
--- Lazy<discord.ApplicationCommandObject>
type LazyApplicationCommandObject = lazy.Lazy<discord.ApplicationCommandObject>
--- Lazy<{discord.ApplicationCommandObject}>
type LazyApplicationCommandsObject = lazy.Lazy<{discord.ApplicationCommandObject}>
--- Lazy<{discord.AutomoderationRuleObject}>
type LazyAutomoderationRuleObjectList = lazy.Lazy<{discord.AutomoderationRuleObject}>
--- Lazy<discord.AutomoderationRuleObject>
type LazyAutomoderationRuleObject = lazy.Lazy<discord.AutomoderationRuleObject>

--- Lazy<discord.GuildBanObject?>
type LazyBanOptionalObject = lazy.Lazy<discord.BanObject?>
--- Lazy<{discord.GuildBanObject}>
type LazyBanObjectList = lazy.Lazy<{discord.BanObject}>

--- Lazy<discord.GuildRoleObject>
type LazyRoleObject = lazy.Lazy<discord.GuildRoleObject>
--- Lazy<{[discord.Snowflake]: discord.GuildRoleObject}>
type LazyRolesObject = lazy.Lazy<{discord.GuildRoleObject}>
--- Lazy<discordRest.ListActiveGuildThreadsResponse>
type LazyActiveGuildThreadsResponse = lazy.Lazy<discordRest.ListActiveGuildThreadsResponse>
--- Lazy<discord.GuildObject>
type LazyGuildObject = lazy.Lazy<discord.GuildObject>
--- Lazy<discord.GuildPreviewObject>
type LazyGuildPreviewObject = lazy.Lazy<discord.GuildPreviewObject>
--- Lazy<discord.GuildMemberObject>
type LazyGuildMemberObject = lazy.Lazy<discord.GuildMemberObject>
--- Lazy<{discord.GuildMemberObject}>
type LazyGuildMembersObject = lazy.Lazy<{discord.GuildMemberObject}>

--- DiscordExecutor allows templates to access/use the Discord API in a sandboxed form.
export type DiscordExecutor = {
    -- Antiraid helpers

    -- Checks an audit log reason for validity, errors out if invalid
    antiraid_check_reason: (self: DiscordExecutor, reason: string) -> nil,
    -- Checks if a specified user with an ID of `data.user_id` has the specified permissions in the server
    antiraid_check_permissions: (self: DiscordExecutor, data: AntiRaidCheckPermissionsOptions) -> promise.LuaPromise<AntiRaidCheckPermissionsResponse>,
    -- Checks if a specified user with an ID of `data.user_id` has the specified permissions in the server and is above the target user with an ID of `data.target_id` in terms of hierarchy
    antiraid_check_permissions_and_hierarchy: (self: DiscordExecutor, data: AntiRaidCheckPermissionsAndHierarchyOptions) -> promise.LuaPromise<AntiRaidCheckPermissionsResponse>,

    -- Discord API

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
    
    -- Guild
    
    --- Gets the guild
    get_guild: (self: DiscordExecutor) -> promise.LuaPromise<LazyGuildObject>,
    --- Gets the guilds preview
    get_guild_preview: (self: DiscordExecutor) -> promise.LuaPromise<LazyGuildPreviewObject>,
    --- Edits the guild
    modify_guild: (self: DiscordExecutor, data: ModifyGuildOptions) -> promise.LuaPromise<LazyGuildObject>,
    --- Gets the guild channels
    get_guild_channels: (self: DiscordExecutor) -> promise.LuaPromise<LazyChannelsObject>,
    --- Creates a guild channel
    create_guild_channel: (self: DiscordExecutor, data: CreateChannelOptions) -> promise.LuaPromise<LazyChannelObject>,
    --- Modify guild channel positions. Only channels to be modified are required to be passed in `data`.
    modify_guild_channel_positions: (self: DiscordExecutor, data: {discordRest.ModifyGuildChannelPositionsRequest}) -> promise.LuaPromise<nil>,
    --- List active guild threads
    list_active_guild_threads: (self: DiscordExecutor) -> promise.LuaPromise<LazyActiveGuildThreadsResponse>,
    --- Gets a guild member by ID
    get_guild_member: (self: DiscordExecutor, user_id: string) -> promise.LuaPromise<LazyGuildMemberObject>,
    --- List all guild members
    list_guild_members: (self: DiscordExecutor, data: GetGuildMembersOptions) -> promise.LuaPromise<LazyGuildMembersObject>,
    --- Search guild members
    search_guild_members: (self: DiscordExecutor, data: SearchGuildMembersOptions) -> promise.LuaPromise<LazyGuildMembersObject>,
    --- Modify guild member (this includes timing out a member using `communication_disabled_until`)
    modify_guild_member: (self: DiscordExecutor, data: ModifyGuildMemberOptions) -> promise.LuaPromise<LazyGuildMemberObject>,
    --- Adds a role to a member
    add_guild_member_role: (self: DiscordExecutor, data: AddGuildMemberRoleOptions) -> promise.LuaPromise<nil>,
    --- Removes a role from a member
    remove_guild_member_role: (self: DiscordExecutor, data: RemoveGuildMemberRoleOptions) -> promise.LuaPromise<nil>,
    -- Removes a member from a guild
    remove_guild_member: (self: DiscordExecutor, data: RemoveGuildMemberOptions) -> promise.LuaPromise<nil>,
    --- Gets guild bans
    get_guild_bans: (self: DiscordExecutor, data: GetGuildBansOptions) -> promise.LuaPromise<LazyBanObjectList>,
    --- Gets a guild ban for a user or nil if it does not exist
    get_guild_ban: (self: DiscordExecutor, user_id: discord.Snowflake) -> promise.LuaPromise<LazyBanOptionalObject>,
    --- Creates a guild ban
    create_guild_ban: (self: DiscordExecutor, data: CreateGuildBanOptions) -> promise.LuaPromise<nil>,
    --- Removes a guild ban
    remove_guild_ban: (self: DiscordExecutor, data: RemoveGuildBanOptions) -> promise.LuaPromise<nil>,
    --- Returns the guild roles of a guild
    get_guild_roles: (self: DiscordExecutor, guild_id: discord.Snowflake) -> promise.LuaPromise<LazyRolesObject>,
    --- Returns a guild role by ID
    get_guild_role: (self: DiscordExecutor, role_id: discord.Snowflake) -> promise.LuaPromise<LazyRoleObject>,
    --- Creates a guild role
    create_guild_role: (self: DiscordExecutor, data: CreateGuildRoleOptions) -> promise.LuaPromise<LazyRoleObject>,
    --- Modify guild role positions
    modify_guild_role_positions: (self: DiscordExecutor, data: ModifyRolePositionOptions) -> promise.LuaPromise<LazyRolesObject>,

    -- Messages

    --- Gets messages from a channel
    get_channel_messages: (self: DiscordExecutor, data: GetMessagesOptions) -> promise.LuaPromise<LazyMessagesObject>,
    --- Gets a message
    get_channel_message: (self: DiscordExecutor, data: GetMessageOptions) -> promise.LuaPromise<LazyMessageObject>,
    --- Creates a message
    create_message: (self: DiscordExecutor, data: CreateMessageOptions) -> promise.LuaPromise<LazyMessageObject>,
    
    -- Uncategorized (for now)
    
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
    --- Creates multiple guild commands
    create_guild_commands: (self: DiscordExecutor, data: CreateCommandsOptions) -> promise.LuaPromise<LazyApplicationCommandsObject>,
}
 
local function new(token: Primitives.TemplateContext, scope: ExecutorScope.ExecutorScope?): DiscordExecutor
    error("Implemented internally in AntiRaid runtime!")
end

return {
    new = new
}