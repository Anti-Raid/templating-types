local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- Resume
---
--- Dispatched when the bot resumes after being disconnected.
---
--- Note that you usually won't get this event from AntiRaid unless you're self-hosting or unusual circumstances.
local function onResume(event: Primitives.Event, callback: (data: discordGateway.ResumePayload) -> ())
    onEvent(event, "Discord.Resume", function(event)
        callback(event.data["Resume"]["event"])
    end)
end

return onResume
