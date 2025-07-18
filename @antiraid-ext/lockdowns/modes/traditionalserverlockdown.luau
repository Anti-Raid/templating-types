local permissions = require"@discord-types/permission"
local mode = require("../mode")
local handle = require("../handle")
local utils = require("../utils")
local discord = require "@discord-types/apiTypes"
local set = require"@antiraid-ext/set"
local ActionLimiter = require"@antiraid-ext/limiter"

--- The perms to deny on overwrite roles
local DENY_PERMS: {permissions.Permissions} = {
    "SendMessages",
    "SendMessagesInThreads",
    "SendTtsMessages",
    "Connect",
}

local function TraditionalLockdown(): mode.LockdownMode 
    local self = {}

    local function _fromdata(data: any): {[discord.Snowflake]: {discord.OverwriteObject}}
        for channelid, perm in data do
            if type(channelid) ~= "string" or type(perm) ~= "table" then
                error("Invalid data format for TraditionalLockdown")
            end

            for _, overwrite in perm do
                if type(overwrite) ~= "table" then 
                    error("Invalid overwrite format for TraditionalLockdown [not a array]")
                end
                overwrite = overwrite :: discord.OverwriteObject
                if not overwrite.id or not overwrite.type then
                    error("Invalid overwrite format for TraditionalLockdown")
                end
            end
        end
        return data
    end

    local function string_form(): string
        return "tsl"
    end

    --- TSL > QSL as it updates all channels in a server
    local function specificity(): number
        return 1
    end

    --- TSL doesn't need to test anything so this is a no-op
    local function test_noop(_data: mode.BaseLockdownModeData) end

    local function autofix_noop(_data: mode.BaseLockdownModeData): ()
        error("A Traditional Lockdown does not support autofixing")
    end

    local function setup(data: mode.BaseLockdownModeData) 
        local map: {[discord.Snowflake]: {discord.OverwriteObject}} = {}

        -- Collect map of channels with the underlying permission overwrites
        for _, channel in data.channels do 
            local overwrites = channel.permission_overwrites

            -- Check for an underlying permission to the role
            local underlying = utils.getunderlyingchannelpermissions(data.lockdowns, channel.id)
            if underlying then overwrites = underlying end -- Update if underlying is present

            map[channel.id] = overwrites or {} -- Use the overwrites or an empty table if none exist
        end

        return map
    end

    local function shareable(lockdown: mode.Lockdown): handle.LockdownSharableData 
        local data = _fromdata(lockdown.data)
        return {
            role_permissions = {},
            channel_permissions = data
        }
    end

    local function create(data: mode.ExtLockdownModeData) 
        local limiter = ActionLimiter(2, 3) -- 2 attempts every 3 seconds
        for idx, channel in data.channels do 
            if data.all_handles.ischannellocked(channel.id, specificity()) then 
                continue -- Someone else is handling this channel
            end

            local overwrites = channel.permission_overwrites

            local pendingOverwriteRoles = data.critical_roles.copy()

            for _, overwrite in overwrites do 
                -- Ignore non-role overwrites
                if overwrite.type ~= permissions.OverwriteObjectTypeRole then continue end
                if data.critical_roles.exists(overwrite.id) then 
                    pendingOverwriteRoles.remove(overwrite.id) -- Remove from pending if already exists
                    overwrite.deny = tostring(permissions.toBitFlag(DENY_PERMS))
                    overwrite.allow = tostring(permissions.toBitFlag({})) -- Clear the allow perms
                end
            end

            -- Add new overwrites for critical roles
            for roleId in pendingOverwriteRoles do
                local newOverwrite: discord.OverwriteObject = {
                    id = roleId,
                    type = permissions.OverwriteObjectTypeRole,
                    deny = tostring(permissions.toBitFlag(DENY_PERMS)),
                    allow = tostring(permissions.toBitFlag({})),
                }
                table.insert(overwrites, newOverwrite)
            end

            -- Limit the action to prevent spamming
            limiter.attempt()

            local newchannel = data.ctx.Discord:edit_channel({
                reason = "Traditional server lockdown",
                channel_id = channel.id,
                data = {
                    permission_overwrites = overwrites,
                }
            }).data

            utils.replacechannel(data, newchannel, idx)
        end
    end

    local function revert(data: mode.ExtLockdownModeData) 
        local limiter = ActionLimiter(2, 3) -- 2 attempts every 3 seconds
        local oldpermissions = _fromdata(data.lockdown.data)

        -- FUTURE IDEAS: Handle this slightly better (maybe only apply the changes to critical roles somehow)
        for channelid, overwrites in oldpermissions do 
            if data.all_handles.ischannellocked(channelid, specificity()) then 
                continue -- Someone else is handling this channel
            end
            -- Limit the action to prevent spamming
            limiter.attempt()

            local newchannel = data.ctx.Discord:edit_channel({
                reason = "Traditional server lockdown revert",
                channel_id = channelid,
                data = {
                    permission_overwrites = overwrites,
                }
            }).data

            utils.replacechannel(data, newchannel)
        end
    end

    local function handle(data: mode.BaseLockdownModeData, lockdown: mode.Lockdown): handle.LockdownModeHandle
        -- TSL locks all channels, but *NOT* roles
        local channels = set.Set() :: set.Set<discord.Snowflake>
        for _, channel in data.channels do
            channels.add(channel.id)
        end
        return {
            roles = set.Set() :: set.Set<discord.Snowflake>,
            channels = channels,
        }
    end

    self.string_form = string_form
    self.specificity = specificity
    self.test = test_noop
    self.autofix = autofix_noop
    self.setup = setup
    self.shareable = shareable
    self.create = create
    self.revert = revert
    self.handle = handle

    return self
end

return TraditionalLockdown 