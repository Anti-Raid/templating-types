local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildRoleDelete
---
--- Dispatched when a role is deleted in a guild.
local function onGuildRoleDelete(event: Primitives.Event, callback: (payload: discordgateway.GuildRoleDeletePayload) -> ())
    onEvent(event, "Discord.GUILD_ROLE_DELETE", function(event)
        callback(event.data)
    end)
end

return onGuildRoleDelete