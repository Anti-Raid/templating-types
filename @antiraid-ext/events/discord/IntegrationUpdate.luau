local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- IntegrationUpdate
local function onIntegrationUpdate(event: Primitives.Event, callback: (integration: discordgateway.IntegrationUpdatePayload) -> ())
    onEvent(event, "Discord.INTEGRATION_UPDATE", function(event)
        callback(event.data)
    end)
end

return onIntegrationUpdate
 