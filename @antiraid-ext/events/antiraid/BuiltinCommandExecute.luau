local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- BuiltinCommandExecute
local function onBuiltinCommandExecute(event: Primitives.Event, callback: (data: events.BuiltinCommandExecuteData) -> ())
    onEvent(event, "AntiRaid.BuiltinCommandExecute", function(event)
        callback(event.data)
    end)
end

return onBuiltinCommandExecute