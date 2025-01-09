local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- GuildCreate
---
--- You normally won't get this event unless you're self hosting AntiRaid or theres a network error.
local function onGuildCreate(event: Primitives.Event, callback: (guild: discord.GuildObject, isNew: boolean?) -> ())
    onEvent(event, "Discord.GuildCreate", function(event)
        callback(event.data["GuildCreate"]["guild"], event.data["GuildCreate"]["is_new"])
    end)
end

return onGuildCreate