local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- MessageDelete
---
--- Dispatched when a message is deleted.
local function onMessageDelete(event: Primitives.Event, callback: (payload: discordgateway.MessageDeletePayload) -> ())
    return createTab("MESSAGE_DELETE", function(event)
        callback(event.data)
    end)
end

return onMessageDelete
