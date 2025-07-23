local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- GuildBanRemoval
---
--- Dispatched when a user is unbanned from a guild.
---
--- Provides the user’s data and the id of the guild where the unban occurred.
local function onGuildBanRemoval(event: Primitives.Event, callback: (user: discordGateway.GuildBanRemovePayload) -> ())
    onEvent(event, "Discord.GUILD_BAN_REMOVE", function(event)
        callback(event.data)
    end)
end 

return onGuildBanRemoval