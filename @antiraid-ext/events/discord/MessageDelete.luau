local Primitives = require("@antiraid-core/primitives")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- MessageDelete
---
--- Dispatched when a message is deleted.
local function onMessageDelete(event: Primitives.Event, callback: (channelId: string, messageId: string, guildId: string?) -> ())
    onEvent(event, "Discord.MessageDelete", function(event)
        callback(event.data["MessageDelete"]["channel_id"], event.data["MessageDelete"]["deleted_message_id"], event.data["MessageDelete"]["guild_id"])
    end)
end

return onMessageDelete
