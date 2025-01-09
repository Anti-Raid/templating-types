local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildDelete
---
--- Dispatched when a guild is deleted.
---
--- Provides the partial data of the guild sent by discord, and the full data from the cache, if cache feature is enabled and the data is available.
---
--- The unavailable flag in the partial data determines the status of the guild. If the flag is false, the bot was removed from the guild, either by being kicked or banned. If the flag is true, the guild went offline.
local function onGuildDelete(event: Primitives.Event, callback: (incomplete: discord.UnavailableGuildObject, full: discord.GuildObject?) -> ())
    onEvent(event, "Discord.GuildDelete", function(event)
        callback(event.data["GuildDelete"]["incomplete"], event.data["GuildDelete"]["full"])
    end)
end

return onGuildDelete 