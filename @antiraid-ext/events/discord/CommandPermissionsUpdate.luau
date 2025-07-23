local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- CommandPermissionsUpdate
local function onCommandPermissionsUpdate(event: Primitives.Event, callback: (permission: discord.GuildApplicationCommandPermissionsObject) -> ())
    onEvent(event, "Discord.APPLICATION_COMMAND_PERMISSIONS_UPDATE", function(event)
        callback(event.data)
    end)
end

return onCommandPermissionsUpdate