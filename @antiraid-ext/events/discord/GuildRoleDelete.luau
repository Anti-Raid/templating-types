local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildRoleDelete
---
--- Dispatched when a role is deleted in a guild.
local function onGuildRoleDelete(event: Primitives.Event, callback: (removedRoleId: string, removedRole: discord.GuildRoleObject?, guildId: string) -> ())
    onEvent(event, "Discord.GuildRoleDelete", function(event)
        callback(event.data["GuildRoleDelete"]["guild_id"], event.data["GuildRoleDelete"]["removed_role_data_if_available"], event.data["GuildRoleDelete"]["guild_id"])
    end)
end

return onGuildRoleDelete