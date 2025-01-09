local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- AutoModRuleCreate
local function onAutoModRuleCreate(event: Primitives.Event, callback: (rule: discord.AutomoderationRuleObject) -> ())
    onEvent(event, "Discord.AutoModRuleCreate", function(event)
        callback(event.data["AutoModRuleCreate"]["rule"])
    end)
end

return onAutoModRuleCreate