local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- ReactionAdd
---
--- Dispatched when a reaction is added to a message.
local function onReactionAdd(event: Primitives.Event, callback: (reaction: discordGateway.MessageReactionAddPayload) -> ())
    onEvent(event, "Discord.MESSAGE_REACTION_ADD", function(event)
        callback(event.data)
    end)
end

return onReactionAdd
 