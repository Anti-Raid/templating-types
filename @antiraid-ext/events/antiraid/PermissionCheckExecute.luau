local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- PermissionCheckExecute
local function onPermissionCheckExecute(event: Primitives.Event, callback: (data: events.PermissionCheckData) -> ())
    onEvent(event, "AntiRaid.PermissionCheckExecute", function(event)
        callback(event.data)
    end)
end

return onPermissionCheckExecute