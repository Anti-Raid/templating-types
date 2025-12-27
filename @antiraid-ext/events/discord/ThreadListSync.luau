local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- ThreadListSync
---
--- Dispatched when the current user gains access to a thread.
local function onThreadListSync(event: Primitives.Event, callback: (data: discordGateway.ThreadListSyncPayload) -> ())
    return createTab("THREAD_LIST_SYNC", function(event)
        callback(event.data)
    end)
end

return onThreadListSync
