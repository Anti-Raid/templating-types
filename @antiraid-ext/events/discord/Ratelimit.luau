local Primitives = require("@antiraid-core/primitives")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- Ratelimit
---
--- Dispatched when an HTTP ratelimit is hit.
---
--- Note that you usually won't get this event from AntiRaid unless you're self-hosting or unusual circumstances.
local function onRatelimit(event: Primitives.Event, callback: (ratelimitData: any) -> ())
    onEvent(event, "Discord.Ratelimit", function(event)
        callback(event.data["Ratelimit"]["data"])
    end)
end

return onRatelimit
