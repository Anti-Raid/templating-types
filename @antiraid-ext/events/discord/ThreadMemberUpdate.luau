local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- ThreadMemberUpdate
---
--- Dispatched when a thread member is updated.
local function onThreadMemberUpdate(event: Primitives.Event, callback: (threadMember: discord.ThreadMemberObject) -> ())
    onEvent(event, "Discord.ThreadMemberUpdate", function(event)
        callback(event.data["ThreadMemberUpdate"]["thread_member"])
    end)
end

return onThreadMemberUpdate
