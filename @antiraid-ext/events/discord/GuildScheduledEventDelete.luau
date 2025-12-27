local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- GuildScheduledEventDelete
---
--- Dispatched when a scheduled event is deleted in a guild.
local function onGuildScheduledEventDelete(event: Primitives.Event, callback: (event: discord.GuildScheduledEventObject) -> ())
    return createTab("GUILD_SCHEDULED_EVENT_DELETE", function(event)
        callback(event.data)
    end)
end

return onGuildScheduledEventDelete