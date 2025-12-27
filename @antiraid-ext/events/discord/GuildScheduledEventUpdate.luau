local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- GuildScheduledEventUpdate
---
--- Dispatched when a scheduled event is updated in a guild.
local function onGuildScheduledEventUpdate(event: Primitives.Event, callback: (event: discord.GuildScheduledEventObject) -> ())
    return createTab("GUILD_SCHEDULED_EVENT_UPDATE", function(event)
        callback(event.data)
    end)
end

return onGuildScheduledEventUpdate