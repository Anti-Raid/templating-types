local Primitives = require("@antiraid-core/primitives")
local stings = require("@antiraid/stings")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- StingDelete
---
--- A sting delete event. Dispatched when a sting is deleted
local function onStingDelete(event: Primitives.Event, callback: (sting: stings.Sting) -> ())
    onEvent(event, "AntiRaid.StingDelete", function(event)
        callback(event.data)
    end)
end

return onStingDelete