local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- PresenceUpdate
---
--- Dispatched when a user’s presence is updated (e.g off -> on).
---
--- Note that you usually won't get this event from AntiRaid unless you're self-hosting or unusual circumstances.
local function onPresenceUpdate(event: Primitives.Event, callback: (oldData: discord.PresenceObject?, newData: discord.PresenceObject) -> ())
    onEvent(event, "Discord.PresenceUpdate", function(event)
        callback(event.data["PresenceUpdate"]["old_data"], event.data["PresenceUpdate"]["new_data"])
    end)
end

return onPresenceUpdate
