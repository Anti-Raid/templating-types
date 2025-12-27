local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- GuildStickersUpdate
---
--- Dispatched when the stickers in a guild are updated.
local function onGuildStickersUpdate(event: Primitives.Event, callback: (payload: discordgateway.GuildStickersUpdatePayload) -> ())
    return createTab("GUILD_STICKERS_UPDATE", function(event)
        callback(event.data)
    end)
end

return onGuildStickersUpdate
 