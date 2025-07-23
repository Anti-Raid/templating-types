local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- ThreadCreate
---
--- Dispatched when a thread is created or the current user is added to a private thread.
local function onThreadCreate(event: Primitives.Event, callback: (event: discordGateway.CreateThreadPayload) -> ())
    onEvent(event, "Discord.THREAD_CREATE", function(event)
        callback(event.data)
    end)
end

return onThreadCreate
