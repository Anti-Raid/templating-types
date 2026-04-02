--!strict
local lazy = require("@antiraid-core/lazy")
local discord = require("@antiraid-core/plugins/discord")
local discordRest = require("@discord-types/restTypes")
local discordApi = require("@discord-types/apiTypes")
local Primitives = require("@antiraid-core/primitives")
local tloop = require"@antiraid-core/templateloop"

--- The fully typed, sandboxed Discord API Client for template execution
export type DiscordClient = {
    -- ==========================================
    -- Identity / Environment
    -- ==========================================
    
    --- Returns the guild id or `nil` if not in a guild context
    guild_id: () -> string?,
    
    --- Returns the bot's user id
    bot_id: () -> string,

    -- ==========================================
    -- AntiRaid Helpers
    -- ==========================================
    
    --- Checks an audit log reason for validity, errors out if invalid
    antiraid_check_reason: (reason: string) -> (),
    
    --- Checks if a specified user with an ID of `data.user_id` has the specified permissions in the server
    antiraid_check_permissions: (data: discord.AntiRaidCheckPermissionsOptions) -> discord.AntiRaidCheckPermissionsResponse,

    --- Checks if a specified user has the specified permissions in the server and is above the target user in terms of hierarchy
    antiraid_check_permissions_and_hierarchy: (data: discord.AntiRaidCheckPermissionsAndHierarchyOptions) -> discord.AntiRaidCheckPermissionsResponse,

    --- Checks if a specified user has the specified permissions in the channel `data.channel_id`
    antiraid_check_channel_permissions: (data: discord.AntiRaidCheckChannelPermissionsOptions) -> discord.AntiRaidCheckChannelPermissionsResponse,

    --- Fetches the member and resolved permissions of a user in the guild
    antiraid_get_fused_member: (ids: {discordApi.Snowflake}) -> discord.LazyAntiraidFusedMember,

    -- ==========================================
    -- Audit Logs
    -- ==========================================
    
    --- Gets the audit logs
    get_audit_logs: (data: discord.GetAuditLogOptions) -> discord.LazyAuditLogObject,

    -- ==========================================
    -- Auto Moderation
    -- ==========================================
    
    --- Lists the auto moderation rules available
    list_auto_moderation_rules: () -> discord.LazyAutomoderationRuleObjectList,

    --- Gets an auto moderation rule by ID
    get_auto_moderation_rule: (data: discord.GetAutoModerationRuleOptions) -> discord.LazyAutomoderationRuleObject,

    --- Creates an auto moderation rule
    create_auto_moderation_rule: (data: discord.CreateAutoModerationRuleOptions) -> discord.LazyAutomoderationRuleObject,

    --- Edits an auto moderation rule
    edit_auto_moderation_rule: (data: discord.EditAutoModerationRuleOptions) -> discord.LazyAutomoderationRuleObject,

    --- Deletes an auto moderation rule
    delete_auto_moderation_rule: (data: discord.DeleteAutoModerationRuleOptions) -> (),
    
    -- ==========================================
    -- Channels
    -- ==========================================
    
    --- Gets a channel
    get_channel: (channel_id: string) -> discord.LazyChannelObject, 

    --- Edits a channel
    edit_channel: (data: discord.EditChannelOptions) -> discord.LazyChannelObject,

    --- Deletes a channel
    delete_channel: (data: discord.DeleteChannelOptions) -> discord.LazyChannelObject,

    --- Edits channel permissions for a target
    edit_channel_permissions: (data: discord.EditChannelPermissionsOptions) -> (),

    --- Gets all invites a channel has
    get_channel_invites: () -> discord.LazyInviteObjectList,

    --- Creates a channel invite
    create_channel_invite: (data: discord.CreateChannelInviteOptions) -> discord.LazyInviteObject,

    --- Deletes a channel permission
    delete_channel_permission: (data: discord.DeleteChannelPermissionOptions) -> (),

    --- Follows an announcement channel
    follow_announcement_channel: (data: discord.FollowAnnouncementChannelOptions) -> discord.LazyChannelObject,

    -- ==========================================
    -- Guild Base
    -- ==========================================
    
    --- Gets the guild
    get_guild: () -> discord.LazyGuildObject,

    --- Gets the guilds preview
    get_guild_preview: () -> discord.LazyGuildPreviewObject,

    --- Edits the guild
    modify_guild: (data: discord.ModifyGuildOptions) -> discord.LazyGuildObject,

    --- Gets the guild channels
    get_guild_channels: () -> discord.LazyChannelsObject,

    --- Creates a guild channel
    create_guild_channel: (data: discord.CreateChannelOptions) -> discord.LazyChannelObject,

    --- Modify guild channel positions
    modify_guild_channel_positions: (data: {discordRest.ModifyGuildChannelPositionsRequest}) -> (),

    --- List active guild threads
    list_active_guild_threads: () -> discord.LazyActiveGuildThreadsResponse,

    -- ==========================================
    -- Guild Members & Bans
    -- ==========================================

    --- Gets a guild member by ID
    get_guild_member: (user_id: string) -> discord.LazyGuildMemberObject,

    --- List all guild members
    list_guild_members: (data: discord.GetGuildMembersOptions) -> discord.LazyGuildMembersObject,

    --- Search guild members
    search_guild_members: (data: discord.SearchGuildMembersOptions) -> discord.LazyGuildMembersObject,

    --- Modify guild member (includes timing out)
    modify_guild_member: (data: discord.ModifyGuildMemberOptions) -> discord.LazyGuildMemberObject,

    --- Adds a role to a member
    add_guild_member_role: (data: discord.AddGuildMemberRoleOptions) -> (),

    --- Removes a role from a member
    remove_guild_member_role: (data: discord.RemoveGuildMemberRoleOptions) -> (),

    --- Removes a member from a guild
    remove_guild_member: (data: discord.RemoveGuildMemberOptions) -> (),

    --- Gets guild bans
    get_guild_bans: (data: discord.GetGuildBansOptions) -> discord.LazyBanObjectList,

    --- Gets a guild ban for a user or nil if it does not exist
    get_guild_ban: (user_id: discordApi.Snowflake) -> discord.LazyBanOptionalObject,

    --- Creates a guild ban
    create_guild_ban: (data: discord.CreateGuildBanOptions) -> (),

    --- Removes a guild ban
    remove_guild_ban: (data: discord.RemoveGuildBanOptions) -> (),

    -- ==========================================
    -- Guild Roles & Commands
    -- ==========================================

    --- Returns the guild roles of a guild
    get_guild_roles: () -> discord.LazyRolesObject,

    --- Returns a guild role by ID
    get_guild_role: (role_id: discordApi.Snowflake) -> discord.LazyRoleObject,

    --- Creates a guild role
    create_guild_role: (data: discord.CreateGuildRoleOptions) -> discord.LazyRoleObject,

    --- Modify guild role positions
    modify_guild_role_positions: (data: discord.ModifyRolePositionOptions) -> discord.LazyRolesObject,

    --- Modifies a guild role
    modify_guild_role: (data: discord.EditGuildRoleOptions) -> discord.LazyRoleObject,

    --- Deletes a guild role
    delete_guild_role: (data: discord.DeleteGuildRoleOptions) -> (),

    --- Gets all guild commands currently registered
    get_guild_commands: () -> discord.LazyApplicationCommandsObject,

    --- Gets a specific guild command by ID
    get_guild_command: (command_id: string) -> discord.LazyApplicationCommandObject,

    --- Creates a guild command
    create_guild_command: (data: discord.CreateCommandOptions) -> discord.LazyApplicationCommandObject,

    --- Creates multiple guild commands
    create_guild_commands: (data: discord.CreateCommandsOptions) -> discord.LazyApplicationCommandsObject,

    -- ==========================================
    -- Invites
    -- ==========================================

    --- Gets an invite by code
    get_invite: (data: discord.GetInviteOptions) -> discord.LazyInviteObject,

    --- Deletes an invite by code
    delete_invite: (data: discord.DeleteInviteOptions) -> discord.LazyInviteObject,

    -- ==========================================
    -- Messages
    -- ==========================================

    --- Gets messages from a channel
    get_channel_messages: (data: discord.GetMessagesOptions) -> discord.LazyMessagesObject,

    --- Gets a message
    get_channel_message: (data: discord.GetMessageOptions) -> discord.LazyMessageObject,

    --- Creates a message
    create_message: (data: discord.CreateMessageOptions) -> discord.LazyMessageObject,

    --- Crossposts a message to an announcement channel
    crosspost_message: (data: discord.CrosspostMessageOptions) -> discord.LazyMessageObject,
    
    --- Edits a message
    edit_message: (data: discord.EditMessageOptions) -> discord.LazyMessageObject,

    --- Deletes a message
    delete_message: (data: discord.DeleteMessageOptions) -> (),

    --- Bulk deletes messages in a channel
    bulk_delete_messages: (data: discord.BulkDeleteMessagesOptions) -> (),

    -- ==========================================
    -- Reactions
    -- ==========================================

    --- Creates a reaction to a message
    create_reaction: (data: discord.CreateReactionOptions) -> (),

    --- Deletes the reaction AntiRaid has made on a message
    delete_own_reaction: (data: discord.DeleteOwnReactionOptions) -> (),

    --- Deletes a reaction another user has made on a message
    delete_user_reaction: (data: discord.DeleteUserReactionOptions) -> (),

    --- Gets all users who have reacted
    get_reactions: (data: discord.GetReactionsOptions) -> discord.LazyUsersObject,

    --- Deletes all reactions on a message
    delete_all_reactions: (data: discord.DeleteAllReactionsOptions) -> (),

    --- Deletes all reactions for a specific emoji on a message
    delete_all_reactions_for_emoji: (data: discord.DeleteAllReactionsForEmojiOptions) -> (),

    -- ==========================================
    -- Interactions
    -- ==========================================
    
    --- Creates an interaction response
    create_interaction_response: (data: discord.CreateInteractionResponseOptions) -> (),

    --- Gets the original interaction response
    get_original_interaction_response: (interaction_token: string) -> discord.LazyMessageObject,

    --- Edits the original interaction response
    edit_original_interaction_response: (data: discord.EditInteractionResponseOptions) -> discord.LazyMessageObject,

    --- Deletes the original interaction response
    delete_original_interaction_response: (interaction_token: string) -> (),

    --- Gets a followup interaction response
    get_followup_message: (data: discord.GetFollowupMessageOptions) -> discord.LazyMessageObject,

    --- Creates a followup interaction response
    create_followup_message: (data: discord.CreateFollowupMessageOptions) -> discord.LazyMessageObject,

    --- Edits a followup interaction response
    edit_followup_message: (data: discord.EditFollowupMessageOptions) -> discord.LazyMessageObject,

    --- Deletes a followup interaction response
    delete_followup_message: (data: discord.DeleteFollowupMessageOptions) -> (),

    -- ==========================================
    -- Webhooks
    -- ==========================================

    --- Creates a webhook in a channel
    create_webhook: (data: { channel_id: string, data: discordRest.CreateWebhookRequest, reason: string? }) -> lazy.Lazy<discordApi.WebhookObject>,

    --- Gets all webhooks in a channel
    get_channel_webhooks: (channel_id: string) -> lazy.Lazy<{discordApi.WebhookObject}>,

    --- Gets all webhooks in the guild
    get_guild_webhooks: () -> lazy.Lazy<{discordApi.WebhookObject}>,

    --- Gets a specific webhook
    get_webhook: (webhook_id: string) -> lazy.Lazy<discordApi.WebhookObject>,

    --- Modifies a webhook
    modify_webhook: (data: { webhook_id: string, data: discordRest.ModifyWebhookRequest, reason: string? }) -> lazy.Lazy<discordApi.WebhookObject>,

    --- Deletes a webhook
    delete_webhook: (webhook_id: string) -> (),

    --- Executes a webhook
    execute_webhook: (data: { webhook_id: string, webhook_token: string, data: discordRest.ExecuteWebhookRequest }) -> lazy.Lazy<discordApi.MessageObject?>,
}

