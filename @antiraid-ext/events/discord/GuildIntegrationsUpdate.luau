local Primitives = require("@antiraid-core/primitives")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildIntegrationsUpdate
---
--- Dispatched when a guild’s integration is added, updated or removed.
local function onGuildIntegrationsUpdate(event: Primitives.Event, callback: (guildId: string) -> ())
    onEvent(event, "Discord.GuildIntegrationsUpdate", function(event)
        callback(event.data["GuildIntegrationsUpdate"]["guild_id"])
    end)
end

return onGuildIntegrationsUpdate