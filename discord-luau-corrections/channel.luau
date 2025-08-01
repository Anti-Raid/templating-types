local apiTypes = require("@discord-types/apiTypes")

local reflect = require("@discord-types/utils/table/reflect")

local ChannelTypesMap = {
	GuildText = 0,
	DM = 1,
	GuildVoice = 2,
	GroupDM = 3,
	GuildCategory = 4,
	GuildAnnouncement = 5,
	AnnouncementThread = 10,
	PublicThread = 11,
	PrivateThread = 12,
	GuildStageVoice = 13,
	GuildDirectory = 14,
	GuildForum = 15,
	GuildMedia = 16,
}

local ChannelTypes = table.freeze(reflect(ChannelTypesMap))

local MediaSortOrder = table.freeze(reflect({
	LatestActivity = 0,
	CreationDate = 1,
}))

local ForumSortOrder = table.freeze(reflect({
	LatestActivity = 0,
	CreationDate = 1,
}))

local ForumLayout = table.freeze(reflect({
	NotSet = 0,
	ListView = 1,
	GalleryView = 2,
}))

local VideoQualityMode = table.freeze(reflect({
	Auto = 1,
	Full = 2,
}))

local SelectMenuType = table.freeze(reflect({
	String = 3,
	Text = 4,
	User = 5,
	Role = 6,
	Mentionable = 7,
	Channel = 8,
}))

export type ChannelType =
	"GuildText"
	| "DM"
	| "GuildVoice"
	| "GroupDM"
	| "GuildCategory"
	| "GuildAnnouncement"
	| "AnnouncementThread"
	| "PublicThread"
	| "PrivateThread"
	| "GuildStageVoice"
	| "GuildDirectory"
	| "GuildForum"
	| "GuildMedia"

export type MediaSortOrder = "LatestActivity" | "CreationDate"
export type ForumSortOrder = "LatestActivity" | "CreationDate"
export type ForumLayout = "NotSet" | "ListView" | "GalleryView"

export type VideoQualityMode = "Auto" | "Full"

export type SelectMenuType = "String" | "Text" | "User" | "Role" | "Mentionable" | "Channel"

export type AbstractChannel = {
	id: apiTypes.Snowflake?,
	type: ChannelType,
	guild_id: apiTypes.Snowflake?,
	position: number,
	permission_overwrites: { apiTypes.OverwriteObject },
	name: string,
	topic: string?,
	nsfw: boolean?,
	last_message_id: apiTypes.Snowflake?,
	bitrate: number?,
	user_limit: number?,
	rate_limit_per_user: number?,
	recipients: { apiTypes.UserObject }?,
	icon: string?,
	owner_id: apiTypes.Snowflake?,
	application_id: apiTypes.Snowflake?,
	managed: boolean?,
	parent_id: apiTypes.Snowflake?,
	last_pin_timestamp: string?,
	rtc_region: string?,
	video_quality_mode: VideoQualityMode?,
	message_count: number?,
	member_count: number?,
	thread_metadata: apiTypes.ThreadMetadataObject?,
	member: apiTypes.ThreadMemberObject?,
	default_auto_archive_duration: number?,
	permissions: string?,
	flags: apiTypes.ChannelFlags?,
	total_message_sent: number?,
	available_tags: { apiTypes.ForumTagObject }?,
	applied_tags: { apiTypes.Snowflake }?,
	default_reaction_emoji: apiTypes.DefaultReactionObject?,
	default_thread_rate_limit_per_user: number?,
	default_sort_order: apiTypes.SortOrderType?,
	default_forum_layout: apiTypes.ForumLayoutType?,
}

return {
	ChannelTypesMap = ChannelTypesMap,
	ChannelTypes = ChannelTypes,
	MediaSortOrder = MediaSortOrder,
	ForumSortOrder = ForumSortOrder,
	ForumLayout = ForumLayout,
	VideoQualityMode = VideoQualityMode,
	SelectMenuType = SelectMenuType,
}