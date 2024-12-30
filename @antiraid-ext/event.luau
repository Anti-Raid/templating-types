local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local discordGateway = require("@discord-types-corrections/gatewayTypes")
  
--- Function that checks if the event matches the name.
---
--- An event matches name when its ``base_name`` or ``name`` is equal to the ``name`` argument or when ``{base_name}.{name}`` is equal to the ``name`` argument.
--- 
--- For example, using either ``Message`` or ``Discord.Message`` as name would match a Discord Message event.
---
--- **Note that this function is case-insensitive and internally converts all strings to lowercase.**
local function doesEventMatch(pat: string, event: Primitives.Event)
    local baseName = string.lower(event.base_name)
    local name = string.lower(event.name)
    local pattern = string.lower(pat)
    
    return baseName == pattern or name == pattern or (baseName .. "." .. name) == pattern
end

--- Simple helper method that calls ``callback`` when the event matches the name. See ``doesEventMatch`` for more information
--- on how the name is matched.
local function onEvent(event: Primitives.Event, pats: string | {string}, callback: (Primitives.Event) -> ())    
    if type(pats) == "string" then
        if doesEventMatch(pats, event) then
            return callback(event)
        end
    else
        for _, pat in ipairs(pats) do
            if doesEventMatch(pat, event) then
                return callback(event)
            end
        end
    end
end

--- AutoModActionExecution
---
--- Note that discord-luau calls it ApplicationCommandPermissionsExecutionPayload instead of AutoModActionExecution due to naming bug
local function onAutoModActionExecution(event: Primitives.Event, callback: (action: discordGateway.ApplicationCommandPermissionsExecutionPayload) -> ())
    onEvent(event, "Discord.AutoModActionExecution", function(event)
        callback(event.data["AutoModActionExecution"]["execution"])
    end)
end

--- AutoModRuleCreate
local function onAutoModRuleCreate(event: Primitives.Event, callback: (rule: discord.AutomoderationRuleObject) -> ())
    onEvent(event, "Discord.AutoModRuleCreate", function(event)
        callback(event.data["AutoModRuleCreate"]["rule"])
    end)
end

--- AutoModRuleDelete
local function onAutoModRuleDelete(event: Primitives.Event, callback: (rule: discord.AutomoderationRuleObject) -> ())
    onEvent(event, "Discord.AutoModRuleDelete", function(event)
        callback(event.data["AutoModRuleDelete"]["rule"])
    end)
end

--- AutoModRuleUpdate
local function onAutoModRuleUpdate(event: Primitives.Event, callback: (rule: discord.AutomoderationRuleObject) -> ())
    onEvent(event, "Discord.AutoModRuleUpdate", function(event)
        callback(event.data["AutoModRuleUpdate"]["rule"])
    end)
end

--- CategoryCreate
local function onCategoryCreate(event: Primitives.Event, callback: (category: discord.ChannelObject) -> ())
    onEvent(event, "Discord.CategoryCreate", function(event)
        callback(event.data["CategoryCreate"]["category"])
    end)
end

--- CategoryDelete
local function onCategoryDelete(event: Primitives.Event, callback: (category: discord.ChannelObject) -> ())
    onEvent(event, "Discord.CategoryDelete", function(event)
        callback(event.data["CategoryDelete"]["category"])
    end)
end

--- ChannelCreate
local function onChannelCreate(event: Primitives.Event, callback: (channel: discord.ChannelObject) -> ())
    onEvent(event, "Discord.ChannelCreate", function(event)
        callback(event.data["ChannelCreate"]["channel"])
    end)
end

--- ChannelDelete
local function onChannelDelete(event: Primitives.Event, callback: (channel: discord.ChannelObject, messages: {discord.MessageObject}?) -> ())
    onEvent(event, "Discord.ChannelDelete", function(event)
        callback(event.data["ChannelDelete"]["channel"], event.data["ChannelDelete"]["messages"])
    end)
end

--- ChannelPinsUpdate
local function onChannelPinsUpdate(event: Primitives.Event, callback: (pin: discordGateway.ChannelPinsUpdatePayload) -> ())
    onEvent(event, "Discord.ChannelPinsUpdate", function(event)
        callback(event.data["ChannelPinsUpdate"]["pin"])
    end)
end

--- ChannelUpdate
local function onChannelUpdate(event: Primitives.Event, callback: (old: discord.ChannelObject?, new: discord.ChannelObject) -> ())
    onEvent(event, "Discord.ChannelUpdate", function(event)
        callback(event.data["ChannelUpdate"]["old"], event.data["ChannelUpdate"]["new"])
    end)
