local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- TypingStart
---
--- Dispatched when a user starts typing in a channel.
local function TypingStart(callback: (ctx: Primitives.TemplateContext, data: discordGateway.TypingStartPayload) -> ())
    return createTab("TYPING_START", function(ctx)
        return callback(ctx, ctx:event().data)
    end)
end

return TypingStart
