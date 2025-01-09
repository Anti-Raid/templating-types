local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- ChannelCreate
local function onChannelCreate(event: Primitives.Event, callback: (channel: discord.ChannelObject) -> ())
    onEvent(event, "Discord.ChannelCreate", function(event)
        callback(event.data["ChannelCreate"]["channel"])
    end)
end

return onChannelCreate