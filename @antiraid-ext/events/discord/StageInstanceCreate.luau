local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- StageInstanceCreate
---
--- Dispatched when a stage instance is created.
local function onStageInstanceCreate(event: Primitives.Event, callback: (instance: discord.StageInstanceObject) -> ())
    onEvent(event, "Discord.StageInstanceCreate", function(event)
        callback(event.data["StageInstanceCreate"]["stage_instance"])
    end)
end

return onStageInstanceCreate
