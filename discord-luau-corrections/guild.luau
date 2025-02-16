local reflect = require("@discord-types/utils/table/reflect")

local VerificationLevel = table.freeze(reflect({
	None = 0,
	Low = 1,
	Medium = 2,
	High = 3,
	VeryHigh = 4,
}))

local DefaultMessageNotification = table.freeze(reflect({
	AllMessages = 0,
	OnlyMentions = 1,
}))

local ExplicitContentFilterLevel = table.freeze(reflect({
	Disabled = 0,
	MembersWithoutRoles = 1,
	AllMembers = 2,
}))

local NSFWLevel = table.freeze(reflect({
	Default = 0,
	Explicit = 1,
	Safe = 2,
	AgeRestricted = 3,
}))

local PremiumTier = table.freeze(reflect({
	None = 0,
	Tier1 = 1,
	Tier2 = 2,
	Tier3 = 3,
}))

local MFALevel = table.freeze(reflect({
	None = 0,
	Elevated = 1,
}))

local InviteType = table.freeze(reflect({
	Guild = 0,
	GroupDM = 1,
	Friend = 2,
}))

local InviteTargetType = table.freeze(reflect({
	Stream = 1,
	EmbeddedApplication = 2,
}))

local ScheduledEventPrivacyLevel = table.freeze(reflect({
	GuildOnly = 2,
}))

local SchedledEventEntityType = table.freeze(reflect({
	StageInstance = 1,
	Voice = 2,
	External = 3,
}))

local SchedledEventStatus = table.freeze(reflect({
	Scheduled = 1,
	Active = 2,
	Completed = 3,
	Cancelled = 4,
}))

local IntegrationType = table.freeze(reflect({
	Twitch = "twitch",
	YouTube = "youtube",
	Discord = "discord",
	GuildSubscription = "guild_subscription",
}))

local IntegrationExpireBehaviour = table.freeze(reflect({
	RemoveRole = 0,
	Kick = 1,
}))

local OnboardingPromptType = table.freeze(reflect({
	MultipleChoice = "MULTIPLE_CHOICE",
	Dropdown = "DROPDOWN",
}))

local OnboardingMode = table.freeze(reflect({
	Default = "ONBOARDING_DEFAULT",
	Advanced = "ONBOARDING_ADVANCED",
}))

local OverwriteType = table.freeze(reflect({
	Role = 0,
	Member = 1,
}))

export type VerificationLevel = "None" | "Low" | "Medium" | "High" | "VeryHigh"
export type DefaultMessageNotification = "AllMessages" | "OnlyMentions"
export type ExplicitContentFilterLevel = "Disabled" | "MembersWithoutRoles" | "AllMembers"
export type NSFWLevel = "Default" | "Explicit" | "Safe" | "AgeRestricted"
export type PremiumTier = "None" | "Tier1" | "Tier2" | "Tier3"
export type MFALevel = "None" | "Elevated"
export type InviteType = "Guild" | "GroupDM" | "Friend"
export type InviteTargetType = "Stream" | "EmbeddedApplication"
export type ScheduledEventPrivacyLevel = "GuildOnly"
export type SchedledEventEntityType = "StageInstance" | "Voice" | "External"
export type SchedledEventStatus = "Scheduled" | "Active" | "Completed" | "Canceled"
export type IntegrationType = "Twitch" | "YouTube" | "Discord" | "GuildSubscription"
export type IntegrationExpireBehaviour = "RemoveRole" | "Kick"
export type OnboardingPromptType = "MultipleChoice" | "Dropdown"
export type OnboardingMode = "Default" | "Advanced"
export type OverwriteType = "Role" | "Member"

return {
	VerificationLevel = VerificationLevel,
	DefaultMessageNotification = DefaultMessageNotification,
	ExplicitContentFilterLevel = ExplicitContentFilterLevel,
	NSFWLevel = NSFWLevel,
	PremiumTier = PremiumTier,
	MFALevel = MFALevel,
	InviteType = InviteType,
	InviteTargetType = InviteTargetType,
	ScheduledEventPrivacyLevel = ScheduledEventPrivacyLevel,
	SchedledEventEntityType = SchedledEventEntityType,
	SchedledEventStatus = SchedledEventStatus,
	IntegrationType = IntegrationType,
	IntegrationExpireBehaviour = IntegrationExpireBehaviour,
	OnboardingPromptType = OnboardingPromptType,
	OnboardingMode = OnboardingMode,
	OverwriteType = OverwriteType,
}