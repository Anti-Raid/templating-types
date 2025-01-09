local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- GuildMemberUpdate
---
--- Dispatched when a member is updated (e.g their nickname is updated).
---
--- Provides the member’s old and new data (if cache feature is enabled and data is available) and the new raw data about updated fields.
local function onGuildMemberUpdate(event: Primitives.Event, callback: (oldIfAvailable: discord.GuildMemberObject?, new: discord.GuildMemberObject?, rawEvent: discordGateway.GuildMemberUpdatePayload) -> ())
    onEvent(event, "Discord.GuildMemberUpdate", function(event)
        callback(event.data["GuildMemberUpdate"]["old_if_available"], event.data["GuildMemberUpdate"]["new"], event.data["GuildMemberUpdate"]["event"])
    end)
end

return onGuildMemberUpdate