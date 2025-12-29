local Primitives = require("@antiraid-core/primitives")
local createTab = require("@antiraid-ext/events/dispatch").createTab
local discordGateway = require("@discord-types/gatewayTypes")

--- WebhookUpdate
---
--- Dispatched when a channel’s webhook is updated.
local function WebhookUpdate(callback: (ctx: Primitives.TemplateContext, payload: discordGateway.WebhooksUpdatePayload) -> ())
    return createTab("WEBHOOKS_UPDATE", function(ctx)
        return callback(ctx, ctx:event().data)
    end)
end

return WebhookUpdate
