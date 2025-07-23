local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- ReactionRemoveAll
---
--- Dispatched when all reactions are removed from a message.
local function onReactionRemoveAll(event: Primitives.Event, callback: (reaction: discordGateway.MessageReactionRemoveAllPayload) -> ())
    onEvent(event, "Discord.MESSAGE_REACTION_REMOVE_ALL", function(event)
        callback(event.data)
    end)
end

return onReactionRemoveAll
