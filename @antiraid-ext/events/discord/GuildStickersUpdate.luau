local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- GuildStickersUpdate
---
--- Dispatched when the stickers in a guild are updated.
local function onGuildStickersUpdate(event: Primitives.Event, callback: (payload: discordgateway.GuildStickersUpdatePayload) -> ())
    onEvent(event, "Discord.GUILD_STICKERS_UPDATE", function(event)
        callback(event.data)
    end)
end

return onGuildStickersUpdate
 