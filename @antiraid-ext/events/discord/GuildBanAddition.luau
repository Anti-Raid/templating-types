local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildBanAddition
---
--- Dispatched when a user is banned from a guild.
---
--- Provides the user’s data and the id of the guild where the ban occurred.
local function onGuildBanAddition(event: Primitives.Event, callback: (user: discord.UserObject, guildId: string) -> ())
    onEvent(event, "Discord.GuildBanAddition", function(event)
        callback(event.data["GuildBanAddition"]["banned_user"], event.data["GuildBanAddition"]["guild_id"])
    end)
end

return onGuildBanAddition