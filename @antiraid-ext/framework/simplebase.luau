local coretypes = require"./coretypes"
local discordRestTypes = require"@discord-types/restTypes"

--- A simple base framework for simple monolithic commands
local function BaseFramework(strict_val: boolean?): coretypes.BaseFramework
    local strict = strict_val == nil or strict_val
    local self = {}

    -- Internal storage for compiled commands
    local registered_commands = {} :: {[string]: coretypes.Command}
    self.suffix = nil :: string?

    local registered_settings = {} :: {[string]: coretypes.FrameworkSetting}

    -- Registers a command in the framework.
    local function registerCommand(command: coretypes.Command)
        if command.register then 
            command.command = command.register()
        end

        if not command or not command.command or not command.run then
            error("Invalid command provided")
        end

        if self.suffix then
            command.command.name = command.command.name .. self.suffix
        end

        if strict and registered_commands[command.command.name] then
            error("Command with name '" .. command.command.name .. "' is already registered")
        end

        registered_commands[command.command.name] = command
    end

    local function registerSetting(name: string, setting: coretypes.FrameworkSetting)
        if not setting or (not setting.schema and not setting.dynSchema) or not setting.execute then
            error("Invalid setting provided")
        end

        if self.suffix then
            name ..= self.suffix
        end

        if strict and registered_settings[name] then
            error("Setting with name '" .. name .. "' is already registered")
        end

        registered_settings[name] = setting
    end

    local function commands(): {discordRestTypes.CreateGuildApplicationCommandRequest}
        local schema = {}
        for _, command in registered_commands do
            if not command.command then
                error("Command '" .. command.name .. "' does not have a command schema")
            end
            table.insert(schema, command.command)
        end
        return schema
    end

    local function getcommand(name: {string}): coretypes.Command?
        if not name or #name == 0 then
            error("Name cannot be empty")
        end

        local command = registered_commands[table.concat(name, " ")]
        if command then
            return command :: coretypes.Command
        end
        
        return nil
    end

    local function getcommands(): {[string]: coretypes.Command}
        return registered_commands
    end

    local function getsettings(): {[string]: coretypes.FrameworkSetting}
        return registered_settings
    end

    self.registerCommand = registerCommand
    self.registerSetting = registerSetting
    self.commands = commands
    self.getcommand = getcommand
    self.getcommands = getcommands
    self.getsettings = getsettings

    return self
end

return {
    BaseFramework = BaseFramework,
}