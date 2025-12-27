local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- EntitlementCreate
local function onEntitlementCreate(event: Primitives.Event, callback: (entitlement: discord.EntitlementObject) -> ())
    return createTab("ENTITLEMENT_CREATE", function(event)
        callback(event.data)
    end)
end

return onEntitlementCreate