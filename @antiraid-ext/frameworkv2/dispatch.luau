local dispatchutils = require"@antiraid-ext/events/dispatch"
local context = require"./context"
local LazyLoader = require"@antiraid-ext/sync/lazyload"
local InteractionCreate = require "@antiraid-ext/events/discord/InteractionCreate"
local Primitives = require"@antiraid-core/primitives"
local Interaction = require"@discord-types/interaction"
local appcommands = require"@antiraid-ext/appcommands"
local errorHandler = require"@antiraid-ext/utils/errorhandle"

type LdrType = {
    ctx: Primitives.TemplateContext,
    commands: {context.Command}
}

local frameworkldr = LazyLoader<<context.Framework, LdrType>>(function(ldr) 
    local fw = context.Framework(ldr.ctx)
    for _, command in ldr.commands do 
        fw.commands.add(command.command.name, command)
    end
    return fw
end)

--- Sets up the event dispatch table to the framework.
---
--- This is the main entry point for the framework to handle events.
---
--- Currently, ``dispatch`` handles app commands, button callbacks and commands key expiration events.
---
--- @param evt Primitives.Event The event to dispatch to
--- @param ctx Primitives.TemplateContext The context to use for the event.
--- @return nil
local function setup(commands: {context.Command}, ...: dispatchutils.EventCall)
    return dispatchutils.eventList(
        InteractionCreate(function(ctx, interaction) 
            local framework = frameworkldr.get({ctx=ctx, commands=commands})
            if interaction.type == Interaction.InteractionType.ApplicationCommand then 
                local parsedcmd = appcommands.parseApplicationCommand(interaction)
                if not parsedcmd or not #parsedcmd.nameList then return end

                local command = framework.commands.get(parsedcmd.nameList[1])
                if not command then -- Likely another template's command
                    return 
                end
                local cctx = context.CommandContext(framework, interaction, parsedcmd)
                local ok, cerr = xpcall(command.run, errorHandler.errorHandler, cctx)
                if not ok then 
                    local err = (cerr :: any) :: errorHandler.HandledError
                    cctx.interaction.replyerror(err)
                end

            elseif interaction.type == Interaction.InteractionType.MessageComponent then 
                if not interaction.data or not interaction.data.custom_id then return end
                local cb = framework.components.get(interaction.data.custom_id)
                if not cb then return end
                local mctx = context.MessageComponentContext(framework, interaction)
                local ok, cerr = xpcall(cb, errorHandler.errorHandler, mctx)
                if not ok then 
                    local err = (cerr :: any) :: errorHandler.HandledError
                    mctx.interaction.replyerror(err)
                end

            elseif interaction.type == Interaction.InteractionType.ApplicationCommandAutocomplete then
                local parsedcmd = appcommands.parseApplicationCommand(interaction)
                if not parsedcmd or not #parsedcmd.nameList then return end

                local command = framework.commands.get(parsedcmd.nameList[1])
                if not command or not command.autocompleter then -- Likely another template's command
                    return 
                end
                local cctx = context.CommandAutocompleteContext(framework, interaction, parsedcmd)
                local ok, cerr = xpcall(command.autocompleter, errorHandler.errorHandler, cctx)
                if not ok then 
                    local err = (cerr :: any) :: errorHandler.HandledError
                    if err.traceback then framework.loop.debugmanager.print(`[Framework.DispatchAutocomplete] Error in autocomplete of \`{parsedcmd.baseName}\``, err.traceback) end
                    return
                end

                local results = cerr 
                if not cctx.interaction.responded() then 
                    cctx.interaction.replyautocomplete(results)
                end

            end
        end),
        --[[
        GetSettings(function(ctx) 
            local framework = getFramework() or error("Framework not found! Make sure to set it up before calling Framework.setup!")

            if not framework.data then
                _setupFrameworkBaseData(ctx, framework) -- Perform one time setup of the framework base data
            end

            local frameworkdata = framework.data :: coretypes.BaseFrameworkData

            return frameworkdata.settings
        end),
        ExecuteSetting(function(ctx, data)
            local framework = getFramework() or error("Framework not found! Make sure to set it up before calling Framework.setup!")

            if not framework.data then
                _setupFrameworkBaseData(ctx, framework) -- Perform one time setup of the framework base data
            end

            local frameworkdata = framework.data :: coretypes.BaseFrameworkData

            local setting = framework.base.getsettings()[data.id]
            if not setting then
                return nil
            end

            if not setting.execute then
                error("Setting execute function not found: " .. data.id)
            end

            return setting.execute(data, {
                ctx = ctx,
                userinfomanager = frameworkdata.userinfomanager,
            })
        end),]]
        ...
    )
end

return setup