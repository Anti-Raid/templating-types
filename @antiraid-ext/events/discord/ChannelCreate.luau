local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- ChannelCreate
local function onChannelCreate(event: Primitives.Event, callback: (channel: discord.ChannelObject) -> ())
    return createTab("CHANNEL_CREATE", function(event)
        callback(event.data)
    end)
end

return onChannelCreate