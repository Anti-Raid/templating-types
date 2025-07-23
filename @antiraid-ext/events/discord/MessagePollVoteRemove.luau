local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- MessagePollVoteRemove
---
--- Dispatched when a user removes their vote in a poll.
local function onMessagePollVoteRemove(event: Primitives.Event, callback: (vote: discordGateway.MessagePollVoteRemove) -> ())
    onEvent(event, "Discord.MESSAGE_POLL_VOTE_REMOVE", function(event)
        callback(event.data)
    end)
end

return onMessagePollVoteRemove
