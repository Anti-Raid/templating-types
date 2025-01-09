local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- StageInstanceUpdate
---
--- Dispatched when a stage instance is updated.
local function onStageInstanceUpdate(event: Primitives.Event, callback: (new: discord.StageInstanceObject) -> ())
    onEvent(event, "Discord.StageInstanceUpdate", function(event)
        callback(event.data["StageInstanceUpdate"]["stage_instance"])
    end)
end

return onStageInstanceUpdate
 