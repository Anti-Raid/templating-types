local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- Message
---
--- Run an event on message. This is a helper function that extracts the useful data from the event and calls the callback.
local function onMessage(event: Primitives.Event, callback: (msg: discord.MessageObject) -> ())
    onEvent(event, "Discord.Message", function(event)
        callback(event.data["Message"]["new_message"])
    end)
end

return onMessage 