end

--- CommandPermissionsUpdate
local function onCommandPermissionsUpdate(event: Primitives.Event, callback: (permission: discord.GuildApplicationCommandPermissionsObject) -> ())
    onEvent(event, "Discord.CommandPermissionsUpdate", function(event)
        callback(event.data["CommandPermissionsUpdate"]["permission"])
    end)
end

--- EntitlementCreate
local function onEntitlementCreate(event: Primitives.Event, callback: (entitlement: discord.EntitlementObject) -> ())
    onEvent(event, "Discord.EntitlementCreate", function(event)
        callback(event.data["EntitlementCreate"]["entitlement"])
    end)
end

--- EntitlementDelete
---
--- Provides data about the subscription. Specifically, the ``entitlement.deleted`` field will be set.
local function onEntitlementDelete(event: Primitives.Event, callback: (entitlement: discord.EntitlementObject) -> ())
    onEvent(event, "Discord.EntitlementDelete", function(event)
        callback(event.data["EntitlementDelete"]["entitlement"])
    end)
end

--- EntitlementUpdate
---
--- Provides data abut the updated subscription. If the entitlement is renewed, the ``entitlement.ends_at`` field will have changed.
local function onEntitlementUpdate(event: Primitives.Event, callback: (entitlement: discord.EntitlementObject) -> ())
    onEvent(event, "Discord.EntitlementUpdate", function(event)
        callback(event.data["EntitlementUpdate"]["entitlement"])
    end)
end

--- GuildAuditLogEntryCreate
---
--- Dispatched when a new audit log entry is created.
---
--- Provides said entry’s data and the id of the guild where it was created.
local function onGuildAuditLogEntryCreate(event: Primitives.Event, callback: (entry: discord.AuditLogEntryObject, guildId: string) -> ())
    onEvent(event, "Discord.GuildAuditLogEntryCreate", function(event)
        callback(event.data["GuildAuditLogEntryCreate"]["entry"], event.data["GuildAuditLogEntryCreate"]["guild_id"])
    end)
end

--- GuildBanAddition
---
--- Dispatched when a user is banned from a guild.
---
--- Provides the user’s data and the id of the guild where the ban occurred.
local function onGuildBanAddition(event: Primitives.Event, callback: (user: discord.UserObject, guildId: string) -> ())
    onEvent(event, "Discord.GuildBanAddition", function(event)
        callback(event.data["GuildBanAddition"]["banned_user"], event.data["GuildBanAddition"]["guild_id"])
    end)
end

--- GuildBanRemoval
---
--- Dispatched when a user is unbanned from a guild.
---
--- Provides the user’s data and the id of the guild where the unban occurred.
local function onGuildBanRemoval(event: Primitives.Event, callback: (user: discord.UserObject, guildId: string) -> ())
    onEvent(event, "Discord.GuildBanRemoval", function(event)
        callback(event.data["GuildBanRemoval"]["unbanned_user"], event.data["GuildBanRemoval"]["guild_id"])
    end)
end

--- GuildCreate
---
--- You normally won't get this event unless you're self hosting AntiRaid or theres a network error.
local function onGuildCreate(event: Primitives.Event, callback: (guild: discord.GuildObject, isNew: boolean?) -> ())
    onEvent(event, "Discord.GuildCreate", function(event)
        callback(event.data["GuildCreate"]["guild"], event.data["GuildCreate"]["is_new"])
    end)
end

--- GuildDelete
---
--- Dispatched when a guild is deleted.
---
--- Provides the partial data of the guild sent by discord, and the full data from the cache, if cache feature is enabled and the data is available.
---
--- The unavailable flag in the partial data determines the status of the guild. If the flag is false, the bot was removed from the guild, either by being kicked or banned. If the flag is true, the guild went offline.
local function onGuildDelete(event: Primitives.Event, callback: (incomplete: discord.UnavailableGuildObject, full: discord.GuildObject?) -> ())
    onEvent(event, "Discord.GuildDelete", function(event)
        callback(event.data["GuildDelete"]["incomplete"], event.data["GuildDelete"]["full"])
    end)
end

--- GuildEmojisUpdate
---
--- Dispatched when the emojis in a guild are updated.
---
--- Provides the guild’s id and the new state of the emojis in the guild.
local function onGuildEmojisUpdate(event: Primitives.Event, callback: (currentState: {[discord.Snowflake]: discord.EmojiObject}, guildId: string) -> ())
    onEvent(event, "Discord.GuildEmojisUpdate", function(event)
        callback(event.data["GuildEmojisUpdate"]["current_state"], event.data["GuildEmojisUpdate"]["guild_id"])
    end)
