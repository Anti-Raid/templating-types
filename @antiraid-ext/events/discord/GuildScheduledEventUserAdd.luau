local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- GuildScheduledEventUserAdd
---
--- Dispatched when a user is added to a scheduled event in a guild.
local function onGuildScheduledEventUserAdd(event: Primitives.Event, callback: (subscribed: discordGateway.GuildScheduledEventUserAddPayload) -> ())
    return createTab("GUILD_SCHEDULED_EVENT_USER_ADD", function(event)
        callback(event.data)
    end)
end

return onGuildScheduledEventUserAdd
 