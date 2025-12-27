local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- ThreadMembersUpdate
---
--- Dispatched when anyone is added to or removed from a thread.
local function onThreadMembersUpdate(event: Primitives.Event, callback: (data: discordGateway.ThreadMembersUpdatePayload) -> ())
    return createTab("THREAD_MEMBERS_UPDATE", function(event)
        callback(event.data)
    end)
end 

return onThreadMembersUpdate
