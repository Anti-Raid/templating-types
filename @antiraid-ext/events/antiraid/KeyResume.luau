local Primitives = require("@antiraid-core/primitives")
local createTab = require("@antiraid-ext/events/dispatch").createTab
local events = require("@antiraid-core/events")

--- Run a callback when the `AntiRaid.KeyResume` event is triggered (a key is resumed).
---
--- A key is resumed when it is set with the `resume` flag and the template is reloaded or the worker process restarted.
--- @param event The event to listen for.
--- @param callback The callback to run when the event is triggered. The callback will receive a key resume event
local function keyResume(event: Primitives.Event, callback: (events.KeyResumeEvent) -> ())
    return createTab("KeyResume", function(event)
        callback(event.data)
    end)
end

return keyResume