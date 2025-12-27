local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- IntegrationUpdate
local function onIntegrationUpdate(event: Primitives.Event, callback: (integration: discordgateway.IntegrationUpdatePayload) -> ())
    return createTab("INTEGRATION_UPDATE", function(event)
        callback(event.data)
    end)
end

return onIntegrationUpdate
 