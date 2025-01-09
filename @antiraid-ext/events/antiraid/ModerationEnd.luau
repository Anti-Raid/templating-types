local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- ModerationEnd
local function onModerationEnd(event: Primitives.Event, callback: (data: events.ModerationEndEventData) -> ())
    onEvent(event, "AntiRaid.ModerationEnd", function(event)
        callback(event.data)
    end)
end

return onModerationEnd