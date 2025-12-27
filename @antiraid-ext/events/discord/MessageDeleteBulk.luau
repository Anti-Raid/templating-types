local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- MessageDeleteBulk
---
--- Dispatched when multiple messages are deleted at once.
local function onMessageDeleteBulk(event: Primitives.Event, callback: (payload: discordgateway.MessageDeleteBulkPayload) -> ())
    return createTab("MESSAGE_DELETE_BULK", function(event)
        callback(event.data)
    end)
end

return onMessageDeleteBulk
 