local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- DEPRECATED: The `AntiRaid.ExternalKeyUpdate` event is likely to be deprecated and will be removed in a future version.
---
--- Run a callback when the `AntiRaid.ExternalKeyUpdate` event is triggered (a key is updated externally).
--- @param event The event to listen for.
--- @param callback The callback to run when the event is triggered. The callback will receive the `events.ExternalKeyUpdateEventData` data.
local function onExternalKeyUpdate(event: Primitives.Event, callback: (data: events.ExternalKeyUpdateEventData) -> ())
    onEvent(event, "AntiRaid.ExternalKeyUpdate", function(event)
        callback(event.data)
    end)
end

return onExternalKeyUpdate