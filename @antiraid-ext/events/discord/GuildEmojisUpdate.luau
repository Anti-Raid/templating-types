local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildEmojisUpdate
---
--- Dispatched when the emojis in a guild are updated.
---
--- Provides the guild’s id and the new state of the emojis in the guild.
local function onGuildEmojisUpdate(event: Primitives.Event, callback: (payload: discordgateway.GuildEmojisUpdatePayload) -> ())
    onEvent(event, "Discord.GUILD_EMOJIS_UPDATE", function(event)
        callback(event.data)
    end)
end

return onGuildEmojisUpdate