end

--- GuildIntegrationsUpdate
---
--- Dispatched when a guild’s integration is added, updated or removed.
local function onGuildIntegrationsUpdate(event: Primitives.Event, callback: (guildId: string) -> ())
    onEvent(event, "Discord.GuildIntegrationsUpdate", function(event)
        callback(event.data["GuildIntegrationsUpdate"]["guild_id"])
    end)
end

--- GuildMemberAddition
---
--- Dispatched when a user joins a guild.
---
--- Provides the guild’s id and the user’s member data.
local function onGuildMemberAddition(event: Primitives.Event, callback: (member: discord.GuildMemberObject) -> ())
    onEvent(event, "Discord.GuildMemberAddition", function(event)
        callback(event.data["GuildMemberAddition"]["new_member"])
    end)
end

--- GuildMemberRemoval
---
--- Dispatched when a user’s membership ends by leaving, getting kicked, or being banned.
---
--- Provides the guild’s id, the user’s data, and the user’s member data if cache feature is enabled and the data is available.
local function onGuildMemberRemoval(event: Primitives.Event, callback: (user: discord.UserObject, memberDataIfAvailable: discord.GuildMemberObject?, guildId: string) -> ())
    onEvent(event, "Discord.GuildMemberRemoval", function(event)
        callback(event.data["GuildMemberRemoval"]["user"], event.data["GuildMemberRemoval"]["member_data_if_available"], event.data["GuildMemberRemoval"]["guild_id"])
    end)
end

--- GuildMemberUpdate
---
--- Dispatched when a member is updated (e.g their nickname is updated).
---
--- Provides the member’s old and new data (if cache feature is enabled and data is available) and the new raw data about updated fields.
local function onGuildMemberUpdate(event: Primitives.Event, callback: (oldIfAvailable: discord.GuildMemberObject?, new: discord.GuildMemberObject?, rawEvent: discordGateway.GuildMemberUpdatePayload) -> ())
    onEvent(event, "Discord.GuildMemberUpdate", function(event)
        callback(event.data["GuildMemberUpdate"]["old_if_available"], event.data["GuildMemberUpdate"]["new"], event.data["GuildMemberUpdate"]["event"])
    end)
end

--- GuildMembersChunk
---
--- Dispatched when the data for offline members was requested.
---
--- Note that this event will most likely never actually be dispatched by AntiRaid outside of self-hosting or special cases.
local function onGuildMembersChunk(event: Primitives.Event, callback: (chunk: discordGateway.GuildMembersChunkPayload) -> ())
    onEvent(event, "Discord.GuildMembersChunk", function(event)
        callback(event.data["GuildMembersChunk"]["chunk"])
    end)
end

--- GuildRoleCreate
---
--- Dispatched when a role is created in a guild.
local function onGuildRoleCreate(event: Primitives.Event, callback: (role: discord.GuildRoleObject) -> ())
    onEvent(event, "Discord.GuildRoleCreate", function(event)
        callback(event.data["GuildRoleCreate"]["new"])
    end)
end

--- GuildRoleDelete
---
--- Dispatched when a role is deleted in a guild.
local function onGuildRoleDelete(event: Primitives.Event, callback: (removedRoleId: string, removedRole: discord.GuildRoleObject?, guildId: string) -> ())
    onEvent(event, "Discord.GuildRoleDelete", function(event)
        callback(event.data["GuildRoleDelete"]["guild_id"], event.data["GuildRoleDelete"]["removed_role_data_if_available"], event.data["GuildRoleDelete"]["guild_id"])
    end)
end

--- GuildRoleUpdate
---
--- Dispatched when a role is updated in a guild.
local function onGuildRoleUpdate(event: Primitives.Event, callback: (oldIfAvailable: discord.GuildRoleObject?, new: discord.GuildRoleObject) -> ())
    onEvent(event, "Discord.GuildRoleUpdate", function(event)
        callback(event.data["GuildRoleUpdate"]["old_data_if_available"], event.data["GuildRoleUpdate"]["new"])
    end)
end

