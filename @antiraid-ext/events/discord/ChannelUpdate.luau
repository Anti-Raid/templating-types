local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- ChannelUpdate
local function onChannelUpdate(event: Primitives.Event, callback: (channel: discord.ChannelObject) -> ())
    onEvent(event, "Discord.CHANNEL_UPDATE", function(event)
        callback(event.data)
    end)
end

return onChannelUpdate