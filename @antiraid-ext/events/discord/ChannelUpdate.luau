local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- ChannelUpdate
local function onChannelUpdate(event: Primitives.Event, callback: (old: discord.ChannelObject?, new: discord.ChannelObject) -> ())
    onEvent(event, "Discord.ChannelUpdate", function(event)
        callback(event.data["ChannelUpdate"]["old"], event.data["ChannelUpdate"]["new"])
    end)
end

return onChannelUpdate