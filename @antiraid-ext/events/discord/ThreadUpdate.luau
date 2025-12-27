local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- ThreadUpdate
---
--- Dispatched when a thread is updated.
local function onThreadUpdate(event: Primitives.Event, callback: (event: discordGateway.UpdateThreadPayload) -> ())
    return createTab("THREAD_UPDATE", function(event)
        callback(event.data)
    end)
end

return onThreadUpdate
