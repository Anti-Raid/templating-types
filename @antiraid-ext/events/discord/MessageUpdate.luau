local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- MessageUpdate
---
--- Provides the message update data, as well as the actual old and new message if data is available.
local function onMessageUpdate(event: Primitives.Event, callback: (oldIfAvailable: discord.MessageObject?, new: discord.MessageObject?, evt: discordGateway.MessageUpdatePayload) -> ())
    onEvent(event, "Discord.MessageUpdate", function(event)
        callback(event.data["MessageUpdate"]["old_if_available"], event.data["MessageUpdate"]["new"], event.data["MessageUpdate"]["event"])
    end)
end

return onMessageUpdate
