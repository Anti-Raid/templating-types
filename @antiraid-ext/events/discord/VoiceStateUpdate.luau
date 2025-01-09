local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- VoiceStateUpdate
---
--- Dispatched when a user joins, leaves or moves to a voice channel.
local function onVoiceStateUpdate(event: Primitives.Event, callback: (old: discord.VoiceStateObject?, new: discord.VoiceStateObject) -> ())
    onEvent(event, "Discord.VoiceStateUpdate", function(event)
        callback(event.data["VoiceStateUpdate"]["old"], event.data["VoiceStateUpdate"]["new"])
    end)
end

return onVoiceStateUpdate
