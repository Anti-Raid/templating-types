local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildScheduledEventCreate
---
--- Dispatched when a scheduled event is created in a guild.
local function onGuildScheduledEventCreate(event: Primitives.Event, callback: (event: discord.GuildScheduledEventObject) -> ())
    onEvent(event, "Discord.GUILD_SCHEDULED_EVENT_CREATE", function(event)
        callback(event.data)
    end)
end

return onGuildScheduledEventCreate