local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- IntegrationDelete
---
--- Dispatched when an integration is deleted in a guild.
local function onIntegrationDelete(event: Primitives.Event, callback: (integrationId: discord.Snowflake, guildId: string, applicationId: string?) -> ())
    onEvent(event, "Discord.IntegrationDelete", function(event)
        callback(event.data["IntegrationDelete"]["integration_id"], event.data["IntegrationDelete"]["guild_id"], event.data["IntegrationDelete"]["application_id"])
    end)
end

return onIntegrationDelete
 