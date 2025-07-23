local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- AutoModActionExecution
---
--- Note that discord-luau calls it ApplicationCommandPermissionsExecutionPayload instead of AutoModActionExecution due to naming bug
local function onAutoModActionExecution(event: Primitives.Event, callback: (action: discordGateway.ApplicationCommandPermissionsExecutionPayload) -> ())
    onEvent(event, "Discord.AUTO_MODERATION_ACTION_EXECUTION", function(event)
        callback(event.data)
    end)
end

return onAutoModActionExecution