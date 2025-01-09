local Primitives = require("@antiraid-core/primitives")
local discord = require("@discord-types/apiTypes")
local onEvent = require("@antiraid-ext/events/dispatch").onEvent
 
--- VoiceChannelStatusUpdate
---
--- Dispatched when a user’s voice state is updated.
local function onVoiceChannelStatusUpdate(event: Primitives.Event, callback: (old: string?, status: string?, id: discord.Snowflake, guildId: discord.Snowflake) -> ())
    onEvent(event, "Discord.VoiceChannelStatusUpdate", function(event)
        callback(event.data["VoiceChannelStatusUpdate"]["old"], event.data["VoiceChannelStatusUpdate"]["status"], event.data["VoiceChannelStatusUpdate"]["id"], event.data["VoiceChannelStatusUpdate"]["guild_id"])
    end)
end

return onVoiceChannelStatusUpdate
