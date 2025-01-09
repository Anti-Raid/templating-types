local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildMemberRemoval
---
--- Dispatched when a user’s membership ends by leaving, getting kicked, or being banned.
---
--- Provides the guild’s id, the user’s data, and the user’s member data if cache feature is enabled and the data is available.
local function onGuildMemberRemoval(event: Primitives.Event, callback: (user: discord.UserObject, memberDataIfAvailable: discord.GuildMemberObject?, guildId: string) -> ())
    onEvent(event, "Discord.GuildMemberRemoval", function(event)
        callback(event.data["GuildMemberRemoval"]["user"], event.data["GuildMemberRemoval"]["member_data_if_available"], event.data["GuildMemberRemoval"]["guild_id"])
    end)
end

return onGuildMemberRemoval