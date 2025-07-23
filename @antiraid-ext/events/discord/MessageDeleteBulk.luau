local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- MessageDeleteBulk
---
--- Dispatched when multiple messages are deleted at once.
local function onMessageDeleteBulk(event: Primitives.Event, callback: (payload: discordgateway.MessageDeleteBulkPayload) -> ())
    onEvent(event, "Discord.MESSAGE_DELETE_BULK", function(event)
        callback(event.data)
    end)
end

return onMessageDeleteBulk
 