local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local onEventGeneric = require("@antiraid-ext/events/dispatch").onEventGeneric

--- ExecuteSetting
local function onExecuteSetting(event: Primitives.Event, callback: (data: events.SettingExecuteEvent) -> any)
    return onEventGeneric(event, "AntiRaid.ExecuteSetting", function(event)
        return callback(event.data)
    end) 
end

return onExecuteSetting