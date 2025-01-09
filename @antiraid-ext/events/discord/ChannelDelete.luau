local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- ChannelDelete
local function onChannelDelete(event: Primitives.Event, callback: (channel: discord.ChannelObject, messages: {discord.MessageObject}?) -> ())
    onEvent(event, "Discord.ChannelDelete", function(event)
        callback(event.data["ChannelDelete"]["channel"], event.data["ChannelDelete"]["messages"])
    end)
end

return onChannelDelete