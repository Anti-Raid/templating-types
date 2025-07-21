local Interaction = require"@discord-types/interaction"
local InteractionCreate = require "@antiraid-ext/events/discord/InteractionCreate"
local KeyExpiry = require "@antiraid-ext/events/antiraid/KeyExpiry"
local GetSettings = require "@antiraid-ext/events/antiraid/GetSettings"
local ExecuteSetting = require "@antiraid-ext/events/antiraid/ExecuteSetting"
local Primitives = require"@antiraid-core/primitives"
local apiTypes = require"@discord-types/apiTypes"
local coretypes = require"@antiraid-ext/framework/coretypes"
local appcommands = require"@antiraid-ext/appcommands"
local interactionutils = require"@antiraid-ext/utils/interaction"
local ActionRowBuilder = require"@discord-types/builders/message/components/actionRow"
local ButtonBuilder = require"@discord-types/builders/message/components/button"
local settings = require"@antiraid-core/settings"
local getFramework = require"@antiraid-ext/framework/storage".get
local shareFramework = require"@antiraid-ext/framework/storage".share

local stingmanager = require"@antiraid-ext/utils/stingmanager"
local punishmentmanager = require"@antiraid-ext/utils/punishmentmanager"
local builtinSettingsManager = require"@antiraid-ext/utils/builtinsettingsmanager"
local userinfomanager = require"@antiraid-ext/utils/userinfo"

local function _setupFrameworkBaseData(ctx: Primitives.TemplateContext, framework: coretypes.Framework): ()
    -- Register builtins
    local data = {}
    data.templateName = ctx.data.name
    data.stingManager = stingmanager(ctx:withlimits({capabilities = {"kv[builtins.stings]:*"}}))
    data.punishmentmanager = punishmentmanager(ctx, data.stingManager)
    data.builtinSettingsManager = builtinSettingsManager(ctx)
    data.userinfomanager = userinfomanager(ctx)

    local settings: {settings.Setting} = {}
    for name, settingData in framework.base.getsettings() do 
        if settingData.dynSchema then 
            settingData.schema = settingData.dynSchema(ctx)
        end
        assert(settingData.schema, "Setting schema is required")
        settingData.schema.id = name -- Just in case...

        table.insert(settings, settingData.schema)
    end

    data.settings = settings

    framework.data = data 

    -- Share the framework with all other templates
    shareFramework(ctx, framework)
end

