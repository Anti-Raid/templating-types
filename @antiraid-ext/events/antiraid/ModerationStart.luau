local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- ModerationStart
local function onModerationStart(event: Primitives.Event, callback: (data: events.ModerationStartEventData) -> ())
    onEvent(event, "AntiRaid.ModerationStart", function(event)
        callback(event.data)
    end)
end

return onModerationStart