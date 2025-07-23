local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- GuildMemberAddition
---
--- Dispatched when a user joins a guild.
---
--- Provides the guild’s id and the user’s member data.
local function onGuildMemberAddition(event: Primitives.Event, callback: (member: discordgateway.GuildMemberAddPayload) -> ())
    onEvent(event, "Discord.GUILD_MEMBER_ADD", function(event)
        callback(event.data)
    end)
end

return onGuildMemberAddition