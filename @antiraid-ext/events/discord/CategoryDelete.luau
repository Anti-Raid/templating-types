local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- CategoryDelete
local function onCategoryDelete(event: Primitives.Event, callback: (category: discord.ChannelObject) -> ())
    onEvent(event, "Discord.CategoryDelete", function(event)
        callback(event.data["CategoryDelete"]["category"])
    end)
end

return onCategoryDelete