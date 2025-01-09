local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- ThreadCreate
---
--- Dispatched when a thread is created or the current user is added to a private thread.
local function onThreadCreate(event: Primitives.Event, callback: (thread: discord.ChannelObject, newlyCreated: boolean?) -> ())
    onEvent(event, "Discord.ThreadCreate", function(event)
        callback(event.data["ThreadCreate"]["thread"], event.data["ThreadCreate"]["newly_created"])
    end)
end

return onThreadCreate
