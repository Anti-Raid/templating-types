local Primitives = require("@antiraid-core/primitives")
local discordgateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- Message
---
--- Run an event on message. This is a helper function that extracts the useful data from the event and calls the callback.
local function Message(callback: (ctx: Primitives.TemplateContext, msg: discordgateway.MessageCreatePayload) -> ())
    return createTab("MESSAGE", function(ctx)
        return callback(ctx, ctx:event().data)
    end)
end

return Message 
