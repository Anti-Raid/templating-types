local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- EntitlementUpdate
---
--- Provides data abut the updated subscription. If the entitlement is renewed, the ``entitlement.ends_at`` field will have changed.
local function onEntitlementUpdate(event: Primitives.Event, callback: (entitlement: discord.EntitlementObject) -> ())
    onEvent(event, "Discord.ENTITLEMENT_UPDATE", function(event)
        callback(event.data)
    end)
end

return onEntitlementUpdate