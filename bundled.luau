local __DARKLUA_BUNDLE_MODULES

__DARKLUA_BUNDLE_MODULES = {
    cache = {},
    load = function(m)
        if not __DARKLUA_BUNDLE_MODULES.cache[m] then
            __DARKLUA_BUNDLE_MODULES.cache[m] = {
                c = __DARKLUA_BUNDLE_MODULES[m](),
            }
        end

        return __DARKLUA_BUNDLE_MODULES.cache[m].c
    end,
}

do
    function __DARKLUA_BUNDLE_MODULES.a()
        return 'DISCORD_V10_PAYLOAD_TYPES'
    end
    function __DARKLUA_BUNDLE_MODULES.b()
        __DARKLUA_BUNDLE_MODULES.load('a')

        return {}
    end
    function __DARKLUA_BUNDLE_MODULES.c()
        __DARKLUA_BUNDLE_MODULES.load('a')

        return 'DISCORD_V10_PAYLOAD_TYPES'
    end
    function __DARKLUA_BUNDLE_MODULES.d()
        __DARKLUA_BUNDLE_MODULES.load('b')
        __DARKLUA_BUNDLE_MODULES.load('a')
        __DARKLUA_BUNDLE_MODULES.load('c')

        local function doesEventMatch(pat, event)
            local baseName = string.lower(event.base_name)
            local name = string.lower(event.name)
            local pattern = string.lower(pat)

            return baseName == pattern or name == pattern or (baseName .. '.' .. name) == pattern
        end
        local function onEvent(event, pats, callback)
            if type(pats) == 'string' then
                if doesEventMatch(pats, event) then
                    return callback(event)
                end
            else
                for _, pat in ipairs(pats)do
                    if doesEventMatch(pat, event) then
                        return callback(event)
                    end
                end
            end
        end
        local function onAutoModActionExecution(event, callback)
            onEvent(event, 'Discord.AutoModActionExecution', function(event)
                callback(event.data['AutoModActionExecution']['execution'])
            end)
        end
        local function onAutoModRuleCreate(event, callback)
            onEvent(event, 'Discord.AutoModRuleCreate', function(event)
                callback(event.data['AutoModRuleCreate']['rule'])
            end)
        end
        local function onAutoModRuleDelete(event, callback)
            onEvent(event, 'Discord.AutoModRuleDelete', function(event)
                callback(event.data['AutoModRuleDelete']['rule'])
            end)
        end
        local function onAutoModRuleUpdate(event, callback)
            onEvent(event, 'Discord.AutoModRuleUpdate', function(event)
                callback(event.data['AutoModRuleUpdate']['rule'])
            end)
        end
        local function onCategoryCreate(event, callback)
            onEvent(event, 'Discord.CategoryCreate', function(event)
                callback(event.data['CategoryCreate']['category'])
            end)
        end
        local function onCategoryDelete(event, callback)
            onEvent(event, 'Discord.CategoryDelete', function(event)
                callback(event.data['CategoryDelete']['category'])
            end)
        end
        local function onChannelCreate(event, callback)
            onEvent(event, 'Discord.ChannelCreate', function(event)
                callback(event.data['ChannelCreate']['channel'])
            end)
        end
        local function onChannelDelete(event, callback)
            onEvent(event, 'Discord.ChannelDelete', function(event)
                callback(event.data['ChannelDelete']['channel'], event.data['ChannelDelete']['messages'])
            end)
        end
        local function onChannelPinsUpdate(event, callback)
            onEvent(event, 'Discord.ChannelPinsUpdate', function(event)
                callback(event.data['ChannelPinsUpdate']['pin'])
            end)
        end
        local function onChannelUpdate(event, callback)
            onEvent(event, 'Discord.ChannelUpdate', function(event)
                callback(event.data['ChannelUpdate']['old'], event.data['ChannelUpdate']['new'])
            end)
        end
        local function onCommandPermissionsUpdate(event, callback)
            onEvent(event, 'Discord.CommandPermissionsUpdate', function(event)
                callback(event.data['CommandPermissionsUpdate']['permission'])
            end)
        end
        local function onEntitlementCreate(event, callback)
            onEvent(event, 'Discord.EntitlementCreate', function(event)
                callback(event.data['EntitlementCreate']['entitlement'])
            end)
        end
        local function onEntitlementDelete(event, callback)
            onEvent(event, 'Discord.EntitlementDelete', function(event)
                callback(event.data['EntitlementDelete']['entitlement'])
            end)
        end
        local function onEntitlementUpdate(event, callback)
            onEvent(event, 'Discord.EntitlementUpdate', function(event)
                callback(event.data['EntitlementUpdate']['entitlement'])
            end)
        end
        local function onGuildAuditLogEntryCreate(event, callback)
            onEvent(event, 'Discord.GuildAuditLogEntryCreate', function(event)
                callback(event.data['GuildAuditLogEntryCreate']['entry'], event.data['GuildAuditLogEntryCreate']['guild_id'])
            end)
        end
        local function onGuildBanAddition(event, callback)
            onEvent(event, 'Discord.GuildBanAddition', function(event)
                callback(event.data['GuildBanAddition']['banned_user'], event.data['GuildBanAddition']['guild_id'])
            end)
        end
        local function onGuildBanRemoval(event, callback)
            onEvent(event, 'Discord.GuildBanRemoval', function(event)
                callback(event.data['GuildBanRemoval']['unbanned_user'], event.data['GuildBanRemoval']['guild_id'])
            end)
        end
        local function onGuildCreate(event, callback)
            onEvent(event, 'Discord.GuildCreate', function(event)
                callback(event.data['GuildCreate']['guild'], event.data['GuildCreate']['is_new'])
            end)
        end
        local function onGuildDelete(event, callback)
            onEvent(event, 'Discord.GuildDelete', function(event)
                callback(event.data['GuildDelete']['incomplete'], event.data['GuildDelete']['full'])
            end)
        end
        local function onGuildEmojisUpdate(event, callback)
            onEvent(event, 'Discord.GuildEmojisUpdate', function(event)
                callback(event.data['GuildEmojisUpdate']['current_state'], event.data['GuildEmojisUpdate']['guild_id'])
            end)
        end
        local function onGuildIntegrationsUpdate(event, callback)
            onEvent(event, 'Discord.GuildIntegrationsUpdate', function(event)
                callback(event.data['GuildIntegrationsUpdate']['guild_id'])
            end)
        end
        local function onGuildMemberAddition(event, callback)
            onEvent(event, 'Discord.GuildMemberAddition', function(event)
                callback(event.data['GuildMemberAddition']['new_member'])
            end)
        end
        local function onGuildMemberRemoval(event, callback)
            onEvent(event, 'Discord.GuildMemberRemoval', function(event)
                callback(event.data['GuildMemberRemoval']['user'], event.data['GuildMemberRemoval']['member_data_if_available'], event.data['GuildMemberRemoval']['guild_id'])
            end)
        end
        local function onGuildMemberUpdate(event, callback)
            onEvent(event, 'Discord.GuildMemberUpdate', function(event)
                callback(event.data['GuildMemberUpdate']['old_if_available'], event.data['GuildMemberUpdate']['new'], event.data['GuildMemberUpdate']['event'])
            end)
        end
        local function onGuildMembersChunk(event, callback)
            onEvent(event, 'Discord.GuildMembersChunk', function(event)
                callback(event.data['GuildMembersChunk']['chunk'])
            end)
        end
        local function onGuildRoleCreate(event, callback)
            onEvent(event, 'Discord.GuildRoleCreate', function(event)
                callback(event.data['GuildRoleCreate']['new'])
            end)
        end
        local function onGuildRoleDelete(event, callback)
            onEvent(event, 'Discord.GuildRoleDelete', function(event)
                callback(event.data['GuildRoleDelete']['guild_id'], event.data['GuildRoleDelete']['removed_role_data_if_available'], event.data['GuildRoleDelete']['guild_id'])
            end)
        end
        local function onGuildRoleUpdate(event, callback)
            onEvent(event, 'Discord.GuildRoleUpdate', function(event)
                callback(event.data['GuildRoleUpdate']['old_data_if_available'], event.data['GuildRoleUpdate']['new'])
            end)
        end
        local function onGuildScheduledEventCreate(event, callback)
            onEvent(event, 'Discord.GuildScheduledEventCreate', function(event)
                callback(event.data['GuildScheduledEventCreate']['event'])
            end)
        end
        local function onGuildScheduledEventUpdate(event, callback)
            onEvent(event, 'Discord.GuildScheduledEventUpdate', function(event)
                callback(event.data['GuildScheduledEventUpdate']['event'])
            end)
        end
        local function onGuildScheduledEventDelete(event, callback)
            onEvent(event, 'Discord.GuildScheduledEventDelete', function(event)
                callback(event.data['GuildScheduledEventDelete']['event'])
            end)
        end
        local function onGuildScheduledEventUserAdd(event, callback)
            onEvent(event, 'Discord.GuildScheduledEventUserAdd', function(
                event
            )
                callback(event.data['GuildScheduledEventUserAdd']['subscribed'])
            end)
        end
        local function onGuildScheduledEventUserRemove(event, callback)
            onEvent(event, 'Discord.GuildScheduledEventUserRemove', function(
                event
            )
                callback(event.data['GuildScheduledEventUserRemove']['unsubscribed'])
            end)
        end
        local function onGuildStickersUpdate(event, callback)
            onEvent(event, 'Discord.GuildStickersUpdate', function(event)
                callback(event.data['GuildStickersUpdate']['current_state'], event.data['GuildStickersUpdate']['guild_id'])
            end)
        end
        local function onGuildUpdate(event, callback)
            onEvent(event, 'Discord.GuildUpdate', function(event)
                callback(event.data['GuildUpdate']['old_data_if_available'], event.data['GuildUpdate']['new_data'])
            end)
        end
        local function onIntegrationCreate(event, callback)
            onEvent(event, 'Discord.IntegrationCreate', function(event)
                callback(event.data['IntegrationCreate']['integration'])
            end)
        end
        local function onIntegrationDelete(event, callback)
            onEvent(event, 'Discord.IntegrationDelete', function(event)
                callback(event.data['IntegrationDelete']['integration_id'], event.data['IntegrationDelete']['guild_id'], event.data['IntegrationDelete']['application_id'])
            end)
        end
        local function onIntegrationUpdate(event, callback)
            onEvent(event, 'Discord.IntegrationUpdate', function(event)
                callback(event.data['IntegrationUpdate']['integration'])
            end)
        end
        local function onInteractionCreate(event, callback)
            onEvent(event, 'Discord.InteractionCreate', function(event)
                callback(event.data['InteractionCreate']['interaction'])
            end)
        end
        local function onInviteCreate(event, callback)
            onEvent(event, 'Discord.InviteCreate', function(event)
                callback(event.data['InviteCreate']['data'])
            end)
        end
        local function onInviteDelete(event, callback)
            onEvent(event, 'Discord.InviteDelete', function(event)
                callback(event.data['InviteDelete']['data'])
            end)
        end
        local function onMessage(event, callback)
            onEvent(event, 'Discord.Message', function(event)
                callback(event.data['Message']['new_message'])
            end)
        end
        local function onMessageDelete(event, callback)
            onEvent(event, 'Discord.MessageDelete', function(event)
                callback(event.data['MessageDelete']['channel_id'], event.data['MessageDelete']['deleted_message_id'], event.data['MessageDelete']['guild_id'])
            end)
        end
        local function onMessageDeleteBulk(event, callback)
            onEvent(event, 'Discord.MessageDeleteBulk', function(event)
                callback(event.data['MessageDeleteBulk']['channel_id'], event.data['MessageDeleteBulk']['multiple_deleted_messages_ids'], event.data['MessageDeleteBulk']['guild_id'])
            end)
        end
        local function onMessagePollVoteAdd(event, callback)
            onEvent(event, 'Discord.MessagePollVoteAdd', function(event)
                callback(event.data['MessagePollVoteAdd']['event'])
            end)
        end
        local function onMessagePollVoteRemove(event, callback)
            onEvent(event, 'Discord.MessagePollVoteRemove', function(event)
                callback(event.data['MessagePollVoteRemove']['event'])
            end)
        end
        local function onMessageUpdate(event, callback)
            onEvent(event, 'Discord.MessageUpdate', function(event)
                callback(event.data['MessageUpdate']['old_if_available'], event.data['MessageUpdate']['new'], event.data['MessageUpdate']['event'])
            end)
        end
        local function onPresenceUpdate(event, callback)
            onEvent(event, 'Discord.PresenceUpdate', function(event)
                callback(event.data['PresenceUpdate']['old_data'], event.data['PresenceUpdate']['new_data'])
            end)
        end
        local function onRatelimit(event, callback)
            onEvent(event, 'Discord.Ratelimit', function(event)
                callback(event.data['Ratelimit']['data'])
            end)
        end
        local function onReactionAdd(event, callback)
            onEvent(event, 'Discord.ReactionAdd', function(event)
                callback(event.data['ReactionAdd']['add_reaction'])
            end)
        end
        local function onReactionRemove(event, callback)
            onEvent(event, 'Discord.ReactionRemove', function(event)
                callback(event.data['ReactionRemove']['removed_reaction'])
            end)
        end
        local function onReactionRemoveAll(event, callback)
            onEvent(event, 'Discord.ReactionRemoveAll', function(event)
                callback(event.data['ReactionRemoveAll']['guild_id'], event.data['ReactionRemoveAll']['channel_id'], event.data['ReactionRemoveAll']['removed_from_message_id'])
            end)
        end
        local function onReactionRemoveEmoji(event, callback)
            onEvent(event, 'Discord.ReactionRemoveEmoji', function(event)
                callback(event.data['ReactionRemoveEmoji']['removed_reactions'])
            end)
        end
        local function onReady(event, callback)
            onEvent(event, 'Discord.Ready', function(event)
                callback(event.data['Ready']['data_about_bot'])
            end)
        end
        local function onResume(event, callback)
            onEvent(event, 'Discord.Resume', function(event)
                callback(event.data['Resume']['event'])
            end)
        end
        local function onShardStageUpdate(event, callback)
            onEvent(event, 'Discord.ShardStageUpdate', function(event)
                callback(event.data['ShardStageUpdate']['event'])
            end)
        end
        local function onShardsReady(event, callback)
            onEvent(event, 'Discord.ShardsReady', function(event)
                callback(event.data['ShardsReady']['total_shards'])
            end)
        end
        local function onStageInstanceCreate(event, callback)
            onEvent(event, 'Discord.StageInstanceCreate', function(event)
                callback(event.data['StageInstanceCreate']['stage_instance'])
            end)
        end
        local function onStageInstanceDelete(event, callback)
            onEvent(event, 'Discord.StageInstanceDelete', function(event)
                callback(event.data['StageInstanceDelete']['stage_instance'])
            end)
        end
        local function onStageInstanceUpdate(event, callback)
            onEvent(event, 'Discord.StageInstanceUpdate', function(event)
                callback(event.data['StageInstanceUpdate']['stage_instance'])
            end)
        end
        local function onThreadCreate(event, callback)
            onEvent(event, 'Discord.ThreadCreate', function(event)
                callback(event.data['ThreadCreate']['thread'], event.data['ThreadCreate']['newly_created'])
            end)
        end
        local function onThreadDelete(event, callback)
            onEvent(event, 'Discord.ThreadDelete', function(event)
                callback(event.data['ThreadDelete']['thread'], event.data['ThreadDelete']['full_thread_data'])
            end)
        end
        local function onThreadListSync(event, callback)
            onEvent(event, 'Discord.ThreadListSync', function(event)
                callback(event.data['ThreadListSync']['thread_list_sync'])
            end)
        end
        local function onThreadMemberUpdate(event, callback)
            onEvent(event, 'Discord.ThreadMemberUpdate', function(event)
                callback(event.data['ThreadMemberUpdate']['thread_member'])
            end)
        end
        local function onThreadMembersUpdate(event, callback)
            onEvent(event, 'Discord.ThreadMembersUpdate', function(event)
                callback(event.data['ThreadMembersUpdate']['thread_members_update'])
            end)
        end
        local function onThreadUpdate(event, callback)
            onEvent(event, 'Discord.ThreadUpdate', function(event)
                callback(event.data['ThreadUpdate']['old'], event.data['ThreadUpdate']['new'])
            end)
        end
        local function onTypingStart(event, callback)
            onEvent(event, 'Discord.TypingStart', function(event)
                callback(event.data['TypingStart']['event'])
            end)
        end
        local function onUserUpdate(event, callback)
            onEvent(event, 'Discord.UserUpdate', function(event)
                callback(event.data['UserUpdate']['old_data'], event.data['UserUpdate']['new'])
            end)
        end
        local function onVoiceChannelStatusUpdate(event, callback)
            onEvent(event, 'Discord.VoiceChannelStatusUpdate', function(event)
                callback(event.data['VoiceChannelStatusUpdate']['old'], event.data['VoiceChannelStatusUpdate']['status'], event.data['VoiceChannelStatusUpdate']['id'], event.data['VoiceChannelStatusUpdate']['guild_id'])
            end)
        end
        local function onVoiceServerUpdate(event, callback)
            onEvent(event, 'Discord.VoiceServerUpdate', function(event)
                callback(event.data['VoiceServerUpdate']['event'])
            end)
        end
        local function onVoiceStateUpdate(event, callback)
            onEvent(event, 'Discord.VoiceStateUpdate', function(event)
                callback(event.data['VoiceStateUpdate']['old'], event.data['VoiceStateUpdate']['new'])
            end)
        end
        local function onWebhookUpdate(event, callback)
            onEvent(event, 'Discord.WebhookUpdate', function(event)
                callback(event.data['WebhookUpdate']['guild_id'], event.data['WebhookUpdate']['belongs_to_channel_id'])
            end)
        end

        return {
            onEvent = onEvent,
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
            onWebhookUpdate = onWebhookUpdate,
        }
    end
end

local discord = require'@antiraid/discord'
local promise = require'@antiraid/promise'

__DARKLUA_BUNDLE_MODULES.load('b')

local event = __DARKLUA_BUNDLE_MODULES.load('d')
local ctx, evt = ...
local discordExecutor = discord.new(ctx)

event.onMessage(evt, function(msg)
    print(msg.content)

    local p = promise.yield(discordExecutor.get_audit_logs({}))

    print(p.application_commands)

    local msg_handle = promise.yield(discordExecutor.create_message({
        channel_id = 'mychannelid',
        data = {
            content = 'Hello, world!',
        },
    }))

    print(msg_handle.data())
end)
