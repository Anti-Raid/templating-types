local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- AutoModActionExecution
---
--- Note that discord-luau calls it ApplicationCommandPermissionsExecutionPayload instead of AutoModActionExecution due to naming bug
local function onAutoModActionExecution(event: Primitives.Event, callback: (action: discordGateway.ApplicationCommandPermissionsExecutionPayload) -> ())
    return createTab("AUTO_MODERATION_ACTION_EXECUTION", function(event)
        callback(event.data)
    end)
end

return onAutoModActionExecution