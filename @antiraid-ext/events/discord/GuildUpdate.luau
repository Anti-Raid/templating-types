local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- GuildUpdate
---
--- Dispatched when the guild is updated.
---
--- Note that the new data may be partial
local function onGuildUpdate(event: Primitives.Event, callback: (old: discord.GuildObject?, new: discord.GuildObject) -> ())
    onEvent(event, "Discord.GuildUpdate", function(event)
        callback(event.data["GuildUpdate"]["old_data_if_available"], event.data["GuildUpdate"]["new_data"])
    end)
end

return onGuildUpdate
 