local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- VoiceStateUpdate
---
--- Dispatched when a user joins, leaves or moves to a voice channel.
local function onVoiceStateUpdate(event: Primitives.Event, callback: (new: discord.VoiceStateObject) -> ())
    return createTab("VOICE_STATE_UPDATE", function(event)
        callback(event.data)
    end)
end

return onVoiceStateUpdate
