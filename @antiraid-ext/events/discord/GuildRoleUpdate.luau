local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildRoleUpdate
---
--- Dispatched when a role is updated in a guild.
local function onGuildRoleUpdate(event: Primitives.Event, callback: (payload: discordgateway.GuildRoleUpdatePayload) -> ())
    onEvent(event, "Discord.GUILD_ROLE_UPDATE", function(event)
        callback(event.data)
    end)
end

return onGuildRoleUpdate