local coretypes = require"./coretypes"
local discordRestTypes = require"@discord-types/restTypes"
local discord = require"@discord-types/apiTypes"
local commandBuilder = require "@discord-types/builders/interaction/interaction"

local function CommandBuilder(): coretypes.CommandBuilder
    local self = {}

    local function setSchema(schema: discordRestTypes.CreateGuildApplicationCommandRequest): coretypes.CommandBuilder
        self.schema = schema :: discordRestTypes.CreateGuildApplicationCommandRequest?
        return self :: coretypes.CommandBuilder
    end

    local function addSchema(name: string, fn: (commandBuilder.Interaction) -> commandBuilder.JSON): coretypes.CommandBuilder
        local baseSchema = commandBuilder.new({ name = name })
            :addIntegrationType("GuildInstall")
            :setType("ChatInput")
            :addContext("Guild")

        self.schema = fn(baseSchema) :: discordRestTypes.CreateGuildApplicationCommandRequest?
        return self :: coretypes.CommandBuilder
    end

    local function setRun(run: (data: coretypes.RunData) -> ()): coretypes.CommandBuilder
        self.run = run :: ((coretypes.RunData) -> ())?
        return self :: coretypes.CommandBuilder
    end

    local function setAutocompleter(autocompleter: ((data: coretypes.AutocompleteRunData) -> {discord.ApplicationCommandOptionChoiceObject})?): coretypes.CommandBuilder
        self.autocompleter = autocompleter :: ((coretypes.AutocompleteRunData) -> {discord.ApplicationCommandOptionChoiceObject})?
        return self :: coretypes.CommandBuilder
    end

    local function setKeyExpirations(keyexpiries: {[string]: (data: coretypes.KeyExpiryData) -> nil}?): coretypes.CommandBuilder
        self.keyexpiries = keyexpiries :: {[string]: (data: coretypes.KeyExpiryData) -> nil}?
        return self :: coretypes.CommandBuilder
    end

    local function build(): coretypes.Command
        assert(self.schema, "Command schema is not set")
        assert(self.run, "Command run function is not set")

        return {
            name = self.schema.name,
            command = self.schema,
            run = self.run,
            autocompleter = self.autocompleter,
            keyexpiries = self.keyexpiries,
        } :: coretypes.Command
    end

    self.schema = nil :: discordRestTypes.CreateGuildApplicationCommandRequest?
    self.run = nil :: ((coretypes.RunData) -> ())?
    self.autocompleter = nil :: ((coretypes.AutocompleteRunData) -> {discord.ApplicationCommandOptionChoiceObject})?
    self.keyexpiries = nil ::  {[string]: (data: coretypes.KeyExpiryData) -> nil}?

    self.setSchema = setSchema
    self.addSchema = addSchema
    self.setRun = setRun
    self.setAutocompleter = setAutocompleter
    self.setKeyExpirations = setKeyExpirations
    self.build = build

    return self
end

return CommandBuilder