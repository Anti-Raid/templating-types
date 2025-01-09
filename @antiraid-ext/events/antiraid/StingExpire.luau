local Primitives = require("@antiraid-core/primitives")
local stings = require("@antiraid/stings")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- StingExpire
---
--- A sting expiry event. Dispatched when a sting expires
local function onStingExpire(event: Primitives.Event, callback: (sting: stings.Sting) -> ())
    onEvent(event, "AntiRaid.StingExpire", function(event)
        callback(event.data)
    end)
end

return onStingExpire