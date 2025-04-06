local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- ScheduledExecution
local function onScheduledEvent(event: Primitives.Event, callback: (data: events.ScheduledExecutionEventData) -> ())
    onEvent(event, "AntiRaid.ScheduledExecution", function(event)
        callback(event.data)
    end)
end

return onScheduledEvent