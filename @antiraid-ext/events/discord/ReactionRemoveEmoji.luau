local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- ReactionRemoveEmoji
---
--- Dispatched when all reactions of a specific emoji are removed from a message.
local function onReactionRemoveEmoji(event: Primitives.Event, callback: (removedRreactions: discord.ReactionObject) -> ())
    onEvent(event, "Discord.ReactionRemoveEmoji", function(event)
        callback(event.data["ReactionRemoveEmoji"]["removed_reactions"])
    end)
end

return onReactionRemoveEmoji
