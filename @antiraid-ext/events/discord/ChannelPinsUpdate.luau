local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- ChannelPinsUpdate
local function onChannelPinsUpdate(event: Primitives.Event, callback: (pin: discordGateway.ChannelPinsUpdatePayload) -> ())
    onEvent(event, "Discord.CHANNEL_PINS_UPDATE", function(event)
        callback(event.data)
    end)
end

return onChannelPinsUpdate