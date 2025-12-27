local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- GuildRoleCreate
---
--- Dispatched when a role is created in a guild.
local function onGuildRoleCreate(event: Primitives.Event, callback: (payload: discordgateway.GuildRoleCreatePayload) -> ())
    return createTab("GUILD_ROLE_CREATE", function(event)
        callback(event.data)
    end)
end

return onGuildRoleCreate