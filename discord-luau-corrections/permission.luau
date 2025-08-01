local reflect = require("@discord-types/utils/table/reflect")

local typesext = require("@antiraid/typesext")
local bit = typesext.bitu64
local fromBf = require("@discord-types/utils/frombf")
local set = require("@antiraid-ext/set")

local PermissionSet = {
	CreateInstantInvite = bit.lshift(1, 0),
	KickMembers = bit.lshift(1, 1),
	BanMembers = bit.lshift(1, 2),
	Administrator = bit.lshift(1, 3),
	ManageChannels = bit.lshift(1, 4),
	ManageGuild = bit.lshift(1, 5),
	AddReactions = bit.lshift(1, 6),
	ViewAuditLog = bit.lshift(1, 7),
	PrioritySpeaker = bit.lshift(1, 8),
	Stream = bit.lshift(1, 9),
	ViewChannel = bit.lshift(1, 10),
	SendMessages = bit.lshift(1, 11),
	SendTTSMessages = bit.lshift(1, 12),
	ManageMessages = bit.lshift(1, 13),
	EmbedLinks = bit.lshift(1, 14),
	AttachFiles = bit.lshift(1, 15),
	ReadMessageHistory = bit.lshift(1, 16),
	MentionEveryone = bit.lshift(1, 17),
	UseExternalEmojis = bit.lshift(1, 18),
	ViewGuildInsights = bit.lshift(1, 19),
	Connect = bit.lshift(1, 20),
	Speak = bit.lshift(1, 21),
	MuteMembers = bit.lshift(1, 22),
	DeafenMembers = bit.lshift(1, 23),
	MoveMembers = bit.lshift(1, 24),
	UseVAD = bit.lshift(1, 25),
	ChangeNickname = bit.lshift(1, 26),
	ManageNicknames = bit.lshift(1, 27),
	ManageRoles = bit.lshift(1, 28),
	ManageWebhooks = bit.lshift(1, 29),
	ManageGuildExpressions = bit.lshift(1, 30),
	UseApplicationCommands = bit.lshift(1, 31),
	RequestToSpeak = bit.lshift(1, 32),
	ManageEvents = bit.lshift(1, 33),
	ManageThreads = bit.lshift(1, 34),
	CreatePublicThreads = bit.lshift(1, 35),
	CreatePrivateThreads = bit.lshift(1, 36),
	UseExternalStickers = bit.lshift(1, 37),
	SendMessagesInThreads = bit.lshift(1, 38),
	UseEmbeddedActivities = bit.lshift(1, 39),
	ModerateMembers = bit.lshift(1, 40),
	ViewCreatorMonetizationAnalytics = bit.lshift(1, 41),
	UseSoundboard = bit.lshift(1, 42),
	UseExternalSounds = bit.lshift(1, 45),
	SendVoiceMessages = bit.lshift(1, 46),
	SendPolls = bit.lshift(1, 49),
	UseExternalApps = bit.lshift(1, 50),
}

local Permissions = table.freeze(reflect(PermissionSet :: {[string]: typesext.U64Convertibles}))

local PermissionsAll = typesext.U64("0")
for _, perm in Permissions do
	PermissionsAll = bit.bor(PermissionsAll, perm :: typesext.U64Convertibles)
end

export type Permissions =
	"CreateInstantInvite"
	| "KickMembers"
	| "BanMembers"
	| "Administrator"
	| "ManageChannels"
	| "ManageGuild"
	| "AddReactions"
	| "ViewAuditLog"
	| "PrioritySpeaker"
	| "Stream"
	| "ViewChannel"
	| "SendMessages"
	| "SendTTSMessages"
	| "ManageMessages"
	| "EmbedLinks"
	| "AttachFiles"
	| "ReadMessageHistory"
	| "MentionEveryone"
	| "UseExternalEmojis"
	| "ViewGuildInsights"
	| "Connect"
	| "Speak"
	| "MuteMembers"
	| "DeafenMembers"
	| "MoveMembers"
	| "UseVad"
	| "ChangeNickname"
	| "ManageNicknames"
	| "ManageRoles"
	| "ManageWebhooks"
	| "ManageGuildExpressions"
	| "UseApplicationCommands"
	| "RequestToSpeak"
	| "ManageEvents"
	| "ManageThreads"
	| "CreatePublicThreads"
	| "CreatePrivateThreads"
	| "UseExternalStickers"
	| "SendMessagesInThreads"
	| "UseEmbeddedActivities"
	| "ModerateMembers"
	| "ViewCreatorMonetizationAnalytics"
	| "UseSoundboard"
	| "CreateGuildExpressions"
	| "CreateEvents"
	| "UseExternalSounds"
	| "SendVoiceMessages"
	| "SendPolls"
	| "UseExternalApps"

--- Given a bitflag of permissions, returns a table of permission strings
local function fromBitflag(bitflag: typesext.U64Convertibles): {Permissions} 
	return fromBf.fromBitflag(bitflag, Permissions :: any) :: any
end

--- Given a bitflag of permissions, returns a set of permission strings
local function fromBitflagToSet(bitflag: typesext.U64Convertibles): set.Set<Permissions>
	return fromBf.fromBitflagToSet(bitflag, Permissions :: any) :: any
end

--- Converts a table of permission strings to a bitflag
local function toBitflag(permissions: {Permissions}): typesext.U64Convertibles
	local bitflag = 0
	for _, permission in permissions do
		if not Permissions[permission] then
			error("Invalid permission: " .. permission)
		end
		bitflag = bit.bor(bitflag, Permissions[permission] :: string)
	end
	return bitflag
end

--- Converts a set of permission strings to a bitflag
local function toBitflagFromSet(permissions: set.Set<Permissions>): typesext.U64Convertibles
	local bitflag = 0
	for permission in permissions do
		if not Permissions[permission] then
			error("Invalid permission: " .. permission)
		end
		bitflag = bit.bor(bitflag, Permissions[permission] :: string)
	end
	return bitflag
end

--- Adds the given permissions to the bitflag
---
--- Unlike the other methods here, this method is non-destructive and does not modify the original bitflag.
--- (e.g. if Discord has new permissions we don't know about, those will still be preserved)
local function addToPerms(bf: typesext.U64Convertibles, permissions: {Permissions}): typesext.U64Convertibles
	local bitflag = toBitflag(permissions)
	return bit.bor(bf, bitflag)
end

--- Removes the given permissions from the bitflag
---
--- Unlike the other methods here, this method is non-destructive and does not modify the original bitflag.
--- (e.g. if Discord has new permissions we don't know about, those will still be preserved)
local function removeFromPerms(bf: typesext.U64Convertibles, permissions: {Permissions}): typesext.U64Convertibles
	local bitflag = toBitflag(permissions)
	return bit.band(bf, bit.bnot(bitflag))
end

local OverwriteObjectTypeRole = 0
local OverwriteObjectTypeMember = 1

return {
	Permissions = Permissions,
	PermissionSet = PermissionSet,
	PermissionsAll = PermissionsAll,
	fromBitFlag = fromBitflag,
	fromBitFlagToSet = fromBitflagToSet,
	toBitFlag = toBitflag,
	toBitflagFromSet = toBitflagFromSet,
	OverwriteObjectTypeRole = OverwriteObjectTypeRole,
	OverwriteObjectTypeMember = OverwriteObjectTypeMember,
	addToPerms = addToPerms,
	removeFromPerms = removeFromPerms,
}