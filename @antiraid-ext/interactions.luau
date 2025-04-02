local ApplicationCommandOptionType_Discord = require "@discord-types/interaction".ApplicationCommandOptionType

--[[
local ApplicationCommandOptionType = table.freeze(reflect({
	SubCommand = 1,
	SubCommandGroup = 2,
	String = 3,
	Integer = 4,
	Boolean = 5,
	User = 6,
	Channel = 7,
	Role = 8,
	Mentionable = 9,
	Number = 10,
	Attachment = 11,
}))
]]

local function ApplicationCommandOptionType(
    type: "SubCommand" | "SubCommandGroup" | "String" | "Integer" | "Boolean" | "User" | "Channel" | "Role" | "Mentionable" | "Number" | "Attachment"
): number
    return ApplicationCommandOptionType_Discord[type] :: number
end

return {
    ApplicationCommandOptionType = ApplicationCommandOptionType,
}