local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- ReactionRemove
---
--- Dispatched when a reaction is removed from a message.
local function onReactionRemove(event: Primitives.Event, callback: (reaction: discordGateway.MessageReactionRemovePayload) -> ())
    return createTab("MESSAGE_REACTION_REMOVE", function(event)
        callback(event.data)
    end)
end

return onReactionRemove
