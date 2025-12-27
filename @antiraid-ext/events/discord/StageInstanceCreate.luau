local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- StageInstanceCreate
---
--- Dispatched when a stage instance is created.
local function onStageInstanceCreate(event: Primitives.Event, callback: (instance: discord.StageInstanceObject) -> ())
    return createTab("STAGE_INSTANCE_CREATE", function(event)
        callback(event.data)
    end)
end

return onStageInstanceCreate
