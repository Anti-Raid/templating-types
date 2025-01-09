local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- ReactionRemove
---
--- Dispatched when a reaction is removed from a message.
local function onReactionRemove(event: Primitives.Event, callback: (reaction: discord.ReactionObject) -> ())
    onEvent(event, "Discord.ReactionRemove", function(event)
        callback(event.data["ReactionRemove"]["removed_reaction"])
    end)
end

return onReactionRemove
