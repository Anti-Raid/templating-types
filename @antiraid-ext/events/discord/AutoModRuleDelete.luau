local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- AutoModRuleDelete
local function onAutoModRuleDelete(event: Primitives.Event, callback: (rule: discord.AutomoderationRuleObject) -> ())
    return createTab("AUTO_MODERATION_RULE_DELETE", function(event)
        callback(event.data)
    end)
end

return onAutoModRuleDelete