--- GuildScheduledEventCreate
---
--- Dispatched when a scheduled event is created in a guild.
local function onGuildScheduledEventCreate(event: Primitives.Event, callback: (event: discord.GuildScheduledEventObject) -> ())
    onEvent(event, "Discord.GuildScheduledEventCreate", function(event)
        callback(event.data["GuildScheduledEventCreate"]["event"])
    end)
end

--- GuildScheduledEventUpdate
---
--- Dispatched when a scheduled event is updated in a guild.
local function onGuildScheduledEventUpdate(event: Primitives.Event, callback: (event: discord.GuildScheduledEventObject) -> ())
    onEvent(event, "Discord.GuildScheduledEventUpdate", function(event)
        callback(event.data["GuildScheduledEventUpdate"]["event"])
    end)
end

--- GuildScheduledEventDelete
---
--- Dispatched when a scheduled event is deleted in a guild.
local function onGuildScheduledEventDelete(event: Primitives.Event, callback: (event: discord.GuildScheduledEventObject) -> ())
    onEvent(event, "Discord.GuildScheduledEventDelete", function(event)
        callback(event.data["GuildScheduledEventDelete"]["event"])
    end)
end

--- GuildScheduledEventUserAdd
---
--- Dispatched when a user is added to a scheduled event in a guild.
local function onGuildScheduledEventUserAdd(event: Primitives.Event, callback: (subscribed: discordGateway.GuildScheduledEventUserAddPayload) -> ())
    onEvent(event, "Discord.GuildScheduledEventUserAdd", function(event)
        callback(event.data["GuildScheduledEventUserAdd"]["subscribed"])
    end)
end

--- GuildScheduledEventUserRemove
---
--- Dispatched when a user is removed from a scheduled event in a guild.
local function onGuildScheduledEventUserRemove(event: Primitives.Event, callback: (unsubscribed: discordGateway.GuildScheduledEventUserRemovePayload) -> ())
    onEvent(event, "Discord.GuildScheduledEventUserRemove", function(event)
        callback(event.data["GuildScheduledEventUserRemove"]["unsubscribed"])
    end)
end

--- GuildStickersUpdate
---
--- Dispatched when the stickers in a guild are updated.
local function onGuildStickersUpdate(event: Primitives.Event, callback: (currentState: {[discord.Snowflake]: discord.StickerObject}, guildId: string) -> ())
    onEvent(event, "Discord.GuildStickersUpdate", function(event)
        callback(event.data["GuildStickersUpdate"]["current_state"], event.data["GuildStickersUpdate"]["guild_id"])
    end)
end

--- GuildUpdate
---
--- Dispatched when the guild is updated.
---
--- Note that the new data may be partial
local function onGuildUpdate(event: Primitives.Event, callback: (old: discord.GuildObject?, new: discord.GuildObject) -> ())
    onEvent(event, "Discord.GuildUpdate", function(event)
        callback(event.data["GuildUpdate"]["old_data_if_available"], event.data["GuildUpdate"]["new_data"])
    end)
end

--- IntegrationCreate
---
--- Dispatched when an integration is created in a guild.
local function onIntegrationCreate(event: Primitives.Event, callback: (integration: discord.IntegrationObject) -> ())
    onEvent(event, "Discord.IntegrationCreate", function(event)
        callback(event.data["IntegrationCreate"]["integration"])
    end)
end

--- IntegrationDelete
---
--- Dispatched when an integration is deleted in a guild.
local function onIntegrationDelete(event: Primitives.Event, callback: (integrationId: discord.Snowflake, guildId: string, applicationId: string?) -> ())
    onEvent(event, "Discord.IntegrationDelete", function(event)
        callback(event.data["IntegrationDelete"]["integration_id"], event.data["IntegrationDelete"]["guild_id"], event.data["IntegrationDelete"]["application_id"])
    end)
end

--- IntegrationUpdate
local function onIntegrationUpdate(event: Primitives.Event, callback: (integration: discord.IntegrationObject) -> ())
    onEvent(event, "Discord.IntegrationUpdate", function(event)
        callback(event.data["IntegrationUpdate"]["integration"])
    end)
end

--- InteractionCreate
---
--- Run an event on interaction create (e.g a slash command was used or a button was clicked)
local function onInteractionCreate(event: Primitives.Event, callback: (interaction: discord.InteractionObject) -> ())
    onEvent(event, "Discord.InteractionCreate", function(event)
        callback(event.data["InteractionCreate"]["interaction"])
    end)
end

--- InviteCreate
---
--- Dispatched when an invite is created.
local function onInviteCreate(event: Primitives.Event, callback: (data: discordGateway.InviteCreatePayload) -> ())
    onEvent(event, "Discord.InviteCreate", function(event)
        callback(event.data["InviteCreate"]["data"])
    end)
