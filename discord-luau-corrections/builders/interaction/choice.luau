--!nocheck
-- -- Does not type under new type solver yet

--[[
	Implementation of the Application Command Option Choice Structure in Luau.

	https://discord.com/developers/docs/interactions/application-commands#application-command-object-application-command-option-choice-structure
]]

local validateKebabCase = require("@discord-types/utils/validateKebabCase")

local apiTypes = require("@discord-types/apiTypes")

local Choice = {}

Choice.Prototype = {}
Choice.Interface = {}

--[[
	Responsible for setting the name of the choice. Name must be kebab case, with 1-100 characters.
]]
function Choice.Prototype.setName(self: Choice, name: string): Choice
	assert(#name <= 100, "name must be less than 100 characters")
	assert(#name >= 1, "name must be at least 1 character")

	validateKebabCase(name)

	self.name = name

	return self
end

--[[
	Adding localization to the Name of the choice, enabling developers to create milti-language support.
]]
function Choice.Prototype.setNameLocalization(
	self: Choice,
	localization: apiTypes.LanguageLocales,
	name: string
): Choice
	assert(#name <= 100, "name must be less than 100 characters")
	assert(#name >= 1, "name must be at least 1 character")

	validateKebabCase(name)

	self.nameLocalizations[localization] = name

	return self
end

--[[
	Set the value of the choice, value can only be either a string or number.
]]
function Choice.Prototype.setValue(self: Choice, value: string | number): Choice
	local typeofValue = type(value)

	assert(typeofValue == "string" or typeofValue == "number", "value must be a string or number")

	if typeofValue == "string" then
		assert(#(value :: string) <= 100, "value must be less than 100 characters")
	end

	self.value = value

	return self
end

--[[
	Responsible for buillding the default reaction object that the Discord API can understand.
]]
function Choice.Prototype.build(self: Choice): JSON
	assert(self.name, `Missing name for choice: {self.name}`)
	assert(self.value, `Missing value for choice: {self.name}`)

	return {
		name = self.name,
		name_localizations = self.nameLocalizations,
		value = self.value,
	}
end

--[[
	Constructor for the Discord Default Reaction Builder.

	```lua
	local defaultReaction = Choice.new({
		name = "example-choice",
		value = "example-value",
	}):build()
	```
]]
function Choice.Interface.new(resource: {
	name: string?,
	nameLocalizations: { [apiTypes.LanguageLocales]: string }?,
	value: string | number?,
}?): Choice
	local self = setmetatable(
		{
			nameLocalizations = {},
		} :: Choice,
		{ __index = Choice.Prototype }
	)

	if resource and resource.name then
		self:setName(resource.name)
	end

	if resource and resource.nameLocalizations then
		for localization: apiTypes.LanguageLocales, value in resource.nameLocalizations do
			self:setNameLocalization(localization, value)
		end
	end

	if resource and resource.value then
		self:setValue(resource.value)
	end

	return self
end

export type Choice = typeof(Choice.Prototype) & {
	name: string,
	nameLocalizations: { [apiTypes.LanguageLocales]: string },
	value: string | number,
}

export type JSON = typeof(Choice.Prototype.build(nil :: any))

return Choice.Interface
