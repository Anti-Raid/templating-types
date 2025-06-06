--!nocheck
-- -- Does not type under new type solver yet

--[[
	Implementation of discords Invite object as a Luau builder.	

	https://discord.com/developers/docs/resources/channel#create-channel-invite-json-params
]]

local guildTypes = require("@discord-types/guild")

local Invite = {}

Invite.Prototype = {}
Invite.Interface = {}

--[[
	Sets the duration in seconds after which the invite expires.
	Age must be between 0 and 604800 seconds.
]]
function Invite.Prototype.setMaxAge(self: Invite, age: number): Invite
	assert(age >= 0, "Max age must be greater than or equal to 0")
	assert(age <= 604800, "Max age must be less than or equal to 604800")

	self.maxAge = age

	return self
end

--[[
	Sets the maximum number of times this invite can be used.
	Uses must be between 0 and 100.
]]
function Invite.Prototype.setMaxUses(self: Invite, uses: number): Invite
	assert(uses >= 0, "Max uses must be greater than or equal to 0")
	assert(uses <= 100, "Max uses must be less than or equal to 604800")

	self.maxUses = uses

	return self
end

--[[
	Sets whether the invite grants temporary membership.
	Temporary members are removed when they disconnect unless granted a role.
]]
function Invite.Prototype.setTemporary(self: Invite, isTemporary: boolean): Invite
	self.temporary = isTemporary

	return self
end

--[[
	Sets whether this invite should be unique.
	If true, don't try to reuse a similar invite.
]]
function Invite.Prototype.setIsUnique(self: Invite, isUnique: boolean): Invite
	self.unique = isUnique

	return self
end

--[[
	Sets the type of target for this invite.
	Used for stream and embedded application invites.
]]
function Invite.Prototype.setTargetType(self: Invite, targetType: guildTypes.InviteTargetType): Invite
	assert(guildTypes.InviteTargetType[self.targetType], "Invalid target type")

	self.targetType = targetType

	return self
end

--[[
	Sets the target user ID for this invite.
	Used to specify which user's stream to display for stream invites.
]]
function Invite.Prototype.setTargetUser(self: Invite, userId: string): Invite
	self.targetUserId = userId

	return self
end

--[[
	Sets the target application ID for this invite.
	Used to specify which embedded application to open.
]]
function Invite.Prototype.setTargetApplication(self: Invite, applicationId: string): Invite
	self.targetApplicationId = applicationId

	return self
end

--[[
	Responsible for buillding the invite object that the Discord API can understand.
]]
function Invite.Prototype.build(self: Invite): JSON
	return {
		max_age = self.maxAge,
		max_uses = self.maxUses,
		temporary = self.temporary,
		unique = self.unique,
		target_type = guildTypes.InviteTargetType[self.targetType],
		target_user_id = self.targetUserId,
		target_application_id = self.targetApplicationId,
	}
end

--[[
	Responsible for creating a new Invite.

	```lua
	
	```
]]
function Invite.Interface.new(resource: {
	maxAge: number?,
	maxUses: number?,
	temporary: boolean?,
	unique: boolean?,
	targetType: guildTypes.InviteTargetType?,
	targetUserId: string?,
	targetApplicationId: string?,
}?): Invite
	local self = setmetatable({} :: Invite, {
		__index = Invite.Prototype,
	})

	if resource then
		if resource.maxAge then
			self:setMaxAge(resource.maxAge)
		end

		if resource.maxUses then
			self:setMaxUses(resource.maxUses)
		end

		if resource.temporary then
			self:setTemporary(resource.temporary)
		end

		if resource.unique then
			self:setIsUnique(resource.unique)
		end

		if resource.targetType then
			self:setTargetType(resource.targetType)
		end

		if resource.targetUserId then
			self:setTargetUser(resource.targetUserId)
		end

		if resource.targetApplicationId then
			self:setTargetApplication(resource.targetApplicationId)
		end
	end

	return self
end

export type Invite = typeof(Invite.Prototype) & {
	maxAge: number?,
	maxUses: number?,
	temporary: boolean?,
	unique: boolean?,
	targetType: guildTypes.InviteTargetType?,
	targetUserId: string?,
	targetApplicationId: string?,
}

export type JSON = typeof(Invite.Prototype.build(nil :: any))

return Invite.Interface
