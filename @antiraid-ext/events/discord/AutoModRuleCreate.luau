local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- AutoModRuleCreate
local function onAutoModRuleCreate(event: Primitives.Event, callback: (rule: discord.AutomoderationRuleObject) -> ())
    return createTab("AUTO_MODERATION_RULE_CREATE", function(event)
        callback(event.data)
    end)
end

return onAutoModRuleCreate