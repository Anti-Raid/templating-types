local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- ReactionRemove
---
--- Dispatched when a reaction is removed from a message.
local function onReactionRemove(event: Primitives.Event, callback: (reaction: discordGateway.MessageReactionRemovePayload) -> ())
    onEvent(event, "Discord.MESSAGE_REACTION_REMOVE", function(event)
        callback(event.data)
    end)
end

return onReactionRemove
