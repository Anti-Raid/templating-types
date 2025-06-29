local Primitives = require("@antiraid-core/primitives")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- OnStartup
local function onStartup(event: Primitives.Event, callback: (modified: {string}) -> ())
    onEvent(event, "AntiRaid.OnStartup", function(event)
        callback(event.data)
    end)
end

return onStartup