local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- KeyExpiry
local function onKeyExpiry(event: Primitives.Event, callback: (data: events.KeyExpiryEvent) -> ())
    onEvent(event, "AntiRaid.KeyExpiry", function(event)
        callback(event.data)
    end)
end

return onKeyExpiry