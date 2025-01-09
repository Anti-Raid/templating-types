local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- StageInstanceDelete
---
--- Dispatched when a stage instance is deleted.
local function onStageInstanceDelete(event: Primitives.Event, callback: (instance: discord.StageInstanceObject) -> ())
    onEvent(event, "Discord.StageInstanceDelete", function(event)
        callback(event.data["StageInstanceDelete"]["stage_instance"])
    end)
end

return onStageInstanceDelete
