local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- InviteCreate
---
--- Dispatched when an invite is created.
local function onInviteCreate(event: Primitives.Event, callback: (data: discordGateway.InviteCreatePayload) -> ())
    return createTab("INVITE_CREATE", function(event)
        callback(event.data)
    end)
end

return onInviteCreate
