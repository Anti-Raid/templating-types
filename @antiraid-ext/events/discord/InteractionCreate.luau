local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- InteractionCreate
---
--- Run an event on interaction create (e.g a slash command was used or a button was clicked)
local function onInteractionCreate(event: Primitives.Event, callback: (interaction: discord.InteractionObject) -> ())
    onEvent(event, "Discord.InteractionCreate", function(event)
        callback(event.data["InteractionCreate"]["interaction"])
    end)
end

return onInteractionCreate
