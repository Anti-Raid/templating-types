local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- GuildBanAddition
---
--- Dispatched when a user is banned from a guild.
---
--- Provides the user’s data and the id of the guild where the ban occurred.
local function onGuildBanAddition(event: Primitives.Event, callback: (data: discordGateway.GuildBanAddPayload) -> ())
    return createTab("GUILD_BAN_ADD", function(event)
        callback(event.data)
    end)
end

return onGuildBanAddition