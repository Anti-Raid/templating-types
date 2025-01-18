local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- ExternalKeyUpdate
local function onExternalKeyUpdate(event: Primitives.Event, callback: (data: events.ExternalKeyUpdateEventData) -> ())
    onEvent(event, "AntiRaid.ExternalKeyUpdate", function(event)
        callback(event.data)
    end)
end

return onExternalKeyUpdate