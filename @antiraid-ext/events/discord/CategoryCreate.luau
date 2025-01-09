local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- CategoryCreate
local function onCategoryCreate(event: Primitives.Event, callback: (category: discord.ChannelObject) -> ())
    onEvent(event, "Discord.CategoryCreate", function(event)
        callback(event.data["CategoryCreate"]["category"])
    end)
end

return onCategoryCreate