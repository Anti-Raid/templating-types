local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildEmojisUpdate
---
--- Dispatched when the emojis in a guild are updated.
---
--- Provides the guild’s id and the new state of the emojis in the guild.
local function onGuildEmojisUpdate(event: Primitives.Event, callback: (currentState: {[discord.Snowflake]: discord.EmojiObject}, guildId: string) -> ())
    onEvent(event, "Discord.GuildEmojisUpdate", function(event)
        callback(event.data["GuildEmojisUpdate"]["current_state"], event.data["GuildEmojisUpdate"]["guild_id"])
    end)
end

return onGuildEmojisUpdate