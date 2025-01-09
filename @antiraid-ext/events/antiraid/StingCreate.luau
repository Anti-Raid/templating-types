local Primitives = require("@antiraid-core/primitives")
local stings = require("@antiraid/stings")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- StingCreate
---
--- A sting create event. Dispatched when a sting is created
local function onStingCreate(event: Primitives.Event, callback: (sting: stings.Sting) -> ())
    onEvent(event, "AntiRaid.StingCreate", function(event)
        callback(event.data)
    end)
end

return onStingCreate