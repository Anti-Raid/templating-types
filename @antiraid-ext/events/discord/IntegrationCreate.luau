local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- IntegrationCreate
---
--- Dispatched when an integration is created in a guild.
local function onIntegrationCreate(event: Primitives.Event, callback: (integration: discordgateway.IntegrationCreatePayload) -> ())
    onEvent(event, "Discord.INTEGRATION_CREATE", function(event)
        callback(event.data)
    end)
end

return onIntegrationCreate
 