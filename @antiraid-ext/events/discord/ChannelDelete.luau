local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- ChannelDelete
local function onChannelDelete(event: Primitives.Event, callback: (channel: discord.ChannelObject) -> ())
    onEvent(event, "Discord.CHANNEL_DELETE", function(event)
        callback(event.data)
    end)
end

return onChannelDelete