local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- GuildScheduledEventCreate
---
--- Dispatched when a scheduled event is created in a guild.
local function onGuildScheduledEventCreate(event: Primitives.Event, callback: (event: discord.GuildScheduledEventObject) -> ())
    return createTab("GUILD_SCHEDULED_EVENT_CREATE", function(event)
        callback(event.data)
    end)
end

return onGuildScheduledEventCreate