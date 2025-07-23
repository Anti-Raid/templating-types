local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildScheduledEventUserAdd
---
--- Dispatched when a user is added to a scheduled event in a guild.
local function onGuildScheduledEventUserAdd(event: Primitives.Event, callback: (subscribed: discordGateway.GuildScheduledEventUserAddPayload) -> ())
    onEvent(event, "Discord.GUILD_SCHEDULED_EVENT_USER_ADD", function(event)
        callback(event.data)
    end)
end

return onGuildScheduledEventUserAdd
 