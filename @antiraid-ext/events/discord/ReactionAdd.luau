local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- ReactionAdd
---
--- Dispatched when a reaction is added to a message.
local function onReactionAdd(event: Primitives.Event, callback: (reaction: discord.ReactionObject) -> ())
    onEvent(event, "Discord.ReactionAdd", function(event)
        callback(event.data["ReactionAdd"]["add_reaction"])
    end)
end

return onReactionAdd
 