local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- ReactionRemoveEmoji
---
--- Dispatched when all reactions of a specific emoji are removed from a message.
local function onReactionRemoveEmoji(event: Primitives.Event, callback: (payload: discordGateway.MessageReactionRemoveEmojiPayload) -> ())
    onEvent(event, "Discord.MESSAGE_REACTION_REMOVE_EMOJI", function(event)
        callback(event.data)
    end)
end

return onReactionRemoveEmoji
