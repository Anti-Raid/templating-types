local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- GuildScheduledEventUpdate
---
--- Dispatched when a scheduled event is updated in a guild.
local function onGuildScheduledEventUpdate(event: Primitives.Event, callback: (event: discord.GuildScheduledEventObject) -> ())
    onEvent(event, "Discord.GuildScheduledEventUpdate", function(event)
        callback(event.data["GuildScheduledEventUpdate"]["event"])
    end)
end

return onGuildScheduledEventUpdate