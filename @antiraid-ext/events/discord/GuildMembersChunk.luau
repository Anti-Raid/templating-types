local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- GuildMembersChunk
---
--- Dispatched when the data for offline members was requested.
---
--- Note that this event will most likely never actually be dispatched by AntiRaid outside of self-hosting or special cases.
local function onGuildMembersChunk(event: Primitives.Event, callback: (chunk: discordGateway.GuildMembersChunkPayload) -> ())
    onEvent(event, "Discord.GuildMembersChunk", function(event)
        callback(event.data["GuildMembersChunk"]["chunk"])
    end)
end

return onGuildMembersChunk