end

--- InviteDelete
---
--- Dispatched when an invite is deleted.
local function onInviteDelete(event: Primitives.Event, callback: (data: discordGateway.InviteDeletePayload) -> ())
    onEvent(event, "Discord.InviteDelete", function(event)
        callback(event.data["InviteDelete"]["data"])
    end)
end

--- Message
---
--- Run an event on message. This is a helper function that extracts the useful data from the event and calls the callback.
local function onMessage(event: Primitives.Event, callback: (msg: discord.MessageObject) -> ())
    onEvent(event, "Discord.Message", function(event)
        callback(event.data["Message"]["new_message"])
    end)
end

--- MessageDelete
---
--- Dispatched when a message is deleted.
local function onMessageDelete(event: Primitives.Event, callback: (channelId: string, messageId: string, guildId: string?) -> ())
    onEvent(event, "Discord.MessageDelete", function(event)
        callback(event.data["MessageDelete"]["channel_id"], event.data["MessageDelete"]["deleted_message_id"], event.data["MessageDelete"]["guild_id"])
    end)
end

--- MessageDeleteBulk
---
--- Dispatched when multiple messages are deleted at once.
local function onMessageDeleteBulk(event: Primitives.Event, callback: (channelId: string, messageIds: {string}, guildId: string?) -> ())
    onEvent(event, "Discord.MessageDeleteBulk", function(event)
        callback(event.data["MessageDeleteBulk"]["channel_id"], event.data["MessageDeleteBulk"]["multiple_deleted_messages_ids"], event.data["MessageDeleteBulk"]["guild_id"])
    end)
end

--- MessagePollVoteAdd
---
--- Dispatched when a user votes in a poll.
---
--- This will be dispatched multiple times if multiple answers are selected.
local function onMessagePollVoteAdd(event: Primitives.Event, callback: (vote: discordGateway.MessagePollVoteAdd) -> ())
    onEvent(event, "Discord.MessagePollVoteAdd", function(event)
        callback(event.data["MessagePollVoteAdd"]["event"])
    end)
end

--- MessagePollVoteRemove
---
--- Dispatched when a user removes their vote in a poll.
local function onMessagePollVoteRemove(event: Primitives.Event, callback: (vote: discordGateway.MessagePollVoteRemove) -> ())
    onEvent(event, "Discord.MessagePollVoteRemove", function(event)
        callback(event.data["MessagePollVoteRemove"]["event"])
    end)
end

--- MessageUpdate
---
--- Provides the message update data, as well as the actual old and new message if data is available.
local function onMessageUpdate(event: Primitives.Event, callback: (oldIfAvailable: discord.MessageObject?, new: discord.MessageObject?, evt: discordGateway.MessageUpdatePayload) -> ())
    onEvent(event, "Discord.MessageUpdate", function(event)
        callback(event.data["MessageUpdate"]["old_if_available"], event.data["MessageUpdate"]["new"], event.data["MessageUpdate"]["event"])
    end)
end

--- PresenceUpdate
---
--- Dispatched when a user’s presence is updated (e.g off -> on).
---
--- Note that you usually won't get this event from AntiRaid unless you're self-hosting or unusual circumstances.
local function onPresenceUpdate(event: Primitives.Event, callback: (oldData: discord.PresenceObject?, newData: discord.PresenceObject) -> ())
    onEvent(event, "Discord.PresenceUpdate", function(event)
        callback(event.data["PresenceUpdate"]["old_data"], event.data["PresenceUpdate"]["new_data"])
    end)
end

--- Ratelimit
---
--- Dispatched when an HTTP ratelimit is hit.
---
--- Note that you usually won't get this event from AntiRaid unless you're self-hosting or unusual circumstances.
local function onRatelimit(event: Primitives.Event, callback: (ratelimitData: any) -> ())
    onEvent(event, "Discord.Ratelimit", function(event)
        callback(event.data["Ratelimit"]["data"])
    end)
end

--- ReactionAdd
---
--- Dispatched when a reaction is added to a message.
local function onReactionAdd(event: Primitives.Event, callback: (reaction: discord.ReactionObject) -> ())
    onEvent(event, "Discord.ReactionAdd", function(event)
        callback(event.data["ReactionAdd"]["add_reaction"])
    end)
end

