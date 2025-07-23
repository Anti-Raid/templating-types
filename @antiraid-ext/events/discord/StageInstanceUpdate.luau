local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- StageInstanceUpdate
---
--- Dispatched when a stage instance is updated.
local function onStageInstanceUpdate(event: Primitives.Event, callback: (new: discord.StageInstanceObject) -> ())
    onEvent(event, "Discord.STAGE_INSTANCE_UPDATE", function(event)
        callback(event.data)
    end)
end

return onStageInstanceUpdate
 