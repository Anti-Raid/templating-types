local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildScheduledEventUserRemove
---
--- Dispatched when a user is removed from a scheduled event in a guild.
local function onGuildScheduledEventUserRemove(event: Primitives.Event, callback: (unsubscribed: discordGateway.GuildScheduledEventUserRemovePayload) -> ())
    onEvent(event, "Discord.GUILD_SCHEDULED_EVENT_USER_REMOVE", function(event)
        callback(event.data)
    end)
end

return onGuildScheduledEventUserRemove
 