--- ReactionRemove
---
--- Dispatched when a reaction is removed from a message.
local function onReactionRemove(event: Primitives.Event, callback: (reaction: discord.ReactionObject) -> ())
    onEvent(event, "Discord.ReactionRemove", function(event)
        callback(event.data["ReactionRemove"]["removed_reaction"])
    end)
end

--- ReactionRemoveAll
---
--- Dispatched when all reactions are removed from a message.
local function onReactionRemoveAll(event: Primitives.Event, callback: (guildId: string?, channelId: string, messageId: string) -> ())
    onEvent(event, "Discord.ReactionRemoveAll", function(event)
        callback(event.data["ReactionRemoveAll"]["guild_id"], event.data["ReactionRemoveAll"]["channel_id"], event.data["ReactionRemoveAll"]["removed_from_message_id"])
    end)
end

--- ReactionRemoveEmoji
---
--- Dispatched when all reactions of a specific emoji are removed from a message.
local function onReactionRemoveEmoji(event: Primitives.Event, callback: (removedRreactions: discord.ReactionObject) -> ())
    onEvent(event, "Discord.ReactionRemoveEmoji", function(event)
        callback(event.data["ReactionRemoveEmoji"]["removed_reactions"])
    end)
end

--- Ready
---
--- Dispatched when the bot is ready to start receiving events.
---
--- Note that you usually won't get this event from AntiRaid unless you're self-hosting or unusual circumstances.
local function onReady(event: Primitives.Event, callback: (data: discordGateway.ReadyPayload) -> ())
    onEvent(event, "Discord.Ready", function(event)
        callback(event.data["Ready"]["data_about_bot"])
    end)
end

--- Resume
---
--- Dispatched when the bot resumes after being disconnected.
---
--- Note that you usually won't get this event from AntiRaid unless you're self-hosting or unusual circumstances.
local function onResume(event: Primitives.Event, callback: (data: discordGateway.ResumePayload) -> ())
    onEvent(event, "Discord.Resume", function(event)
        callback(event.data["Resume"]["event"])
    end)
end

--- ShardStageUpdate
---
--- Dispatched when a shard’s connection stage is updated
---
--- Provides the context of the shard and the event information about the update.
---
--- Note that you usually won't get this event from AntiRaid unless you're self-hosting or unusual circumstances.
local function onShardStageUpdate(event: Primitives.Event, callback: (data: any) -> ())
    onEvent(event, "Discord.ShardStageUpdate", function(event)
        callback(event.data["ShardStageUpdate"]["event"])
    end)
end

--- ShardsReady
---
--- Dispatched when all shards are ready to start receiving events.
---
--- Note that you usually won't get this event from AntiRaid unless you're self-hosting or unusual circumstances.
local function onShardsReady(event: Primitives.Event, callback: (totalShards: number) -> ())
    onEvent(event, "Discord.ShardsReady", function(event)
        callback(event.data["ShardsReady"]["total_shards"])
    end)
end

--- StageInstanceCreate
---
--- Dispatched when a stage instance is created.
local function onStageInstanceCreate(event: Primitives.Event, callback: (instance: discord.StageInstanceObject) -> ())
    onEvent(event, "Discord.StageInstanceCreate", function(event)
        callback(event.data["StageInstanceCreate"]["stage_instance"])
    end)
end

--- StageInstanceDelete
---
--- Dispatched when a stage instance is deleted.
local function onStageInstanceDelete(event: Primitives.Event, callback: (instance: discord.StageInstanceObject) -> ())
    onEvent(event, "Discord.StageInstanceDelete", function(event)
        callback(event.data["StageInstanceDelete"]["stage_instance"])
    end)
end

--- StageInstanceUpdate
---
--- Dispatched when a stage instance is updated.
local function onStageInstanceUpdate(event: Primitives.Event, callback: (new: discord.StageInstanceObject) -> ())
    onEvent(event, "Discord.StageInstanceUpdate", function(event)
        callback(event.data["StageInstanceUpdate"]["stage_instance"])
    end)
end

--- ThreadCreate
---
--- Dispatched when a thread is created or the current user is added to a private thread.
local function onThreadCreate(event: Primitives.Event, callback: (thread: discord.ChannelObject, newlyCreated: boolean?) -> ())
    onEvent(event, "Discord.ThreadCreate", function(event)
        callback(event.data["ThreadCreate"]["thread"], event.data["ThreadCreate"]["newly_created"])
    end)
end

