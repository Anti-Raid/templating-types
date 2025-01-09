local Primitives = require("@antiraid-core/primitives")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- MessageDeleteBulk
---
--- Dispatched when multiple messages are deleted at once.
local function onMessageDeleteBulk(event: Primitives.Event, callback: (channelId: string, messageIds: {string}, guildId: string?) -> ())
    onEvent(event, "Discord.MessageDeleteBulk", function(event)
        callback(event.data["MessageDeleteBulk"]["channel_id"], event.data["MessageDeleteBulk"]["multiple_deleted_messages_ids"], event.data["MessageDeleteBulk"]["guild_id"])
    end)
end

return onMessageDeleteBulk
 