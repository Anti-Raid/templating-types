local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- ReactionRemoveAll
---
--- Dispatched when all reactions are removed from a message.
local function onReactionRemoveAll(event: Primitives.Event, callback: (reaction: discordGateway.MessageReactionRemoveAllPayload) -> ())
    return createTab("MESSAGE_REACTION_REMOVE_ALL", function(event)
        callback(event.data)
    end)
end

return onReactionRemoveAll