--- ThreadDelete
---
--- Dispatched when a thread is deleted.
---
--- Provides the partial data about the deleted thread and, if it was present in the cache before its deletion, its full data.
local function onThreadDelete(event: Primitives.Event, callback: (thread: discord.ChannelObject, full: discord.ChannelObject?) -> ())
    onEvent(event, "Discord.ThreadDelete", function(event)
        callback(event.data["ThreadDelete"]["thread"], event.data["ThreadDelete"]["full_thread_data"])
    end)
end

--- ThreadListSync
---
--- Dispatched when the current user gains access to a thread.
local function onThreadListSync(event: Primitives.Event, callback: (data: discordGateway.ThreadListSyncPayload) -> ())
    onEvent(event, "Discord.ThreadListSync", function(event)
        callback(event.data["ThreadListSync"]["thread_list_sync"])
    end)
end

--- ThreadMemberUpdate
---
--- Dispatched when a thread member is updated.
local function onThreadMemberUpdate(event: Primitives.Event, callback: (threadMember: discord.ThreadMemberObject) -> ())
    onEvent(event, "Discord.ThreadMemberUpdate", function(event)
        callback(event.data["ThreadMemberUpdate"]["thread_member"])
    end)
end

--- ThreadMembersUpdate
---
--- Dispatched when anyone is added to or removed from a thread.
local function onThreadMembersUpdate(event: Primitives.Event, callback: (data: discordGateway.ThreadMembersUpdatePayload) -> ())
    onEvent(event, "Discord.ThreadMembersUpdate", function(event)
        callback(event.data["ThreadMembersUpdate"]["thread_members_update"])
    end)
end

--- ThreadUpdate
---
--- Dispatched when a thread is updated.
local function onThreadUpdate(event: Primitives.Event, callback: (old: discord.ChannelObject?, new: discord.ChannelObject) -> ())
    onEvent(event, "Discord.ThreadUpdate", function(event)
        callback(event.data["ThreadUpdate"]["old"], event.data["ThreadUpdate"]["new"])
    end)
end

--- TypingStart
---
--- Dispatched when a user starts typing in a channel.
local function onTypingStart(event: Primitives.Event, callback: (data: discordGateway.TypingStartPayload) -> ())
    onEvent(event, "Discord.TypingStart", function(event)
        callback(event.data["TypingStart"]["event"])
    end)
end

--- UserUpdate
--- 
--- Dispatched when the user’s data is updated.
---
--- Note that you usually won't get this event from AntiRaid unless you're self-hosting or unusual circumstances.
local function onUserUpdate(event: Primitives.Event, callback: (old: discord.UserObject?, new: discord.UserObject) -> ())
    onEvent(event, "Discord.UserUpdate", function(event)
        callback(event.data["UserUpdate"]["old_data"], event.data["UserUpdate"]["new"])
    end)
end

--- VoiceChannelStatusUpdate
---
--- Dispatched when a user’s voice state is updated.
local function onVoiceChannelStatusUpdate(event: Primitives.Event, callback: (old: string?, status: string?, id: discord.Snowflake, guildId: discord.Snowflake) -> ())
    onEvent(event, "Discord.VoiceChannelStatusUpdate", function(event)
        callback(event.data["VoiceChannelStatusUpdate"]["old"], event.data["VoiceChannelStatusUpdate"]["status"], event.data["VoiceChannelStatusUpdate"]["id"], event.data["VoiceChannelStatusUpdate"]["guild_id"])
    end)
end

--- VoiceServerUpdate
---
--- Dispatched when a guild’s voice server was updated (or changed to another one).
---
--- Note that you usually won't get this event from AntiRaid unless you're self-hosting or unusual circumstances.
local function onVoiceServerUpdate(event: Primitives.Event, callback: (data: discordGateway.VoiceServerUpdatePayload) -> ())
    onEvent(event, "Discord.VoiceServerUpdate", function(event)
        callback(event.data["VoiceServerUpdate"]["event"])
    end)
end

--- VoiceStateUpdate
---
--- Dispatched when a user joins, leaves or moves to a voice channel.
local function onVoiceStateUpdate(event: Primitives.Event, callback: (old: discord.VoiceStateObject?, new: discord.VoiceStateObject) -> ())
    onEvent(event, "Discord.VoiceStateUpdate", function(event)
        callback(event.data["VoiceStateUpdate"]["old"], event.data["VoiceStateUpdate"]["new"])
    end)
end

