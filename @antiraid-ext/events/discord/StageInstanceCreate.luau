local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- StageInstanceCreate
---
--- Dispatched when a stage instance is created.
local function onStageInstanceCreate(event: Primitives.Event, callback: (instance: discord.StageInstanceObject) -> ())
    onEvent(event, "Discord.STAGE_INSTANCE_CREATE", function(event)
        callback(event.data)
    end)
end

return onStageInstanceCreate
