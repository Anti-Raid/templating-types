local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildScheduledEventDelete
---
--- Dispatched when a scheduled event is deleted in a guild.
local function onGuildScheduledEventDelete(event: Primitives.Event, callback: (event: discord.GuildScheduledEventObject) -> ())
    onEvent(event, "Discord.GUILD_SCHEDULED_EVENT_DELETE", function(event)
        callback(event.data)
    end)
end

return onGuildScheduledEventDelete