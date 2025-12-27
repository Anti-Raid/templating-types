local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- CommandPermissionsUpdate
local function onCommandPermissionsUpdate(event: Primitives.Event, callback: (permission: discord.GuildApplicationCommandPermissionsObject) -> ())
    return createTab("APPLICATION_COMMAND_PERMISSIONS_UPDATE", function(event)
        callback(event.data)
    end)
end

return onCommandPermissionsUpdate