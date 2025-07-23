local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- StageInstanceDelete
---
--- Dispatched when a stage instance is deleted.
local function onStageInstanceDelete(event: Primitives.Event, callback: (instance: discord.StageInstanceObject) -> ())
    onEvent(event, "Discord.STAGE_INSTANCE_DELETE", function(event)
        callback(event.data)
    end)
end

return onStageInstanceDelete
