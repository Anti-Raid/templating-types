local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- IntegrationCreate
---
--- Dispatched when an integration is created in a guild.
local function onIntegrationCreate(event: Primitives.Event, callback: (integration: discordgateway.IntegrationCreatePayload) -> ())
    return createTab("INTEGRATION_CREATE", function(event)
        callback(event.data)
    end)
end

return onIntegrationCreate
 