local Primitives = require("@antiraid-core/primitives")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- ShardsReady
---
--- Dispatched when all shards are ready to start receiving events.
---
--- Note that you usually won't get this event from AntiRaid unless you're self-hosting or unusual circumstances.
local function onShardsReady(event: Primitives.Event, callback: (totalShards: number) -> ())
    onEvent(event, "Discord.ShardsReady", function(event)
        callback(event.data["ShardsReady"]["total_shards"])
    end)
end

return onShardsReady
