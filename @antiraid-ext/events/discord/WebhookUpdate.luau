local Primitives = require("@antiraid-core/primitives")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- WebhookUpdate
---
--- Dispatched when a channel’s webhook is updated.
local function onWebhookUpdate(event: Primitives.Event, callback: (guildId: string, belongsToChannelId: string) -> ())
    onEvent(event, "Discord.WebhookUpdate", function(event)
        callback(event.data["WebhookUpdate"]["guild_id"], event.data["WebhookUpdate"]["belongs_to_channel_id"])
    end)
end

return onWebhookUpdate
