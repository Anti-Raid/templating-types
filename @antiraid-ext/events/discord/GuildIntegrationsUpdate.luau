local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildIntegrationsUpdate
---
--- Dispatched when a guild’s integration is added, updated or removed.
local function onGuildIntegrationsUpdate(event: Primitives.Event, callback: (payload: discordgateway.GuildIntegrationsUpdatePayload) -> ())
    onEvent(event, "Discord.GUILD_INTEGRATIONS_UPDATE", function(event)
        callback(event.data)
    end)
end

return onGuildIntegrationsUpdate