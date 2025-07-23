local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- ThreadMemberUpdate
---
--- Dispatched when a thread member is updated.
local function onThreadMemberUpdate(event: Primitives.Event, callback: (event: discordGateway.ThreadMemberUpdatePayload) -> ())
    onEvent(event, "Discord.THREAD_MEMBER_UPDATE", function(event)
        callback(event.data)
    end)
end

return onThreadMemberUpdate
