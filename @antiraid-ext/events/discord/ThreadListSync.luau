local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent

--- ThreadListSync
---
--- Dispatched when the current user gains access to a thread.
local function onThreadListSync(event: Primitives.Event, callback: (data: discordGateway.ThreadListSyncPayload) -> ())
    onEvent(event, "Discord.ThreadListSync", function(event)
        callback(event.data["ThreadListSync"]["thread_list_sync"])
    end)
end

return onThreadListSync
