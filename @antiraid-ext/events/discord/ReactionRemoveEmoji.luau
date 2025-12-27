local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- ReactionRemoveEmoji
---
--- Dispatched when all reactions of a specific emoji are removed from a message.
local function onReactionRemoveEmoji(event: Primitives.Event, callback: (payload: discordGateway.MessageReactionRemoveEmojiPayload) -> ())
    return createTab("MESSAGE_REACTION_REMOVE_EMOJI", function(event)
        callback(event.data)
    end)
end

return onReactionRemoveEmoji
