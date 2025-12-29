local Primitives = require("@antiraid-core/primitives")
local discordGateway = require("@discord-types/gatewayTypes")
local createTab = require("@antiraid-ext/events/dispatch").createTab
 
--- GuildBanRemoval
---
--- Dispatched when a user is unbanned from a guild.
---
--- Provides the user’s data and the id of the guild where the unban occurred.
local function GuildBanRemoval(callback: (ctx: Primitives.TemplateContext, user: discordGateway.GuildBanRemovePayload) -> ())
    return createTab("GUILD_BAN_REMOVE", function(ctx)
        return callback(ctx, ctx:event().data)
    end)
end 

return GuildBanRemoval