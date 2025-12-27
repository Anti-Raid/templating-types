local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
 
--- EntitlementDelete
---
--- Provides data about the subscription. Specifically, the ``entitlement.deleted`` field will be set.
local function onEntitlementDelete(event: Primitives.Event, callback: (entitlement: discord.EntitlementObject) -> ())
    callback(event.data)
end

return onEntitlementDelete