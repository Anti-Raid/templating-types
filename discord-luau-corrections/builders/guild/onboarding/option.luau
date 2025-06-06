--!nocheck
-- -- Does not type under new type solver yet

--[[
	Implementation of discords Option object as a Luau builder.	

	https://discord.com/developers/docs/resources/guild#guild-onboarding-object-prompt-option-structure
]]

local Option = {}

Option.Prototype = {}
Option.Interface = {}

--[[
	Add a Channel to this option
]]
function Option.Prototype.addChannelId(self: Option, channelId: string): Option
	table.insert(self.channelIds, channelId)

	return self
end

--[[
	Add a Role to this option
]]
function Option.Prototype.addRoleId(self: Option, roleId: string): Option
	table.insert(self.roleIds, roleId)

	return self
end

--[[
	Sets the emoji of this option.
]]
function Option.Prototype.setEmoji(self: Option, emojiId: string, emojiName: string, isAnimated: boolean?): Option
	self.emojiId = emojiId
	self.emojiName = emojiName
	self.emojiAnimated = isAnimated

	return self
end

--[[
	Sets the title of this option.
]]
function Option.Prototype.setTitle(self: Option, title: string): Option
	self.title = title

	return self
end

--[[
	Sets the description of this option.
]]
function Option.Prototype.setDescription(self: Option, description: string): Option
	self.description = description

	return self
end

--[[
	Responsible for building the OptionObject JSON that can be parsed by the Discord API.
]]
function Option.Prototype.build(self: Option): JSON
	return {
		channel_ids = self.channelIds,
		role_ids = self.roleIds,
		emoji_id = self.emojiId,
		emoji_name = self.emojiName,
		emoji_animated = self.emojiAnimated,
		title = self.title,
		description = self.description,

		emoji = nil,
		id = nil,
	}
end

--[[
	Responsible for creating a new Option.

	```lua
	
	```
]]
function Option.Interface.new(resource: {
	channelIds: { string }?,
	roleIds: { string }?,
	emojiId: string?,
	emojiName: string?,
	emojiAnimated: boolean?,
	title: string?,
	description: string?,
}?): Option
	local self = setmetatable(
		{
			channelIds = {},
			roleIds = {},
		} :: Option,
		{
			__index = Option.Prototype,
		}
	)

	if resource then
		if resource.channelIds then
			for _, channelId in resource.channelIds do
				self:addChannelId(channelId)
			end
		end

		if resource.roleIds then
			for _, channelId in resource.roleIds do
				self:addRoleId(channelId)
			end
		end

		if resource.emojiId then
			assert(resource.emojiName, `Expected 'emojiName' with 'emojiId'`)

			self:setEmoji(resource.emojiId, resource.emojiName, resource.emojiAnimated)
		end

		if resource.title then
			self:setTitle(resource.title)
		end

		if resource.description then
			self:setDescription(resource.description)
		end
	end

	return self
end

export type Option = typeof(Option.Prototype) & {
	channelIds: { string },
	roleIds: { string },
	emojiId: string?,
	emojiName: string?,
	emojiAnimated: boolean?,
	title: string,
	description: string?,
}

export type JSON = typeof(Option.Prototype.build(nil :: any))

return Option.Interface
