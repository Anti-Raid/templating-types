local Primitives = require("@antiraid-core/primitives")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
local discordGateway = require("@discord-types/gatewayTypes")

--- WebhookUpdate
---
--- Dispatched when a channel’s webhook is updated.
local function onWebhookUpdate(event: Primitives.Event, callback: (payload: discordGateway.WebhooksUpdatePayload) -> ())
    onEvent(event, "Discord.WEBHOOKS_UPDATE", function(event)
        callback(event.data)
    end)
end

return onWebhookUpdate
