local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
  
--- InviteDelete
---
--- Dispatched when an invite is deleted.
local function onInviteDelete(event: Primitives.Event, callback: (data: discordGateway.InviteDeletePayload) -> ())
    onEvent(event, "Discord.INVITE_DELETE", function(event)
        callback(event.data)
    end)
end

return onInviteDelete
