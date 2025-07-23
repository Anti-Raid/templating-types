local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- TypingStart
---
--- Dispatched when a user starts typing in a channel.
local function onTypingStart(event: Primitives.Event, callback: (data: discordGateway.TypingStartPayload) -> ())
    onEvent(event, "Discord.TYPING_START", function(event)
        callback(event.data)
    end)
end

return onTypingStart
