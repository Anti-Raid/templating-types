local Primitives = require("@antiraid-core/primitives")
local createTab = require("@antiraid-ext/events/dispatch").createTab
local discordGateway = require("@discord-types/gatewayTypes")

--- WebhookUpdate
---
--- Dispatched when a channel’s webhook is updated.
local function onWebhookUpdate(event: Primitives.Event, callback: (payload: discordGateway.WebhooksUpdatePayload) -> ())
    return createTab("WEBHOOKS_UPDATE", function(event)
        callback(event.data)
    end)
end

return onWebhookUpdate
