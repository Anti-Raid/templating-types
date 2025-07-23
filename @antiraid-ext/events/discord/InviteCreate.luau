local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- InviteCreate
---
--- Dispatched when an invite is created.
local function onInviteCreate(event: Primitives.Event, callback: (data: discordGateway.InviteCreatePayload) -> ())
    onEvent(event, "Discord.INVITE_CREATE", function(event)
        callback(event.data)
    end)
end

return onInviteCreate
