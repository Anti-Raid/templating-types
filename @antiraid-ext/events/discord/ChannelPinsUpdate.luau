local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- ChannelPinsUpdate
local function onChannelPinsUpdate(event: Primitives.Event, callback: (pin: discordGateway.ChannelPinsUpdatePayload) -> ())
    return createTab("CHANNEL_PINS_UPDATE", function(event)
        callback(event.data)
    end)
end

return onChannelPinsUpdate