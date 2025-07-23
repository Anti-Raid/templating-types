local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- AutoModRuleUpdate
local function onAutoModRuleUpdate(event: Primitives.Event, callback: (rule: discord.AutomoderationRuleObject) -> ())
    onEvent(event, "Discord.AUTO_MODERATION_RULE_UPDATE", function(event)
        callback(event.data)
    end)
end

return onAutoModRuleUpdate