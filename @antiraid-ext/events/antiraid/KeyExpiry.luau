local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- Run a callback when the `AntiRaid.KeyExpiry` event is triggered (a key is expired).
--- @param event The event to listen for.
--- @param callback The callback to run when the event is triggered. The callback will receive the `events.KeyExpiryEvent` data.
local function onKeyExpiry(event: Primitives.Event, callback: (data: events.KeyExpiryEvent) -> ())
    onEvent(event, "AntiRaid.KeyExpiry", function(event)
        callback(event.data)
    end)
end

return onKeyExpiry