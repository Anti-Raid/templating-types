local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- ChannelUpdate
local function onChannelUpdate(event: Primitives.Event, callback: (channel: discord.ChannelObject) -> ())
    return createTab("CHANNEL_UPDATE", function(event)
        callback(event.data)
    end)
end

return onChannelUpdate