local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- IntegrationUpdate
local function onIntegrationUpdate(event: Primitives.Event, callback: (integration: discord.IntegrationObject) -> ())
    onEvent(event, "Discord.IntegrationUpdate", function(event)
        callback(event.data["IntegrationUpdate"]["integration"])
    end)
end

return onIntegrationUpdate
 