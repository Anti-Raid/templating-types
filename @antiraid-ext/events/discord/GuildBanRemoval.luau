local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- GuildBanRemoval
---
--- Dispatched when a user is unbanned from a guild.
---
--- Provides the user’s data and the id of the guild where the unban occurred.
local function onGuildBanRemoval(event: Primitives.Event, callback: (user: discord.UserObject, guildId: string) -> ())
    onEvent(event, "Discord.GuildBanRemoval", function(event)
        callback(event.data["GuildBanRemoval"]["unbanned_user"], event.data["GuildBanRemoval"]["guild_id"])
    end)
end 

return onGuildBanRemoval