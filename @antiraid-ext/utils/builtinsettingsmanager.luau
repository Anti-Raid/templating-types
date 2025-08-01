--!strict
local discord = require "@discord-types/apiTypes"
local Primitives = require "@antiraid-core/primitives"

export type BaseAction = {
    name: string,
    value: string,
    description: string,
}

--[[
    Manages the builtin settings for the bot in the server
]]
export type BuiltinSettingsManager = {
    --- Gets the mod logs channel for a specific action.
    ---
    --- @param action string The action to get the mod logs channel for.
    --- @return discord.Snowflake? The channel ID of the mod logs channel for the action, or nil if not set.
    getModLogsChannel: (action: string) -> discord.Snowflake?,
    --- Gets all mod logs channels.
    ---
    --- @return {[string]: discord.Snowflake} A table mapping action names to channel IDs.
    getAllModLogsChannels: () -> {[string]: discord.Snowflake},
    --- Sets the mod logs channel for a specific action.
    ---
    --- @param action string? The action to set the mod logs channel for. If nil, sets the default channel.
    --- @param channelId discord.Snowflake The channel ID to set as the mod logs channel.
    --- @return nil
    setModLogsChannel: (action: string?, channelId: discord.Snowflake) -> nil,  
    --- Deletes the mod logs channel for a specific action.
    ---
    --- @param action string? The action to delete the mod logs channel for. If nil, deletes the default channel.
    --- @return nil 
    deleteModLogsChannel: (action: string?) -> nil,

    -- Base mod sting endpoints

    --- Gets the base moderation sting counts for a specific action.
    ---
    --- @param action string The action to get the base moderation sting counts for.
    --- @return number? The number of stings for the action, or nil if not set.
    getBaseModerationStingCounts: (action: string) -> number?,
    --- Gets all base moderation sting counts.
    ---
    --- @return {[string]: number} A table mapping action names to the number of stings.
    getAllBaseModerationStingCounts: () -> {[string]: number},
    --- Sets the base moderation sting counts for a specific action.
    ---
    --- @param action string? The action to set the base moderation sting counts for. If nil, sets the default counts.
    --- @param stings number The number of stings to set for the action.
    --- @return nil
    setBaseModerationStingCounts: (action: string?, stings: number) -> nil,   
    --- Deletes the base moderation sting counts for a specific action.
    ---
    --- @param action string? The action to delete the base moderation sting counts for. If nil, deletes the default counts.
    --- @return nil
    deleteBaseModerationStingCounts: (action: string?) -> nil,

    -- Actions

    --- Gets all mod logs actions.
    --- @return {BaseAction} A table of mod logs actions with their names, values, and descriptions
    getAllModLogsActions: () -> {BaseAction},
    --- Gets all mod actions.
    --- @return {BaseAction} A table of mod actions with their names, values,
    getAllModActions: () -> {BaseAction}
}

