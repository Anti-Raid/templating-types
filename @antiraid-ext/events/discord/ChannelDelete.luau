local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- ChannelDelete
local function onChannelDelete(event: Primitives.Event, callback: (channel: discord.ChannelObject) -> ())
    return createTab("CHANNEL_DELETE", function(event)
        callback(event.data)
    end)
end

return onChannelDelete