--- WebhookUpdate
---
--- Dispatched when a channel’s webhook is updated.
local function onWebhookUpdate(event: Primitives.Event, callback: (guildId: string, belongsToChannelId: string) -> ())
    onEvent(event, "Discord.WebhookUpdate", function(event)
        callback(event.data["WebhookUpdate"]["guild_id"], event.data["WebhookUpdate"]["belongs_to_channel_id"])
    end)
end

return {
    onEvent = onEvent,
    -- Event types
    onAutoModActionExecution = onAutoModActionExecution,
    onAutoModRuleCreate = onAutoModRuleCreate,
    onAutoModRuleDelete = onAutoModRuleDelete,
    onAutoModRuleUpdate = onAutoModRuleUpdate,
    onCategoryCreate = onCategoryCreate,
    onCategoryDelete = onCategoryDelete,
    onChannelCreate = onChannelCreate,
    onChannelDelete = onChannelDelete,
    onChannelPinsUpdate = onChannelPinsUpdate,
    onChannelUpdate = onChannelUpdate,
    onCommandPermissionsUpdate = onCommandPermissionsUpdate,
    onEntitlementCreate = onEntitlementCreate,
    onEntitlementDelete = onEntitlementDelete,
    onEntitlementUpdate = onEntitlementUpdate,
    onGuildAuditLogEntryCreate = onGuildAuditLogEntryCreate,
    onGuildBanAddition = onGuildBanAddition,
    onGuildBanRemoval = onGuildBanRemoval,
    onGuildCreate = onGuildCreate,
    onGuildDelete = onGuildDelete,
    onGuildEmojisUpdate = onGuildEmojisUpdate,
    onGuildIntegrationsUpdate = onGuildIntegrationsUpdate,
    onGuildMemberAddition = onGuildMemberAddition,
    onGuildMemberRemoval = onGuildMemberRemoval,
    onGuildMemberUpdate = onGuildMemberUpdate,
    onGuildMembersChunk = onGuildMembersChunk,
    onGuildRoleCreate = onGuildRoleCreate,
    onGuildRoleDelete = onGuildRoleDelete,
    onGuildRoleUpdate = onGuildRoleUpdate,
    onGuildScheduledEventCreate = onGuildScheduledEventCreate,
    onGuildScheduledEventUpdate = onGuildScheduledEventUpdate,
    onGuildScheduledEventDelete = onGuildScheduledEventDelete,
    onGuildScheduledEventUserAdd = onGuildScheduledEventUserAdd,
    onGuildScheduledEventUserRemove = onGuildScheduledEventUserRemove,
    onGuildStickersUpdate = onGuildStickersUpdate,
    onGuildUpdate = onGuildUpdate,
    onIntegrationCreate = onIntegrationCreate,
    onIntegrationDelete = onIntegrationDelete,
    onIntegrationUpdate = onIntegrationUpdate,
    onInteractionCreate = onInteractionCreate,
    onInviteCreate = onInviteCreate,
    onInviteDelete = onInviteDelete,
    onMessage = onMessage,
    onMessageDelete = onMessageDelete,
    onMessageDeleteBulk = onMessageDeleteBulk,
    onMessagePollVoteAdd = onMessagePollVoteAdd,
    onMessagePollVoteRemove = onMessagePollVoteRemove,
    onMessageUpdate = onMessageUpdate,
    onPresenceUpdate = onPresenceUpdate,
    onRatelimit = onRatelimit,
    onReactionAdd = onReactionAdd,
    onReactionRemove = onReactionRemove,
    onReactionRemoveAll = onReactionRemoveAll,
    onReactionRemoveEmoji = onReactionRemoveEmoji,
    onReady = onReady,
    onResume = onResume,
    onShardStageUpdate = onShardStageUpdate,
    onShardsReady = onShardsReady,
    onStageInstanceCreate = onStageInstanceCreate,
    onStageInstanceDelete = onStageInstanceDelete,
    onStageInstanceUpdate = onStageInstanceUpdate,
    onThreadCreate = onThreadCreate,
    onThreadDelete = onThreadDelete,
    onThreadListSync = onThreadListSync,
    onThreadMemberUpdate = onThreadMemberUpdate,
    onThreadMembersUpdate = onThreadMembersUpdate,
    onThreadUpdate = onThreadUpdate,
    onTypingStart = onTypingStart,
    onUserUpdate = onUserUpdate,
    onVoiceChannelStatusUpdate = onVoiceChannelStatusUpdate,
    onVoiceServerUpdate = onVoiceServerUpdate,
    onVoiceStateUpdate = onVoiceStateUpdate,
    onWebhookUpdate = onWebhookUpdate
}