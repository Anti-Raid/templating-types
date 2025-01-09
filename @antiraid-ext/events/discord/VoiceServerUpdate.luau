local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
  
--- VoiceServerUpdate
---
--- Dispatched when a guild’s voice server was updated (or changed to another one).
---
--- Note that you usually won't get this event from AntiRaid unless you're self-hosting or unusual circumstances.
local function onVoiceServerUpdate(event: Primitives.Event, callback: (data: discordGateway.VoiceServerUpdatePayload) -> ())
    onEvent(event, "Discord.VoiceServerUpdate", function(event)
        callback(event.data["VoiceServerUpdate"]["event"])
    end)
end

return onVoiceServerUpdate