local function BuiltinSettingsManager(ctx: Primitives.TemplateContext): BuiltinSettingsManager
    local self = {}

    local storeTab = ctx.store :: any

    local function getModLogsChannel(action: string): discord.Snowflake?
        local mlc = ctx.KV:get(`modlogsChannel`, {"builtins.settings"})

        if type(mlc) == "string" then return mlc end
        if type(mlc) == "table" then 
            local channel = (mlc :: any)[action]
            if channel then
                return channel
            end

            local defaultChannel = (mlc :: any)["default"]
            if defaultChannel then
                return defaultChannel
            end

            return nil
        else
            return nil
        end
    end

    local function getAllModLogsChannels(): {[string]: discord.Snowflake}
        local mlc = ctx.KV:get(`modlogsChannel`, {"builtins.settings"})

        if type(mlc) == "string" then
            return { default = mlc }
        elseif type(mlc) == "table" then
            return (mlc :: any)
        else
            return {}
        end
    end

    local function setModLogsChannel(action: string?, channelId: discord.Snowflake): nil
        local mlc = ctx.KV:get(`modlogsChannel`, {"builtins.settings"})

        if type(mlc) == "string" then
            mlc = { default = mlc }
        elseif type(mlc) == "table" then
            mlc = (mlc :: any)
        else
            mlc = {}
        end

        if action then
            mlc[action] = channelId
        else
            mlc["default"] = channelId
        end

        ctx.KV:set(`modlogsChannel`, mlc, {"builtins.settings"})
        return nil
    end

    local function deleteModLogsChannel(action: string?): nil
        local mlc = ctx.KV:get(`modlogsChannel`, {"builtins.settings"})

        local newMlc = nil
        if type(mlc) == "string" then
            newMlc = nil -- Just delete the string
        elseif type(mlc) == "table" then
            newMlc = mlc :: any
            newMlc[action or "default"] = nil
        else
            newMlc = nil
        end

        ctx.KV:set(`modlogsChannel`, newMlc, {"builtins.settings"})
        return nil
    end

    local function getBaseModerationStingCounts(action: string): number?
        local mlc = ctx.KV:get(`baseModerationStingCounts`, {"builtins.settings"})

        if type(mlc) == "number" then return mlc end
        if type(mlc) == "string" then return tonumber(mlc) end
        if type(mlc) == "table" then 
            local stings = (mlc :: any)[action]
            if stings then
                return stings
            end

            local defaultStings = (mlc :: any)["default"]
            if defaultStings then
                return defaultStings
            end

            return nil
        else
            return nil
        end
    end

    local function getAllBaseModerationStingCounts(): {[string]: number}
        local mlc = ctx.KV:get(`baseModerationStingCounts`, {"builtins.settings"})

        if type(mlc) == "number" then return { default = mlc } end
        if type(mlc) == "string" then 
            local stings = tonumber(mlc)
            if not stings then return {} end
            return { default = stings }
        end
        if type(mlc) == "table" then
            return (mlc :: any)
        else
            return {}
        end
    end

    local function setBaseModerationStingCounts(action: string?, stings: number): nil
        local mlc = ctx.KV:get(`baseModerationStingCounts`, {"builtins.settings"})

        if type(mlc) == "number" then
            mlc = { default = mlc }
        elseif type(mlc) == "string" then
            local stings_num = tonumber(mlc)
            mlc = { default = stings_num }
        elseif type(mlc) == "table" then
            mlc = (mlc :: any)
        else
            mlc = {}
        end

        if action then
            mlc[action] = stings
        else
            mlc["default"] = stings
        end

        ctx.KV:set(`baseModerationStingCounts`, mlc, {"builtins.settings"})
        return nil
    end

    local function deleteBaseModerationStingCounts(action: string?): nil
        local mlc = ctx.KV:get(`baseModerationStingCounts`, {"builtins.settings"})

        local newMlc = nil
        if type(mlc) == "number" or type(mlc) == "string" then
            newMlc = nil -- Just delete the string
        elseif type(mlc) == "table" then
            newMlc = mlc :: any
            newMlc[action or "default"] = nil
        else
            newMlc = nil
        end

        ctx.KV:set(`baseModerationStingCounts`, newMlc, {"builtins.settings"})
        return nil
    end

    local function getAllModLogsActions() 
        local base = {
            { name = "Default", value = "default", description = "The default log channel for all moderation logs" },
            { name = "Sting Create", value = "sting_create", description = "The log channel for when a sting is created" },
            { name = "Sting Delete", value = "sting_delete", description = "The log channel for when a sting is deleted" },
            { name = "Sting Expiration Set", value = "sting_set_expiration", description = "The long channel for when a stings expiration is manually set"},
            { name = "Sting Expiration Removed", value = "sting_delete_expiration", description = "The log channel for when a sting expiration is removed" },
            { name = "Punishment Create", value = "punishment_create", description = "The log channel for when a punishment is created" },
            { name = "Punishment Delete", value = "punishment_delete", description = "The log channel for when a punishment is deleted" },
        }

        if (storeTab and storeTab.getAllModLogsActions) then
            local customActions = (storeTab.getAllModLogsActions :: any)()
            for _, action in customActions do
                table.insert(base, action)
            end
        end

        return base
    end

    local function getAllModActions() 
        local base = {
            { name = "Default", value = "default", description = "The default mod action" },
            { name = "Ban Member", value = "ban_member", description = "Member banned" },
            { name = "Kick Member", value = "kick_member", description = "Member kicked" },
            { name = "Timeout Member", value = "timeout_member", description = "Member timed out" },
        }

        if storeTab and storeTab.getAllModActions then
            assert(type(storeTab.getAllModActions) == "function", "storeTab.getAllModActions must be a function")
            local customActions = (storeTab.getAllModActions :: any)()
            for _, action in customActions do
                table.insert(base, action)
            end
        end

        return base
    end

    self.getModLogsChannel = getModLogsChannel
    self.getAllModLogsChannels = getAllModLogsChannels
    self.setModLogsChannel = setModLogsChannel
    self.deleteModLogsChannel = deleteModLogsChannel
    self.getBaseModerationStingCounts = getBaseModerationStingCounts
    self.getAllBaseModerationStingCounts = getAllBaseModerationStingCounts
    self.setBaseModerationStingCounts = setBaseModerationStingCounts
    self.deleteBaseModerationStingCounts = deleteBaseModerationStingCounts

    self.getAllModLogsActions = getAllModLogsActions
    self.getAllModActions = getAllModActions

    return self
end

return BuiltinSettingsManager