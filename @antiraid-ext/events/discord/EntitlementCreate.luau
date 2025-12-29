local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- EntitlementCreate
local function EntitlementCreate(callback: (ctx: Primitives.TemplateContext, entitlement: discord.EntitlementObject) -> ())
    return createTab("ENTITLEMENT_CREATE", function(ctx)
        return callback(ctx, ctx:event().data)
    end)
end

return EntitlementCreate