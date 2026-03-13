local discord = require"@discord-types/apiTypes"
local Primitives = require"@antiraid-core/primitives"
local userinfomanager = require"@antiraid-ext/utils/userinfo"
local appcommands = require"@antiraid-ext/appcommands"
local tloop = require "@antiraid-core/templateloop"

--- The base context shared across all framework invokations
export type BaseContext = {
    read ctx: Primitives.TemplateContext,
    read userinfomanager: userinfomanager.UserInfoManager,
    read loop: tloop.TemplateLoopManager,
}

--- Creates a base context
local function BaseContext(ctx: Primitives.TemplateContext): BaseContext
    local loop = tloop.getRunningLoop(ctx)
    local userinfomanager = userinfomanager(ctx)

    return table.freeze{
        ctx = ctx,
        userinfomanager = userinfomanager,
        loop = loop
    }
end

export type MessageComponentContext = Context & {
    --- The underlying interaction
    read interaction: discord.InteractionObject,
}

export type CommandContext = Context & {
    read command: appcommands.ParsedApplicationCommand,
    read interaction: discord.InteractionObject,
}

return {
    BaseContext = BaseContext
}