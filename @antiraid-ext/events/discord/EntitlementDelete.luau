local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- EntitlementDelete
---
--- Provides data about the subscription. Specifically, the ``entitlement.deleted`` field will be set.
local function onEntitlementDelete(event: Primitives.Event, callback: (entitlement: discord.EntitlementObject) -> ())
    onEvent(event, "Discord.ENTITLEMENT_DELETE", function(event)
        callback(event.data)
    end)
end

return onEntitlementDelete