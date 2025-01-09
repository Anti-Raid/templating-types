local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- MessagePollVoteRemove
---
--- Dispatched when a user removes their vote in a poll.
local function onMessagePollVoteRemove(event: Primitives.Event, callback: (vote: discordGateway.MessagePollVoteRemove) -> ())
    onEvent(event, "Discord.MessagePollVoteRemove", function(event)
        callback(event.data["MessagePollVoteRemove"]["event"])
    end)
end

return onMessagePollVoteRemove
