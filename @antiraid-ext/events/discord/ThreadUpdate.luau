local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- ThreadUpdate
---
--- Dispatched when a thread is updated.
local function onThreadUpdate(event: Primitives.Event, callback: (event: discordGateway.UpdateThreadPayload) -> ())
    onEvent(event, "Discord.THREAD_UPDATE", function(event)
        callback(event.data)
    end)
end

return onThreadUpdate
