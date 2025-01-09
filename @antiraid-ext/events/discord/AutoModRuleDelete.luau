local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- AutoModRuleDelete
local function onAutoModRuleDelete(event: Primitives.Event, callback: (rule: discord.AutomoderationRuleObject) -> ())
    onEvent(event, "Discord.AutoModRuleDelete", function(event)
        callback(event.data["AutoModRuleDelete"]["rule"])
    end)
end

return onAutoModRuleDelete