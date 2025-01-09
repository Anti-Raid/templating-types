local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- GuildStickersUpdate
---
--- Dispatched when the stickers in a guild are updated.
local function onGuildStickersUpdate(event: Primitives.Event, callback: (currentState: {[discord.Snowflake]: discord.StickerObject}, guildId: string) -> ())
    onEvent(event, "Discord.GuildStickersUpdate", function(event)
        callback(event.data["GuildStickersUpdate"]["current_state"], event.data["GuildStickersUpdate"]["guild_id"])
    end)
end

return onGuildStickersUpdate
 