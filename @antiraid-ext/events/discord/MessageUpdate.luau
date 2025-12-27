local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- MessageUpdate
---
--- Provides the message update data, as well as the actual old and new message if data is available.
local function onMessageUpdate(event: Primitives.Event, callback: (payload: discordGateway.MessageUpdatePayload) -> ())
    return createTab("MESSAGE_UPDATE", function(event)
        callback(event.data)
    end)
end

return onMessageUpdate