--- Dispatches an event to the framework.
---
--- This is the main entry point for the framework to handle events.
---
--- Currently, ``dispatch`` handles app commands, button callbacks and commands key expiration events.
---
--- @param evt Primitives.Event The event to dispatch.
--- @param ctx Primitives.TemplateContext The context to use for the event.
--- @return nil
--- @error If the framework is not set up before calling this function.
local function dispatch(evt: Primitives.Event, ctx: Primitives.TemplateContext): any 
    local framework = getFramework() or error("Framework not found! Make sure to set it up before calling Framework.dispatch!")

    if not framework.data then
        _setupFrameworkBaseData(ctx, framework) -- Perform one time setup of the framework base data
    end

    local frameworkdata = framework.data :: coretypes.BaseFrameworkData

    InteractionCreate(evt, function(interaction: apiTypes.InteractionObject)              
        if interaction.type == Interaction.InteractionType.MessageComponent then 
            if not interaction.data or not interaction.data.custom_id then 
                return
            end

            local callback: ((bcd: coretypes.ButtonCallbackData) -> nil)? = framework.getButtonCallback(interaction.data.custom_id)
            if not callback then
                local comps = nil
                local linksstore = ctx.DataStores.LinksStore 
                if linksstore then 
                    comps = {
                        ActionRowBuilder.new()
                        :addComponent(
                            ButtonBuilder.new()
                            :setStyle("Blurple")
                            :setLabel("Support Server")
                            :setUrl(linksstore.links().support_server)
                            :build()
                        )
                        :build() :: apiTypes.ComponentObjects
                    }
                end
        
                interactionutils.replySimple(
                    ctx,
                    interaction :: apiTypes.InteractionObject,
                    nil,
                    {
                        {
                            title = "Unknown button clicked!",
                            description = "Make sure that the button hasn't expired! You probably waited too long! \nIf the problem persists, **please report it to our Support Server**",
                            color = 0xFF0000,
                        }
                    } :: {apiTypes.EmbedObject},
                    true,
                    comps
                )
                return
            end

            local function removeCallback(): nil
                framework.dropButtonCallback(interaction.data.custom_id)
                return nil
            end

            callback(
                {
                    ctx = ctx,
                    interaction = interaction, 
                    removeCallback = removeCallback,
                    event = evt,
                } :: coretypes.ButtonCallbackData
            )
            return
        end

        local parsedcmd = appcommands.parseApplicationCommand(interaction)
        if not parsedcmd then return end

        local command = framework.base.getcommand(parsedcmd.nameList)
        if not command then -- Likely another template's command
            return 
        end

        if interaction.type == Interaction.InteractionType.ApplicationCommandAutocomplete then 
            if not command.autocompleter then 
                return
            end

            local autocompleteData: coretypes.AutocompleteRunData = {
                ctx = ctx,
                event = evt,
                interaction = interaction,
                stingManager = frameworkdata.stingManager,
                builtinSettingsManager = frameworkdata.builtinSettingsManager,
                command = parsedcmd,
            }

            local results = command.autocompleter(autocompleteData) or ({} :: {apiTypes.ApplicationCommandOptionChoiceObject})
            if #results > 25 then
                -- Results are limited to 25 so we need to trim the table
                local trimmedResults = {}
                for i = 1, 25 do
                    trimmedResults[i] = results[i]
                end
                results = trimmedResults
            end

            -- Send the results
            interactionutils.replyAutocomplete(
                ctx,
                interaction,
                results
            )
            return
        end

        local hasEdited = false
        local runData: coretypes.RunData = {
            ctx = ctx,
            event = evt,
            command = parsedcmd,    
            interaction = interaction,
            stingManager = frameworkdata.stingManager,
            punishmentmanager = frameworkdata.punishmentmanager,
            builtinSettingsManager = frameworkdata.builtinSettingsManager,
            userinfomanager = frameworkdata.userinfomanager,
            attachButtonCallback = framework.attachButtonCallback,
            sethasEdited = function(to: boolean): nil
                hasEdited = to
                return nil
            end,
            dropButtonCallback = framework.dropButtonCallback,
        }

        local ok, err = xpcall(command.run, debug.traceback :: any, runData)
        if not ok then 
            err = tostring(err) :: string
            if #err > 2000 then 
                -- Limit to 1997 chars and add a ... at the end
                err = err:sub(1, 1997) .. "..."
            end

            local comps = nil
            local linksstore = ctx.DataStores.LinksStore
            if linksstore then 
                comps = {
                    ActionRowBuilder.new()
                    :addComponent(
                        ButtonBuilder.new()
                        :setStyle("Blurple")
                        :setLabel("Support Server")
                        :setUrl(linksstore.links().support_server)
                        :build()
                    )
                    :build() :: apiTypes.ComponentObjects
                }
            end

            -- Check if ephemeral or nor
            local isResponseEphemeral = false

            -- Parse options
            for _, opt in parsedcmd.options do 
                if opt.name == "ephemeral" then
                    if opt.value.kind == "Boolean" then
                        isResponseEphemeral = opt.value.value
                    end
                end
            end 
            
            local embed = {
                {
                    title = "Something happened!",
                    description = "Something happened while trying to process your request. If the problem persists, **please report it to our Support Server**\n```lua\n" .. err .. "\n```",
                    color = 0xFF0000,
                }
            } :: {apiTypes.EmbedObject}

            if hasEdited then 
                interactionutils.editSimple(
                    ctx,
                    interaction,
                    nil,
                    embed,
                    comps
                )
                return
            end

            interactionutils.replySimple(
                ctx,
                interaction,
                nil,
                embed,
                isResponseEphemeral,
                comps
            )
        end
    end)

    KeyExpiry(evt, function(data)
        --error("KeyExpiry event triggered")
        for _, scope in data.scopes do 
            for _, cmd in framework.base.getcommands() do 
                local cmdR = cmd
                if cmdR.keyexpiries then
                    local fn = cmdR.keyexpiries[scope]
                    if fn then
                        fn({
                            ctx = ctx,
                            event = evt,
                            data = data,
                            stingManager = frameworkdata.stingManager,
                            punishmentmanager = frameworkdata.punishmentmanager,
                            builtinSettingsManager = frameworkdata.builtinSettingsManager,
                            userinfomanager = frameworkdata.userinfomanager,
                        })
                    end
                end
            end                
        end
    end)

    -- Handle GetSettings event
    local res = GetSettings(evt, function(_) 
        return frameworkdata.settings
    end)

    if res.isGetSettings then 
        return res.data 
    end

    -- Handle ExecuteSetting event
    res = ExecuteSetting(evt, function(data)
        local setting = framework.base.getsettings()[data.id]
        if not setting then
            error("Setting not found: " .. data.id)
        end

        if not setting.execute then
            error("Setting execute function not found: " .. data.id)
        end

        return setting.execute(data, {
            ctx = ctx,
            userinfomanager = frameworkdata.userinfomanager,
        })
    end)

    if res then return res end

    return nil
end

return {
    dispatch = dispatch,
}