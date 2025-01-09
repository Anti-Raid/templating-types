local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- ThreadUpdate
---
--- Dispatched when a thread is updated.
local function onThreadUpdate(event: Primitives.Event, callback: (old: discord.ChannelObject?, new: discord.ChannelObject) -> ())
    onEvent(event, "Discord.ThreadUpdate", function(event)
        callback(event.data["ThreadUpdate"]["old"], event.data["ThreadUpdate"]["new"])
    end)
end

return onThreadUpdate
