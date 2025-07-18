local coretypes = require"./coretypes"
local discordRestTypes = require"@discord-types/restTypes"
local discord = require"@discord-types/apiTypes"
local commandBuilder = require "@discord-types/builders/interaction/interaction"
local interaction = require"@antiraid-ext/interactions"
local pp = require"@antiraid-ext/prettyprint"
local CommandBuilder = require"./commandbuilder"

local APP_COMMAND_CHATINPUT = 1

--- FlowFramework provides a Framework interface with the following special features:
---
--- 1. Commands can be registered directly as full name, e.g: "test foo bar" with the
--- commands being automatically compiled into a single command with subcommands.
--- 2. Subcommands and subcommand groups are automatically handled, with the base command
--- being created if it does not exist.
--- 3. getcommand returns either the full command (if registered as such) or the base command
--- if the command was registered as one monolithic unit.
local function BaseFramework(strict_val: boolean?): coretypes.BaseFramework
    local strict = strict_val == nil or strict_val
    local self = {}

    -- Internal storage for compiled commands
    local compiled_commands = nil :: {discordRestTypes.CreateGuildApplicationCommandRequest}?

    local registered_commands = {} :: {[string]: coretypes.Command}
    self.suffix = nil :: string?

    -- Registers a command in the framework.
    local function registerCommand(command: coretypes.Command)
        if not command or not command.name or not command.command or not command.run then
            error("Invalid command provided")
        end

        if self.suffix then
            command.name = command.name .. self.suffix
        end

        if strict and registered_commands[command.name] then
            error("Command with name '" .. command.name .. "' is already registered")
        end

        registered_commands[command.name] = command
        compiled_commands = nil -- Invalidate compiled commands
    end

    local function _compileCommands(): {discordRestTypes.CreateGuildApplicationCommandRequest} 
        type CommandData = {
            req: discordRestTypes.CreateGuildApplicationCommandRequest,
            parts: {string}
        }

        local compiledCommandsMap: {[number]: {CommandData}} = {
            [1] = {}, -- Base commands
            [2] = {}, -- Subcommands / subcommand groups
            [3] = {}  -- Subcommand 
        }

        for _, command in registered_commands do 
            -- Split command.name by spaces to handle subcommands
            local split = command.name:split(" ")

            if #split ~= 1 and #split ~= 2 and #split ~= 3 then
                error("Command name '" .. command.name .. "' must be either a single word (command), two words (subcommand), or three words (subcommand group)")
            end

            table.insert(compiledCommandsMap[#split], {
                req = command.command,
                parts = split
            })
        end

        local compiledCommands: {discordRestTypes.CreateGuildApplicationCommandRequest} = {}
        
        -- First add the base commands
        for _, commandData in compiledCommandsMap[1] do
            local req = commandData.req
            -- Set the type to ChatInput
            req.type = APP_COMMAND_CHATINPUT
            -- Set the integration type to GuildInstall if not already set
            if not req.integration_types or #req.integration_types == 0 then
                req.integration_types = {interaction.IntegrationType("GuildInstall")}
            end
            -- Add the base command to the compiled commands
            table.insert(compiledCommands, commandData.req)
        end

        -- Next add the subcommands, with a base command autoadded
        for _, commandData in compiledCommandsMap[2] do
            -- Check if the base command exists
            local baseCommandObj = nil :: discordRestTypes.CreateGuildApplicationCommandRequest?
            for _, cmd in compiledCommands do
                if cmd.name == commandData.parts[1] then
                    baseCommandObj = cmd
                    break
                end
            end

            -- If the base command does not exist, create it
            -- and add it to the compiled commands
            --
            -- As Lua tables are reference types, just mutating the baseCommandObj
            -- table after insertion to compiledCommands should work
            if baseCommandObj == nil then
                baseCommandObj = commandBuilder.new({ name = commandData.parts[1] })
                    :addIntegrationType("GuildInstall")
                    :setType("ChatInput")
                    :addContext("Guild")
                    :setDescription("Base command")
                    :build()

                table.insert(compiledCommandsMap[1], {
                    req = baseCommandObj,
                    parts = {commandData.parts[1]},
                })
                table.insert(compiledCommands, baseCommandObj)
            end

            -- Some type assertions and verifications
            baseCommandObj = baseCommandObj :: discordRestTypes.CreateGuildApplicationCommandRequest

            if not baseCommandObj.options then
                baseCommandObj.options = {}
            end

            local options = baseCommandObj.options :: {discord.ApplicationCommandOptionObject}

            -- Validate options to ensure the base command does not have any non-subcommand related options
            if #options > 0 then 
                for _, option in options do
                    -- It is perfectly valid for a base command to have subcommands and a subcommand group
                    if option.type ~= interaction.ApplicationCommandOptionType("SubCommand") and option.type ~= interaction.ApplicationCommandOptionType("SubCommandGroup") then 
                        error("A subcommand can only be added to a base command if the base command has no other options but " .. option.name .. " is not a subcommand")
                    end
                    if option.name == commandData.parts[2] then 
                        error("Subcommand '" .. commandData.parts[2] .. "' already exists in base command '" .. commandData.parts[1] .. "'")
                    end
                end
            end

            table.insert(options, {
                type = interaction.ApplicationCommandOptionType("SubCommand"),
                name = commandData.req.name,
                name_localizations = commandData.req.name_localizations,
                description = commandData.req.description,
                description_localizations = commandData.req.description_localizations,
                options = commandData.req.options,
            })
        end


        -- Finally add the subcommands with subcommand groups
        for _, commandData in compiledCommandsMap[3] do
            -- Check if the base command exists, if not create it
            local baseCommandObj = nil :: discordRestTypes.CreateGuildApplicationCommandRequest?
            for _, cmd in compiledCommands do
                if cmd.name == commandData.parts[1] then
                    baseCommandObj = cmd
                    break
                end
            end

            if baseCommandObj == nil then
                baseCommandObj = commandBuilder.new({ name = commandData.parts[1] })
                    :addIntegrationType("GuildInstall")
                    :setType("ChatInput")
                    :addContext("Guild")
                    :setDescription("Base command")
                    :build()

                table.insert(compiledCommandsMap[1], {
                    req = baseCommandObj,
                    parts = {commandData.parts[1]},
                })
                table.insert(compiledCommands, baseCommandObj)
            end

            baseCommandObj = baseCommandObj :: discordRestTypes.CreateGuildApplicationCommandRequest

            if baseCommandObj.options == nil then
                baseCommandObj.options = {}
            end

            local options = baseCommandObj.options or {} :: {discord.ApplicationCommandOptionObject}

            -- Check if the subcommand group exists, if not create it
            local subcommand = nil :: discord.ApplicationCommandOptionObject?
            if #options > 0 then 
                for _, option in options do
                    -- It is perfectly valid for a base command to have subcommands and a subcommand group
                    if option.type ~= interaction.ApplicationCommandOptionType("SubCommand") and option.type ~= interaction.ApplicationCommandOptionType("SubCommandGroup") then 
                        error("A subcommand can only be added to a base command if the base command has no other options but " .. option.name .. " is not a subcommand")
                    end
                    if option.name == commandData.parts[2] then 
                        subcommand = option
                    end
                end
            end

            if subcommand == nil then
                subcommand = {
                    type = interaction.ApplicationCommandOptionType("SubCommandGroup"),
                    name = commandData.parts[2],
                    description = "Subcommand group",
                    options = {},
                }
                table.insert(baseCommandObj.options :: {discord.ApplicationCommandOptionObject}, subcommand)
            elseif subcommand.type ~= interaction.ApplicationCommandOptionType("SubCommandGroup") then 
                if strict then
                    error("Option '" .. commandData.parts[2] .. "' already exists but is not of type SubCommandGroup")
                else 
                    subcommand.type = interaction.ApplicationCommandOptionType("SubCommandGroup")
                    subcommand.description = "Subcommand group"
                    subcommand.options = {}
                end
            end

            subcommand = subcommand :: discord.ApplicationCommandOptionObject

            if not subcommand.options then
                subcommand.options = {}
            end

            -- Add the subcommand to the subcommand group
            table.insert(subcommand.options :: {discord.ApplicationCommandOptionObject}, {
                type = interaction.ApplicationCommandOptionType("SubCommand"),
                name = commandData.parts[3],
                name_localizations = commandData.req.name_localizations,
                description = commandData.req.description,
                description_localizations = commandData.req.description_localizations,
                options = commandData.req.options,
            })
        end

        return compiledCommands
    end

    local function commands(): {discordRestTypes.CreateGuildApplicationCommandRequest}
        if not compiled_commands then
            compiled_commands = _compileCommands()
        end
        return compiled_commands :: {discordRestTypes.CreateGuildApplicationCommandRequest}
    end

    local function getcommand(name: {string}): coretypes.Command?
        if not name or #name == 0 then
            error("Name cannot be empty")
        end

        local command = registered_commands[table.concat(name, " ")]
        if command then
            return command :: coretypes.Command
        end
        
        if #name > 1 then 
            command = registered_commands[name[1]]
            if command then
                return command :: coretypes.Command
            end
        end

        return nil
    end

    self.registerCommand = registerCommand
    self._compileCommands = _compileCommands
    self.commands = commands
    self.getcommand = getcommand

    return self
end

-- Test Framework.commands
if _G.cli then 
    local TFramework = BaseFramework()
    TFramework.registerCommand(
        CommandBuilder()
        .addSchema("test foo bar", function(i): commandBuilder.JSON 
            return i
            :option(
                function(opt)
                    return opt
                    :setName("bot")
                    :setDescription("The bot to use")
                    :setType("String")
                    :build()
                end
            )
            :build()
        end)
        .setRun(function(data: coretypes.RunData)
            -- No-op
        end)
        .build()
    ) 
    TFramework.registerCommand(
        CommandBuilder()
        .addSchema("test foo baz", function(i): commandBuilder.JSON 
            return i:build()
        end)
        .setRun(function(data: coretypes.RunData)
            -- No-op
        end)
        .build()
    ) 

    print(pp(TFramework.commands()))
end

return {
    BaseFramework = BaseFramework,
}