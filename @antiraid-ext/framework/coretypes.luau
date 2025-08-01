local discordRestTypes = require"@discord-types/restTypes"
local discord = require"@discord-types/apiTypes"
local primitives = require"@antiraid-core/primitives"
local stingmanager = require"@antiraid-ext/utils/stingmanager"
local punishmentmanager = require"@antiraid-ext/utils/punishmentmanager"
local builtinSettingsManager = require"@antiraid-ext/utils/builtinsettingsmanager"
local userinfomanager = require"@antiraid-ext/utils/userinfo"
local appcommands = require"@antiraid-ext/appcommands"
local events = require"@antiraid-core/events"
local commandBuilder = require "@discord-types/builders/interaction/interaction"
local settings = require "@antiraid-core/settings"

export type BaseFrameworkData = {
    templateName: string,
    stingManager: stingmanager.StingManager,
    punishmentmanager: punishmentmanager.PunishmentManager,
    builtinSettingsManager: builtinSettingsManager.BuiltinSettingsManager,
    userinfomanager: userinfomanager.UserInfoManager,
    settings: {settings.Setting},
}

--- Framework provides a simple abstraction for building custom scripts with
--- command handling etc. done for you
export type Framework = {
    --- The ID of the framework.
    id: string,
    --- The base framework that is being used.
    base: BaseFramework,
    --- Attaches a button callback to the framework.
    attachButtonCallback: (buttonId: string, callback: (bcd: ButtonCallbackData) -> nil) -> nil,
    --- Drops a button callback from the framework.
    dropButtonCallback: (buttonId: string) -> nil,
    --- Gets a button callback from the framework.
    getButtonCallback: (buttonId: string) -> ((bcd: ButtonCallbackData) -> nil)?,
    --- The data that is being used by the framework.
    --- Base framework data. Will only be set on first dispatch
    data: BaseFrameworkData?,
}

export type SettingsData = {
    userinfomanager: userinfomanager.UserInfoManager,
    ctx: primitives.TemplateContext, 
}

export type FrameworkSetting = {
    schema: settings.Setting?,
    dynSchema: (ctx: primitives.TemplateContext) -> settings.Setting,
    execute: (event: events.SettingExecuteEvent, data: SettingsData) -> any
}


--- BaseFramework provides a simple abstraction around command registration.
export type BaseFramework = {
    --- What command suffix is being used for commands.
    ---
    --- This is useful for prod/dev environments
    suffix: string?,
    --- Registers a command in the framework.
    registerCommand: (command: Command) -> (),
    --- Registers a setting into the framework.
    registerSetting: (name: string, setting: FrameworkSetting) -> (),
    --- Returns the compiled commands of the framework.
    ---
    --- This moves subcommands and subcommand groups to the base command (creating the base command if needed)
    commands: () -> {discordRestTypes.CreateGuildApplicationCommandRequest},
    --- Returns the closest command given the name as a split string (by space)
    getcommand: (name: {string}) -> Command?,
    --- Returns a list of all commands in the framework.
    getcommands: () -> {[string]: Command},
    --- Returns a list of all settings in the framework.
    getsettings: () -> {[string]: FrameworkSetting},
}

--- A builder for creating commands in the framework.
export type CommandBuilder = {
    --- Set the schema of the command
    setSchema: (schema: discordRestTypes.CreateGuildApplicationCommandRequest) -> CommandBuilder,
    --- Same as setSchema but provides the base schema for you
    addSchema: (name: string, fn: (commandBuilder.Interaction) -> commandBuilder.JSON) -> CommandBuilder,
    --- Set the run function of the command
    setRun: (run: (data: RunData) -> ()) -> CommandBuilder,
    --- Set the autocompleter function of the command
    setAutocompleter: (autocompleter: ((data: AutocompleteRunData) -> {discord.ApplicationCommandOptionChoiceObject})?) -> CommandBuilder,
    --- Set the key expirations of the command
    setKeyExpirations: (keyexpiries: {[string]: (data: KeyExpiryData) -> nil}?) -> CommandBuilder,
    --- Build the command
    build: () -> Command,
}

export type Command = {
    --- Discord command definition.
    command: discordRestTypes.CreateGuildApplicationCommandRequest,
    --- A register command to return the command definition at runtime.
    register: (() -> discordRestTypes.CreateGuildApplicationCommandRequest)?,
    --- The function that runs when the command is executed.
    run: (data: RunData) -> (),
    --- The function that runs when the command is autocompleted.
    autocompleter: ((data: AutocompleteRunData) -> {discord.ApplicationCommandOptionChoiceObject})?,
    --- The function that runs when a key expires.
    keyexpiries: {
        [string]: (data: KeyExpiryData) -> nil
    }?,
}

export type KeyExpiryData = {
    ctx: primitives.TemplateContext, 
    event: primitives.Event,
    data: events.KeyExpiryEvent,
    stingManager: stingmanager.StingManager,
    punishmentmanager: punishmentmanager.PunishmentManager,
    builtinSettingsManager: builtinSettingsManager.BuiltinSettingsManager,
    userinfomanager: userinfomanager.UserInfoManager
}

export type ButtonCallbackData = {
    ctx: primitives.TemplateContext, 
    interaction: discord.InteractionObject, 
    removeCallback: () -> nil,
    event: primitives.Event,
}

export type RunData = {
    ctx: primitives.TemplateContext, 
    event: primitives.Event, 
    interaction: discord.InteractionObject,
    stingManager: stingmanager.StingManager,
    punishmentmanager: punishmentmanager.PunishmentManager,
    builtinSettingsManager: builtinSettingsManager.BuiltinSettingsManager, 
    userinfomanager: userinfomanager.UserInfoManager,
    command: appcommands.ParsedApplicationCommand,
    attachButtonCallback: ((buttonId: string, callback: (bcd: ButtonCallbackData) -> nil) -> nil),
    dropButtonCallback: ((buttonId: string) -> nil),
    sethasEdited: (to: boolean) -> nil,
}

export type AutocompleteRunData = {
    ctx: primitives.TemplateContext, 
    event: primitives.Event, 
    interaction: discord.InteractionObject,
    stingManager: stingmanager.StingManager,
    builtinSettingsManager: builtinSettingsManager.BuiltinSettingsManager, 
    command: appcommands.ParsedApplicationCommand,
}

return {}