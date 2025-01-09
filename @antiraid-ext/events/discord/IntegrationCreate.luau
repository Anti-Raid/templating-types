local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- IntegrationCreate
---
--- Dispatched when an integration is created in a guild.
local function onIntegrationCreate(event: Primitives.Event, callback: (integration: discord.IntegrationObject) -> ())
    onEvent(event, "Discord.IntegrationCreate", function(event)
        callback(event.data["IntegrationCreate"]["integration"])
    end)
end

return onIntegrationCreate
 