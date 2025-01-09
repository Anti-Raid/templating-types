local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- Ready
---
--- Dispatched when the bot is ready to start receiving events.
---
--- Note that you usually won't get this event from AntiRaid unless you're self-hosting or unusual circumstances.
local function onReady(event: Primitives.Event, callback: (data: discordGateway.ReadyPayload) -> ())
    onEvent(event, "Discord.Ready", function(event)
        callback(event.data["Ready"]["data_about_bot"])
    end)
end

return onReady
