local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- ExternalKeyAdd
local function onExternalKeyAdd(event: Primitives.Event, callback: (data: events.ExternalKeyUpdateEventData) -> ())
    onEvent(event, "AntiRaid.ExternalKeyAdd", function(event)
        callback(event.data)
    end)
end

return onExternalKeyAdd