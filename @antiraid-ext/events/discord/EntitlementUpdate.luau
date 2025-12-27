local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- EntitlementUpdate
---
--- Provides data abut the updated subscription. If the entitlement is renewed, the ``entitlement.ends_at`` field will have changed.
local function onEntitlementUpdate(event: Primitives.Event, callback: (entitlement: discord.EntitlementObject) -> ())
    return createTab("ENTITLEMENT_UPDATE", function(event)
        callback(event.data)
    end)
end

return onEntitlementUpdate