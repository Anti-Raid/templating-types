local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- MessageDelete
---
--- Dispatched when a message is deleted.
local function onMessageDelete(event: Primitives.Event, callback: (payload: discordgateway.MessageDeletePayload) -> ())
    onEvent(event, "Discord.MESSAGE_DELETE", function(event)
        callback(event.data)
    end)
end

return onMessageDelete
