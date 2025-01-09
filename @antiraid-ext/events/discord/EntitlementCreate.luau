local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- EntitlementCreate
local function onEntitlementCreate(event: Primitives.Event, callback: (entitlement: discord.EntitlementObject) -> ())
    onEvent(event, "Discord.EntitlementCreate", function(event)
        callback(event.data["EntitlementCreate"]["entitlement"])
    end)
end

return onEntitlementCreate