local Primitives = require("@antiraid-core/primitives")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- Run a callback when the `AntiRaid.KeyExpiry` event is triggered (a key is expired).
--- @param event The event to listen for.
--- @param callback The callback to run when the event is triggered. The callback will receive a list of templates which could have caused the event to be dispatched.
local function onStartup(event: Primitives.Event, callback: (modified: {string}) -> ())
    onEvent(event, "AntiRaid.OnStartup", function(event)
        callback(event.data)
    end)
end

return onStartup