--- Creates a new Discord API executor for the template
local function DiscordExecutor(ctx: Primitives.TemplateContext): DiscordClient
    local tloop = tloop.getRunningLoop(ctx)
    local function call(req: any): any
        local res = ctx.Runtime:syscall({
            op = "Discord",
            req = req
        })

        if res.op ~= "Discord" or res.req.op ~= req.op then
            error(`invalid op returned`, 3)
        end

        return (res.req :: any).res
    end

    -- 2. LOOSE TABLE: Zero CPU overhead for type evaluation here.
    local client = {
        -- ==========================================
        -- Identity / Environment
        -- ==========================================
        guild_id = function(): string?
            if tloop.btd.id.tenant_type == "guild" then
                return tloop.btd.id.tenant_id
            end
            return nil
        end,
        
        bot_id = function()
            return tloop.btd.bot.id
        end,

        -- ==========================================
        -- AntiRaid Helpers
        -- ==========================================
        antiraid_check_reason = function(reason)
            call({ op = "AntiRaidCheckReason", reason = reason })
        end,
        antiraid_check_permissions = function(data)
            return call({ op = "AntiRaidCheckPermissions", data = data })
        end,
        antiraid_check_permissions_and_hierarchy = function(data)
            return call({ op = "AntiRaidCheckPermissionsAndHierarchy", data = data })
        end,
        antiraid_check_channel_permissions = function(data)
            return call({ op = "AntiRaidCheckChannelPermissions", data = data })
        end,
        antiraid_get_fused_member = function(ids)
            return call({ op = "AntiRaidGetFusedMember", ids = ids })
        end,

        -- ==========================================
        -- Audit Logs & Auto Moderation
        -- ==========================================
        get_audit_logs = function(data)
            return call({ op = "GetAuditLog", data = data })
        end,
        list_auto_moderation_rules = function()
            return call({ op = "ListAutoModerationRules" })
        end,
        get_auto_moderation_rule = function(data)
            return call({ op = "GetAutoModerationRule", data = data })
        end,
        create_auto_moderation_rule = function(data)
            return call({ op = "CreateAutoModerationRule", data = data })
        end,
        edit_auto_moderation_rule = function(data)
            return call({ op = "EditAutoModerationRule", data = data })
        end,
        delete_auto_moderation_rule = function(data)
            call({ op = "DeleteAutoModerationRule", data = data })
        end,

        -- ==========================================
        -- Channels
        -- ==========================================
        get_channel = function(channel_id)
            return call({ op = "GetChannel", channel_id = channel_id })
        end,
        edit_channel = function(data)
            return call({ op = "EditChannel", data = data })
        end,
        delete_channel = function(data)
            return call({ op = "DeleteChannel", data = data })
        end,
        edit_channel_permissions = function(data)
            call({ op = "EditChannelPermissions", data = data })
        end,
        get_channel_invites = function()
            return call({ op = "GetChannelInvites" })
        end,
        create_channel_invite = function(data)
            return call({ op = "CreateChannelInvite", data = data })
        end,
        delete_channel_permission = function(data)
            call({ op = "DeleteChannelPermission", data = data })
        end,
        follow_announcement_channel = function(data)
            return call({ op = "FollowAnnouncementChannel", data = data })
        end,

        -- ==========================================
        -- Guild Base
        -- ==========================================
        get_guild = function()
            return call({ op = "GetGuild" })
        end,
        get_guild_preview = function()
            return call({ op = "GetGuildPreview" })
        end,
        modify_guild = function(data)
            return call({ op = "ModifyGuild", data = data })
        end,
        get_guild_channels = function()
            return call({ op = "GetGuildChannels" })
        end,
        create_guild_channel = function(data)
            return call({ op = "CreateGuildChannel", data = data })
        end,
        modify_guild_channel_positions = function(data)
            call({ op = "ModifyGuildChannelPositions", data = data })
        end,
        list_active_guild_threads = function()
            return call({ op = "ListActiveGuildThreads" })
        end,

        -- ==========================================
        -- Guild Members & Bans
        -- ==========================================
        get_guild_member = function(user_id)
            return call({ op = "GetGuildMember", user_id = user_id })
        end,
        list_guild_members = function(data)
            return call({ op = "ListGuildMembers", data = data })
        end,
        search_guild_members = function(data)
            return call({ op = "SearchGuildMembers", data = data })
        end,
        modify_guild_member = function(data)
            return call({ op = "ModifyGuildMember", data = data })
        end,
        add_guild_member_role = function(data)
            call({ op = "AddGuildMemberRole", data = data })
        end,
        remove_guild_member_role = function(data)
            call({ op = "RemoveGuildMemberRole", data = data })
        end,
        remove_guild_member = function(data)
            call({ op = "RemoveGuildMember", data = data })
        end,
        get_guild_bans = function(data)
            return call({ op = "GetGuildBans", data = data })
        end,
        get_guild_ban = function(user_id)
            return call({ op = "GetGuildBan", user_id = user_id })
        end,
        create_guild_ban = function(data)
            call({ op = "CreateGuildBan", data = data })
        end,
        remove_guild_ban = function(data)
            call({ op = "RemoveGuildBan", data = data })
        end,

        -- ==========================================
        -- Guild Roles & Commands
        -- ==========================================
        get_guild_roles = function()
            return call({ op = "GetGuildRoles" })
        end,
        get_guild_role = function(role_id)
            return call({ op = "GetGuildRole", role_id = role_id })
        end,
        create_guild_role = function(data)
            return call({ op = "CreateGuildRole", data = data })
        end,
        modify_guild_role_positions = function(data)
            return call({ op = "ModifyGuildRolePositions", data = data })
        end,
        modify_guild_role = function(data)
            return call({ op = "ModifyGuildRole", data = data })
        end,
        delete_guild_role = function(data)
            call({ op = "DeleteGuildRole", data = data })
        end,
        get_guild_commands = function()
            return call({ op = "GetGuildCommands" })
        end,
        get_guild_command = function(command_id)
            return call({ op = "GetGuildCommand", command_id = command_id })
        end,
        create_guild_command = function(data)
            return call({ op = "CreateGuildCommand", data = data })
        end,
        create_guild_commands = function(data)
            return call({ op = "CreateGuildCommands", data = data })
        end,

        -- ==========================================
        -- Invites
        -- ==========================================
        get_invite = function(data)
            return call({ op = "GetInvite", data = data })
        end,
        delete_invite = function(data)
            return call({ op = "DeleteInvite", data = data })
        end,

        -- ==========================================
        -- Messages
        -- ==========================================
        get_channel_messages = function(data)
            return call({ op = "GetChannelMessages", data = data })
        end,
        get_channel_message = function(data)
            return call({ op = "GetChannelMessage", data = data })
        end,
        create_message = function(data)
            return call({ op = "CreateMessage", data = data })
        end,
        crosspost_message = function(data)
            return call({ op = "CrosspostMessage", data = data })
        end,
        edit_message = function(data)
            return call({ op = "EditMessage", data = data })
        end,
        delete_message = function(data)
            call({ op = "DeleteMessage", data = data })
        end,
        bulk_delete_messages = function(data)
            call({ op = "BulkDeleteMessages", data = data })
        end,

        -- ==========================================
        -- Reactions
        -- ==========================================
        create_reaction = function(data)
            call({ op = "CreateReaction", data = data })
        end,
        delete_own_reaction = function(data)
            call({ op = "DeleteOwnReaction", data = data })
        end,
        delete_user_reaction = function(data)
            call({ op = "DeleteUserReaction", data = data })
        end,
        get_reactions = function(data)
            return call({ op = "GetReactions", data = data })
        end,
        delete_all_reactions = function(data)
            call({ op = "DeleteAllReactions", data = data })
        end,
        delete_all_reactions_for_emoji = function(data)
            call({ op = "DeleteAllReactionsForEmoji", data = data })
        end,

        -- ==========================================
        -- Interactions
        -- ==========================================
        create_interaction_response = function(data)
            call({ op = "CreateInteractionResponse", data = data })
        end,
        get_original_interaction_response = function(interaction_token)
            return call({ op = "GetOriginalInteractionResponse", interaction_token = interaction_token })
        end,
        edit_original_interaction_response = function(data)
            return call({ op = "EditOriginalInteractionResponse", data = data })
        end,
        delete_original_interaction_response = function(interaction_token)
            call({ op = "DeleteOriginalInteractionResponse", interaction_token = interaction_token })
        end,
        get_followup_message = function(data)
            return call({ op = "GetFollowupMessage", data = data })
        end,
        create_followup_message = function(data)
            return call({ op = "CreateFollowupMessage", data = data })
        end,
        edit_followup_message = function(data)
            return call({ op = "EditFollowupMessage", data = data })
        end,
        delete_followup_message = function(data)
            call({ op = "DeleteFollowupMessage", data = data })
        end,

        -- ==========================================
        -- Webhooks
        -- ==========================================
        create_webhook = function(data)
            return call({ op = "CreateWebhook", data = data })
        end,
        get_channel_webhooks = function(channel_id)
            return call({ op = "GetChannelWebhooks", channel_id = channel_id })
        end,
        get_guild_webhooks = function()
            return call({ op = "GetGuildWebhooks" })
        end,
        get_webhook = function(webhook_id)
            return call({ op = "GetWebhook", webhook_id = webhook_id })
        end,
        modify_webhook = function(data)
            return call({ op = "ModifyWebhook", data = data })
        end,
        delete_webhook = function(webhook_id)
            call({ op = "DeleteWebhook", webhook_id = webhook_id })
        end,
        execute_webhook = function(data)
            return call({ op = "ExecuteWebhook", data = data })
        end,
    }

    -- Cast to a discord client (type erasure -> public type)
    return (table.freeze(client) :: any) :: DiscordClient
end

return DiscordExecutor