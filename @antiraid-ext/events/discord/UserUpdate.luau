local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- UserUpdate
--- 
--- Dispatched when the user’s data is updated.
---
--- Note that you usually won't get this event from AntiRaid unless you're self-hosting or unusual circumstances.
local function onUserUpdate(event: Primitives.Event, callback: (old: discord.UserObject?, new: discord.UserObject) -> ())
    onEvent(event, "Discord.UserUpdate", function(event)
        callback(event.data["UserUpdate"]["old_data"], event.data["UserUpdate"]["new"])
    end)
end

return onUserUpdate
