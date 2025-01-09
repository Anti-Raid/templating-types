local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildScheduledEventDelete
---
--- Dispatched when a scheduled event is deleted in a guild.
local function onGuildScheduledEventDelete(event: Primitives.Event, callback: (event: discord.GuildScheduledEventObject) -> ())
    onEvent(event, "Discord.GuildScheduledEventDelete", function(event)
        callback(event.data["GuildScheduledEventDelete"]["event"])
    end)
end

return onGuildScheduledEventDelete