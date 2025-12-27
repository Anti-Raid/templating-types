local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
  
--- InviteDelete
---
--- Dispatched when an invite is deleted.
local function onInviteDelete(event: Primitives.Event, callback: (data: discordGateway.InviteDeletePayload) -> ())
    return createTab("INVITE_DELETE", function(event)
        callback(event.data)
    end)
end

return onInviteDelete
