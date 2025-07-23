local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- IntegrationDelete
---
--- Dispatched when an integration is deleted in a guild.
local function onIntegrationDelete(event: Primitives.Event, callback: (payload: discordgateway.IntegrationDeletePayload) -> ())
    onEvent(event, "Discord.INTEGRATION_DELETE", function(event)
        callback(event.data)
    end)
end

return onIntegrationDelete
 