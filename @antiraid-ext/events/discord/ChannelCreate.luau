local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- ChannelCreate
local function onChannelCreate(event: Primitives.Event, callback: (channel: discord.ChannelObject) -> ())
    onEvent(event, "Discord.CHANNEL_CREATE", function(event)
        callback(event.data)
    end)
end

return onChannelCreate