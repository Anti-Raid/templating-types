local Primitives = require("@antiraid-core/primitives")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- ShardStageUpdate
---
--- Dispatched when a shard’s connection stage is updated
---
--- Provides the context of the shard and the event information about the update.
---
--- Note that you usually won't get this event from AntiRaid unless you're self-hosting or unusual circumstances.
local function onShardStageUpdate(event: Primitives.Event, callback: (data: any) -> ())
    onEvent(event, "Discord.ShardStageUpdate", function(event)
        callback(event.data["ShardStageUpdate"]["event"])
    end)
end

return onShardStageUpdate
