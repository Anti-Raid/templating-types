local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- ReactionRemove
---
--- Dispatched when a reaction is removed from a message.
local function ReactionRemove(callback: (ctx: Primitives.TemplateContext, reaction: discordGateway.MessageReactionRemovePayload) -> ())
    return createTab("MESSAGE_REACTION_REMOVE", function(ctx)
        return callback(ctx, ctx:event().data)
    end)
end

return ReactionRemove
