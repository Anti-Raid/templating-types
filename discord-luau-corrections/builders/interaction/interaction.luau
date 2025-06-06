--!nocheck
-- -- Does not type under new type solver yet

--[[
	Implementation of a discord Interaction object as a luau builder.	

	https://discord.com/developers/docs/interactions/application-commands#edit-global-application-command-json-params
]]

local interop = require("@antiraid/interop")
local apiTypes = require("@discord-types/apiTypes")
local interactionTypes = require("@discord-types/interaction")
local applicationTypes = require("@discord-types/application")

local interactionOption = require("@discord-types/builders/interaction/option")

local validateKebabCase = require("@discord-types/utils/validateKebabCase")

local Interaction = {}

Interaction.Prototype = {}
Interaction.Interface = {}

--[[
	Name of command, 1-32 characters
]]
function Interaction.Prototype.setName(self: Interaction, name: string): Interaction
	assert(#name <= 32, "name must be less than 32 characters")
	assert(#name >= 1, "name must be at least 1 character")

	self.name = name

	return self
end

--[[
	Set the Type of command
]]
function Interaction.Prototype.setType(
	self: Interaction,
	commandType: interactionTypes.ApplicationCommandType
): Interaction
	self.type = commandType

	return self
end

--[[
	Localization dictionary for the name field. Values follow the same restrictions as name
]]
function Interaction.Prototype.setNameLocalization(
	self: Interaction,
	localization: apiTypes.LanguageLocales,
	name: string
): Interaction
	assert(#name <= 32, "name must be less than 32 characters")
	assert(#name >= 1, "name must be at least 1 character")

	validateKebabCase(name)

	self.nameLocalizations[localization] = name

	return self
end

--[[
	1-100 character description
]]
function Interaction.Prototype.setDescription(self: Interaction, description: string): Interaction
	assert(#description <= 100, "description must be less than 100 characters")
	assert(#description >= 1, "description must be at least 1 character")

	self.description = description

	return self
end

--[[
	Localization dictionary for the description field. Values follow the same restrictions as description
]]
function Interaction.Prototype.setDescriptionLocalization(
	self: Interaction,
	localization: apiTypes.LanguageLocales,
	description: string
): Interaction
	assert(#description <= 100, "description must be less than 100 characters")
	assert(#description >= 1, "description must be at least 1 character")

	self.descriptionLocalizations[localization] = description

	return self
end

function Interaction.Prototype.option(self: Interaction, fn: (interactionOption.Option) -> interactionOption.JSON): Interaction
	table.insert(self.options, fn(interactionOption.new()))

	return self
end

--[[
	the parameters for the command
]]
function Interaction.Prototype.addOption(self: Interaction, option: interactionOption.JSON): Interaction
	table.insert(self.options, option)

	return self
end

--[[
	Set of permissions represented as a bit set, recommended that you use the permission builder.
]]
function Interaction.Prototype.setDefaultMemberPermissions(self: Interaction, permissions: string): Interaction
	self.defaultMemberPermissions = permissions

	return self
end

--[[
	Installation context(s) where the command is available
]]
function Interaction.Prototype.addIntegrationType(
	self: Interaction,
	type: applicationTypes.IntegrationTypesConfig
): Interaction
	table.insert(self.integrationTypes, type)

	return self
end

--[[
	Interaction context(s) where the command can be used
]]
function Interaction.Prototype.addContext(
	self: Interaction,
	context: interactionTypes.InteractionContextType
): Interaction
	table.insert(self.contexts, context)

	return self
end

--[[
	Indicates whether the command is age-restricted
]]
function Interaction.Prototype.setNsfw(self: Interaction, isNsfw: boolean): Interaction
	self.nsfw = isNsfw

	return self
end

--[[
	Responsible for buillding the default reaction object that the Discord API can understand.
]]
function Interaction.Prototype.build(self: Interaction): JSON
	assert(self.name, "name must be set")
	assert(#self.integrationTypes > 0, `must have one or more integration types set`)
	assert(#self.contexts > 0, `must have one or more contexts set`)

	local contexts: { number } = {}
	local integrationTypeArray: { number } = {}

	for _, context in self.contexts do
		table.insert(contexts, interactionTypes.InteractionContextType[context])
	end

	for _, interactionType in self.integrationTypes do
		table.insert(integrationTypeArray, applicationTypes.IntegrationTypesConfig[interactionType])
	end

	return {
		id = nil :: any,
		application_id = nil :: any,
		version = nil :: any,
		guild_id = nil :: any,
		name = self.name,
		name_localizations = self.nameLocalizations,
		description = self.description,
		description_localizations = self.descriptionLocalizations,
		options = if #self.options == 0 then setmetatable({}, interop.array_metatable) else self.options,
		default_member_permissions = self.defaultMemberPermissions,
		dm_permission = nil :: any,
		default_permission = nil :: any,
		integration_types = if #integrationTypeArray == 0 then setmetatable({}, interop.array_metatable) else integrationTypeArray,
		contexts = if #contexts == 0 then setmetatable({}, interop.array_metatable) else contexts,
		type = interactionTypes.ApplicationCommandType[self.type] or nil,
		nsfw = self.nsfw or false,
	}
end

--[[
	Constructor for the Discord Default Reaction Builder.

	```lua
	local defaultReaction = Interaction.new("000000000000000000", "secret-emoji"):build()
	```
]]
function Interaction.Interface.new(resource: {
	name: string?,
	nameLocalizations: { [apiTypes.LanguageLocales]: string }?,
	description: string?,
	descriptionLocalizations: { [apiTypes.LanguageLocales]: string }?,
	options: { interactionOption.JSON }?,
	defaultMemberPermissions: string?,
	integrationTypes: { applicationTypes.IntegrationTypesConfig }?,
	contexts: { interactionTypes.InteractionContextType }?,
	nsfw: boolean?,
}?): Interaction
	local self = setmetatable(
		{
			nameLocalizations = {},
			descriptionLocalizations = {},
			options = {},
			integrationTypes = {},
			contexts = {},
		} :: Interaction,
		{ __index = Interaction.Prototype }
	)

	if resource and resource.name then
		self:setName(resource.name)
	end

	if resource and resource.nameLocalizations then
		for localization: apiTypes.LanguageLocales, name in resource.nameLocalizations do
			self:setNameLocalization(localization, name)
		end
	end

	if resource and resource.description then
		self:setDescription(resource.description)
	end

	if resource and resource.descriptionLocalizations then
		for localization: apiTypes.LanguageLocales, name in resource.descriptionLocalizations do
			self:setDescriptionLocalization(localization, name)
		end
	end

	if resource and resource.options then
		for _, option in resource.options do
			self:addOption(option)
		end
	end

	if resource and resource.defaultMemberPermissions then
		self:setDefaultMemberPermissions(resource.defaultMemberPermissions)
	end

	if resource and resource.integrationTypes then
		for _, type: applicationTypes.IntegrationTypesConfig in resource.integrationTypes do
			self:addIntegrationType(type)
		end
	end

	if resource and resource.contexts then
		for _, context: interactionTypes.InteractionContextType in resource.contexts do
			self:addContext(context)
		end
	end

	if resource and resource.nsfw then
		self:setNsfw(resource.nsfw)
	end

	return self
end

export type Interaction = typeof(Interaction.Prototype) & {
	name: string,
	nameLocalizations: { [apiTypes.LanguageLocales]: string },
	description: string,
	descriptionLocalizations: { [apiTypes.LanguageLocales]: string },
	options: { interactionOption.JSON },
	defaultMemberPermissions: string?,
	integrationTypes: { applicationTypes.IntegrationTypesConfig },
	contexts: { interactionTypes.InteractionContextType },
	type: interactionTypes.ApplicationCommandType,
	nsfw: boolean?,
}

export type JSON = typeof(Interaction.Prototype.build(nil :: any))

return Interaction.Interface
