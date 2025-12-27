local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- GuildRoleDelete
---
--- Dispatched when a role is deleted in a guild.
local function onGuildRoleDelete(event: Primitives.Event, callback: (payload: discordgateway.GuildRoleDeletePayload) -> ())
    return createTab("GUILD_ROLE_DELETE", function(event)
        callback(event.data)
    end)
end

return onGuildRoleDelete