local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- ThreadMembersUpdate
---
--- Dispatched when anyone is added to or removed from a thread.
local function onThreadMembersUpdate(event: Primitives.Event, callback: (data: discordGateway.ThreadMembersUpdatePayload) -> ())
    onEvent(event, "Discord.ThreadMembersUpdate", function(event)
        callback(event.data["ThreadMembersUpdate"]["thread_members_update"])
    end)
end 

return onThreadMembersUpdate
