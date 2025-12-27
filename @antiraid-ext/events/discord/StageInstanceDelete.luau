local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- StageInstanceDelete
---
--- Dispatched when a stage instance is deleted.
local function onStageInstanceDelete(event: Primitives.Event, callback: (instance: discord.StageInstanceObject) -> ())
    return createTab("STAGE_INSTANCE_DELETE", function(event)
        callback(event.data)
    end)
end

return onStageInstanceDelete
