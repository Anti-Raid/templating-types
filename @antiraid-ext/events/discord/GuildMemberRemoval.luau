local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildMemberRemoval
---
--- Dispatched when a user’s membership ends by leaving, getting kicked, or being banned.
---
--- Provides the guild’s id and the user’s data.
local function onGuildMemberRemoval(event: Primitives.Event, callback: (payload: discordgateway.GuildMemberRemovePayload) -> ())
    onEvent(event, "Discord.GUILD_MEMBER_REMOVE", function(event)
        callback(event.data)
    end)
end

return onGuildMemberRemoval