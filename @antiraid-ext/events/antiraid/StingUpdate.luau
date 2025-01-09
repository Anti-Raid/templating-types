local Primitives = require("@antiraid-core/primitives")
local stings = require("@antiraid/stings")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- StingUpdate
---
--- A sting update event. Dispatched when a sting is updated
local function onStingUpdate(event: Primitives.Event, callback: (sting: stings.Sting) -> ())
    onEvent(event, "AntiRaid.StingUpdate", function(event)
        callback(event.data)
    end)
end

return onStingUpdate