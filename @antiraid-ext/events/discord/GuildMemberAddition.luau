local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- GuildMemberAddition
---
--- Dispatched when a user joins a guild.
---
--- Provides the guild’s id and the user’s member data.
local function onGuildMemberAddition(event: Primitives.Event, callback: (member: discord.GuildMemberObject) -> ())
    onEvent(event, "Discord.GuildMemberAddition", function(event)
        callback(event.data["GuildMemberAddition"]["new_member"])
    end)
end

return onGuildMemberAddition