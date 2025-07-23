local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- GuildMemberUpdate
---
--- Dispatched when a member is updated (e.g their nickname is updated).
---
--- Provides the member’s old and new data (if cache feature is enabled and data is available) and the new raw data about updated fields.
local function onGuildMemberUpdate(event: Primitives.Event, callback: (payload: discordGateway.GuildMemberUpdatePayload) -> ())
    onEvent(event, "Discord.GUILD_MEMBER_UPDATE", function(event)
        callback(event.data)
    end)
end

return onGuildMemberUpdate