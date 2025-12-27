local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- IntegrationDelete
---
--- Dispatched when an integration is deleted in a guild.
local function onIntegrationDelete(event: Primitives.Event, callback: (payload: discordgateway.IntegrationDeletePayload) -> ())
    return createTab("INTEGRATION_DELETE", function(event)
        callback(event.data)
    end)
end

return onIntegrationDelete
 