local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- GuildUpdate
---
--- Dispatched when the guild is updated.
---
--- Note that the new data may be partial
local function onGuildUpdate(event: Primitives.Event, callback: (new: discord.GuildObject) -> ())
    return createTab("GUILD_UPDATE", function(event)
        callback(event.data)
    end)
end

return onGuildUpdate
 