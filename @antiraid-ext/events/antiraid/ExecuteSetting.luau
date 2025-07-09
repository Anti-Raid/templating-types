local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local onEventGeneric = require("@antiraid-ext/events/dispatch").onEventGeneric

--- Run a callback when the `AntiRaid.ExecuteSetting` event is triggered.
--- @param event The event to listen for.
--- @param callback The callback to run when the event is triggered. The callback will receive the `events.SettingExecuteEvent` data.
--- @return data The data returned by the callback.
local function onExecuteSetting(event: Primitives.Event, callback: (data: events.SettingExecuteEvent) -> any)
    return onEventGeneric(event, "AntiRaid.ExecuteSetting", function(event)
        return callback(event.data)
    end) 
end

return onExecuteSetting