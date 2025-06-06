--!nocheck
-- Does not check under new type solver yet

local apiTypes = require("../../apiTypes")
local triggerMetadata = require("./trigger/metadata")
local action = require("./action/action")
local prelude = require("../../prelude")

local AutomoderationRule = {}

AutomoderationRule.Prototype = {}
AutomoderationRule.Interface = {}
--[[
	Sets the name of the automoderation rule.
]]
function AutomoderationRule.Prototype.setName(self: AutomoderationRule, name: string): AutomoderationRule
	self.name = name

	return self
end

--[[
	Sets the event type for the automoderation rule.
]]
function AutomoderationRule.Prototype.setEventType(
	self: AutomoderationRule,
	eventType: apiTypes.AutomoderationRuleEventType
): AutomoderationRule
	self.eventType = eventType

	return self
end

--[[
	Sets the trigger type for the automoderation rule.
]]
function AutomoderationRule.Prototype.setTriggerType(
	self: AutomoderationRule,
	triggerType: apiTypes.AutomoderationRuleTriggerType
): AutomoderationRule
	self.triggerType = triggerType

	return self
end

--[[
	Sets the trigger metadata for the automoderation rule.
]]
function AutomoderationRule.Prototype.setTriggerMetadata(
	self: AutomoderationRule,
	triggerMetadata: triggerMetadata.JSON
): AutomoderationRule
	self.triggerMetadata = triggerMetadata

	return self
end

--[[
	Sets the actions for the automoderation rule.
]]
function AutomoderationRule.Prototype.setActions(self: AutomoderationRule, actions: { action.JSON }): AutomoderationRule
	self.actions = actions

	return self
end

--[[
	Sets whether the automoderation rule is enabled.
]]
function AutomoderationRule.Prototype.setEnabled(self: AutomoderationRule, enabled: boolean): AutomoderationRule
	self.enabled = enabled

	return self
end

--[[
	Sets the exempt roles for the automoderation rule.
]]
function AutomoderationRule.Prototype.setExemptRoles(
	self: AutomoderationRule,
	exemptRoles: { apiTypes.Snowflake }
): AutomoderationRule
	self.exemptRoles = exemptRoles

	return self
end

--[[
	Sets the exempt channels for the automoderation rule.
]]
function AutomoderationRule.Prototype.setExemptChannels(
	self: AutomoderationRule,
	exemptChannels: { apiTypes.Snowflake }
): AutomoderationRule
	self.exemptChannels = exemptChannels

	return self
end

--[[
	Builds the automoderation rule object.
]]
function AutomoderationRule.Prototype.build(self: AutomoderationRule): JSON
	return {
		name = self.name,
		event_type = prelude.guild.EventTypes[self.eventType],
		trigger_type = prelude.guild.TriggerTypes[self.triggerType],
		trigger_metadata = self.triggerMetadata,
		actions = self.actions,
		enabled = self.enabled,
		exempt_roles = self.exemptRoles,
		exempt_channels = self.exemptChannels,
	}
end

--[[
	Responsible for creating a new AutomoderationRule.

	```lua
	
	```
]]
function AutomoderationRule.Interface.new(resource: {
	name: string?,
	eventType: apiTypes.AutomoderationRuleEventType?,
	triggerType: apiTypes.AutomoderationRuleTriggerType?,
	triggerMetadata: triggerMetadata.JSON?,
	actions: { action.JSON }?,
	enabled: boolean?,
	exemptRoles: { apiTypes.Snowflake }?,
	exemptChannels: { apiTypes.Snowflake }?,
}?): AutomoderationRule
	local self = setmetatable({} :: AutomoderationRule, {
		__index = AutomoderationRule.Prototype,
	})

	if resource then
		if resource.name then
			self:setName(resource.name)
		end

		if resource.eventType then
			self:setEventType(resource.eventType)
		end

		if resource.triggerType then
			self:setTriggerType(resource.triggerType)
		end

		if resource.triggerMetadata then
			self:setTriggerMetadata(resource.triggerMetadata)
		end

		if resource.actions then
			self:setActions(resource.actions)
		end

		if resource.enabled then
			self:setEnabled(resource.enabled)
		end

		if resource.exemptRoles then
			self:setExemptRoles(resource.exemptRoles)
		end

		if resource.exemptChannels then
			self:setExemptChannels(resource.exemptChannels)
		end
	end

	return self
end

export type AutomoderationRule = typeof(AutomoderationRule.Prototype) & {
	name: string,
	eventType: apiTypes.AutomoderationRuleEventType,
	triggerType: apiTypes.AutomoderationRuleTriggerType,
	triggerMetadata: triggerMetadata.JSON?,
	actions: { action.JSON },
	enabled: boolean?,
	exemptRoles: { apiTypes.Snowflake }?,
	exemptChannels: { apiTypes.Snowflake }?,
}

export type JSON = typeof(AutomoderationRule.Prototype.build(nil :: any))

return AutomoderationRule.Interface