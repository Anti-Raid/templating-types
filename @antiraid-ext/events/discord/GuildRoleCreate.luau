local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- GuildRoleCreate
---
--- Dispatched when a role is created in a guild.
local function onGuildRoleCreate(event: Primitives.Event, callback: (role: discord.GuildRoleObject) -> ())
    onEvent(event, "Discord.GuildRoleCreate", function(event)
        callback(event.data["GuildRoleCreate"]["new"])
    end)
end

return onGuildRoleCreate