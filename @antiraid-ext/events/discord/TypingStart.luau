local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- TypingStart
---
--- Dispatched when a user starts typing in a channel.
local function onTypingStart(event: Primitives.Event, callback: (data: discordGateway.TypingStartPayload) -> ())
    return createTab("TYPING_START", function(event)
        callback(event.data)
    end)
end

return onTypingStart
