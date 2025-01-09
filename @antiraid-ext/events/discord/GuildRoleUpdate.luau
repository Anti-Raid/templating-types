local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildRoleUpdate
---
--- Dispatched when a role is updated in a guild.
local function onGuildRoleUpdate(event: Primitives.Event, callback: (oldIfAvailable: discord.GuildRoleObject?, new: discord.GuildRoleObject) -> ())
    onEvent(event, "Discord.GuildRoleUpdate", function(event)
        callback(event.data["GuildRoleUpdate"]["old_data_if_available"], event.data["GuildRoleUpdate"]["new"])
    end)
end

return onGuildRoleUpdate