local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- ThreadMemberUpdate
---
--- Dispatched when a thread member is updated.
local function onThreadMemberUpdate(event: Primitives.Event, callback: (event: discordGateway.ThreadMemberUpdatePayload) -> ())
    return createTab("THREAD_MEMBER_UPDATE", function(event)
        callback(event.data)
    end)
end

return onThreadMemberUpdate
