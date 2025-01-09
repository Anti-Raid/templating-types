local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- ThreadDelete
---
--- Dispatched when a thread is deleted.
---
--- Provides the partial data about the deleted thread and, if it was present in the cache before its deletion, its full data.
local function onThreadDelete(event: Primitives.Event, callback: (thread: discord.ChannelObject, full: discord.ChannelObject?) -> ())
    onEvent(event, "Discord.ThreadDelete", function(event)
        callback(event.data["ThreadDelete"]["thread"], event.data["ThreadDelete"]["full_thread_data"])
    end)
end

return onThreadDelete
