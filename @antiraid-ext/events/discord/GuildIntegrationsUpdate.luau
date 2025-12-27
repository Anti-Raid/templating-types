local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- GuildIntegrationsUpdate
---
--- Dispatched when a guild’s integration is added, updated or removed.
local function onGuildIntegrationsUpdate(event: Primitives.Event, callback: (payload: discordgateway.GuildIntegrationsUpdatePayload) -> ())
    return createTab("GUILD_INTEGRATIONS_UPDATE", function(event)
        callback(event.data)
    end)
end

return onGuildIntegrationsUpdate