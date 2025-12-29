local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- AutoModRuleCreate
local function AutoModRuleCreate(callback: (ctx: Primitives.TemplateContext, rule: discord.AutomoderationRuleObject) -> ())
    return createTab("AUTO_MODERATION_RULE_CREATE", function(ctx)
        return callback(ctx, ctx:event().data)
    end)
end

return AutoModRuleCreate