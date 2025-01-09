local Primitives = require("@antiraid-core/primitives")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- ReactionRemoveAll
---
--- Dispatched when all reactions are removed from a message.
local function onReactionRemoveAll(event: Primitives.Event, callback: (guildId: string?, channelId: string, messageId: string) -> ())
    onEvent(event, "Discord.ReactionRemoveAll", function(event)
        callback(event.data["ReactionRemoveAll"]["guild_id"], event.data["ReactionRemoveAll"]["channel_id"], event.data["ReactionRemoveAll"]["removed_from_message_id"])
    end)
end

return onReactionRemoveAll
