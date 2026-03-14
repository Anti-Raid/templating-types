--!strict
local discord = require"@discord-types/apiTypes"
local discordRestTypes = require "@discord-types/restTypes"
local Primitives = require"@antiraid-core/primitives"
local userinfomanager = require"@antiraid-ext/utils/userinfo"
local appcommands = require"@antiraid-ext/appcommands"
local tloop = require "@antiraid-core/templateloop"
local channel = require"@antiraid/channel"
local datetime = require"@antiraid/datetime"
local discordP = require"@antiraid-core/plugins/discord"
local InteractionCallbackType = require "@discord-types/interaction".InteractionCallbackType
local InteractionType = require "@discord-types/interaction".InteractionType
local errorHandler = require"@antiraid-ext/utils/errorhandle"
local ActionRowBuilder = require"@discord-types/builders/message/components/actionRow"
local ButtonBuilder = require"@discord-types/builders/message/components/button"
local array_metatable = require"@antiraid/interop".array_metatable

export type Command = {
    --- Discord command definition.
    command: discordRestTypes.CreateGuildApplicationCommandRequest,
    --- A register command to return the command definition at runtime.
    register: (() -> discordRestTypes.CreateGuildApplicationCommandRequest)?,
    --- The function that runs when the command is executed.
    run: (data: CommandContext) -> nil,
    --- The function that runs when the command is autocompleted.
    autocompleter: ((ctx: CommandAutocompleteContext) -> {discord.ApplicationCommandOptionChoiceObject})?,
}

--- A set of ID'd callbacks that can be attached (with optional expiry)
export type Callbacks<T> = {
    --- Adds to the callback list
    read add: (id: string, callback: T) -> (),
    --- Adds to the callback list with a expiry at which the callback is automatically removed
    read addwithexpiry: (id: string, callback: T, expirein: datetime.TimeDelta) -> (),
    --- Drops a callback.
    read remove: (id: string) -> (),
    --- Gets a callback from the framework.
    read get: (id: string) -> T?,
}

local function Callbacks<T>(): Callbacks<T> 
    local callbacks: {[string]: T} = {}

    local expiryhandles: {[string]: channel.KeyHandle<string>} = {}
    local delayqueue = channel.DelayChannel<<string>>()
    local expiryloopstarted = false    

    local function _expireifneeded()
        if not expiryloopstarted then
            expiryloopstarted = true
            task.spawn(function() 
                while true do 
                    local item = delayqueue:next()
                    expiryhandles[item] = nil
                    callbacks[item] = nil
                end
            end)
        end
    end


    return table.freeze{
        add = function(id: string, cb: T) 
            assert(not callbacks[id], "Callback with this ID has already been registered")
            callbacks[id] = cb 
        end,
        addwithexpiry = function(id: string, cb: T, expirein: datetime.TimeDelta)
            assert(not callbacks[id], "Callback with this ID has already been registered")
            assert(not expiryhandles[id], "Callback with this ID has already been registered")
            _expireifneeded() -- Spin up expiry loop to clean out expired callbacks
            callbacks[id] = cb
            expiryhandles[id] = delayqueue:add(id, expirein)
        end,
        remove = function(id: string) 
            callbacks[id] = nil 
            if expiryhandles[id] then 
                expiryhandles[id]:cancel() 
                expiryhandles[id] = nil
            end
        end,
        get = function(id: string) return callbacks[id] end
    }
end

--- The base framework context shared across all framework invokations
export type Framework = {
    --- The underlying template context
    read ctx: Primitives.TemplateContext,
    --- The underlying user info manager for managing user permissions
    read userinfomanager: userinfomanager.UserInfoManager,
    --- The underlying template loop manager
    read loop: tloop.TemplateLoopManager,
    --- Message component callbacks
    read components: Callbacks<(MessageComponentContext) -> nil>,
    --- Command callbacks
    read commands: Callbacks<Command>,
}

--- Creates a base framework
local function Framework(ctx: Primitives.TemplateContext): Framework
    local loop = tloop.getRunningLoop(ctx)
    local userinfomanager = userinfomanager(ctx)
    local componentcbs = Callbacks<<(MessageComponentContext) -> nil>>()
    local commandcbs = Callbacks<<Command>>()

    return table.freeze{
        ctx = ctx,
        userinfomanager = userinfomanager,
        loop = loop,
        components = componentcbs,
        commands = commandcbs
    }
end

export type InteractionReplyData = {
    content: string?,
    embeds: {discord.EmbedObject}?,       -- Adjust these to match your actual discord types
    components: {discord.ComponentObjects}?,
    allowed_mentions: discord.AllowedMentionObject?,
    flags: number?,
    tts: boolean?,
}

--- Holds a interaction and provides methods for simple manipulation of a interaction
--- (without needing to manually manage stuff like hasEdited etc.)
export type InteractionManager = {
    --- The underlying template context
    read ctx: Primitives.TemplateContext,
    --- The underlying interaction
    read interaction: discord.InteractionObject,
    --- Edits the original interaction response
    read editoriginalresponse: (data: discordRestTypes.EditWebhookMessageRequest) -> discordP.LazyMessageObject,
    --- Creates a new interaction response
    ---
    --- In most cases, you probably want `reply` which will either create or followup for you
    read createoriginalresponse: (data: discordRestTypes.CreateInteractionRequest) -> nil,
    --- Acks the original interaction response (for interactions that take a bit more time to make initial response with)
    read ack: () -> nil,
    --- If the interaction is a message component, update the message the component was attached to
    read updatemessage: (data: discord.InteractionCallbackDataEx) -> nil,
    --- If the interaction is a message component, defer updating of the message the component was attached to (for interactions that take a bit more time to make initial response with)
    read deferupdatemessage: () -> nil,
    --- Sends a followup message after the interaction has already been responded to
    read createfollowup: (data: discordRestTypes.CreateFollowupMessageRequest) -> discordP.LazyMessageObject,
    --- Replies to an interaction. Either responds directly or creates a followup message as desired
    read reply: (data: InteractionReplyData) -> discordP.LazyMessageObject?,
    --- Replies to an interaction with an error
    read replyerror: (err: errorHandler.HandledError) -> discordP.LazyMessageObject?,
    --- Replies to a autocomplete with a set of choices
    read replyautocomplete: (choices: {discord.ApplicationCommandOptionChoiceObject}) -> nil,
    --- Returns the custom id in the interaction if any
    read customid: () -> string?,
    --- Returns if the user has responded to the interaction ever.
    read responded: () -> boolean,
    --- Returns the underlying user id
    read userid: () -> string
}

--- Creates a new InteractionManager, if `inithasresponded` is true, then the InteractionManager will consider the interaction
--- as already being responded to
local function InteractionManager(ctx: Primitives.TemplateContext, interaction: discord.InteractionObject, inithasresponded: boolean?): InteractionManager 
    local hasresponded = inithasresponded or false

    local function editoriginalresponse(data: discordRestTypes.EditWebhookMessageRequest)
        assert(hasresponded, "You must first reply to a interaction before editing it")
        return ctx.Discord:edit_original_interaction_response({
            interaction_token = interaction.token,
            data = data,
        })
    end

    local function createoriginalresponse(data: discordRestTypes.CreateInteractionRequest)
        assert(not hasresponded, "You cannot create multiple original responses")
        local res = ctx.Discord:create_interaction_response({
            interaction_id = interaction.id,
            interaction_token = interaction.token,
            data = data,
        })
        hasresponded = true
        return res
    end

    local function ack() 
        return createoriginalresponse({
            type = InteractionCallbackType.DeferredChannelMessageWithSource,
        } :: discordRestTypes.CreateInteractionRequest)
    end

    local function updatemessage(data: discord.InteractionCallbackData)
        assert(interaction.type == InteractionType.MessageComponent, "interaction must be a message component")
        -- Note: This requires the interaction type to be a Message Component (Type 3)
        return createoriginalresponse({
            type = InteractionCallbackType.UpdateMessage,
            data = data,
        } :: discordRestTypes.CreateInteractionRequest)
    end

    local function deferupdatemessage()
        assert(interaction.type == InteractionType.MessageComponent, "interaction must be a message component")
        -- Note: This requires the interaction type to be a Message Component (Type 3)
        return createoriginalresponse({
            type = InteractionCallbackType.DeferredUpdateMessage,
        } :: discordRestTypes.CreateInteractionRequest)
    end

    local function createfollowup(data: discordRestTypes.CreateFollowupMessageRequest)
        assert(hasresponded, "You must first respond to the interaction before sending a followup")
        -- Note: Ensure this matches the exact method name in your Discord wrapper 
        -- (e.g., create_followup_message or execute_webhook)
        return ctx.Discord:create_followup_message({
            interaction_token = interaction.token,
            data = data,
        })
    end

    local function reply(data: InteractionReplyData): discordP.LazyMessageObject?
        if not hasresponded then
            return createoriginalresponse({
                type = InteractionCallbackType.ChannelMessageWithSource,
                data = data,
            } :: discordRestTypes.CreateInteractionRequest)
        else
            return createfollowup(data :: discordRestTypes.ExecuteWebhookRequest)
        end
    end

    local function replyerror(err: errorHandler.HandledError) 
        local comps = {
            ActionRowBuilder.new()
            :addComponent(
                ButtonBuilder.new()
                :setStyle("Blurple")
                :setLabel("Support Server")
                :setUrl(ctx.Runtime:links().support_server)
                :build()
            )
            :build()
        }
        
        local res = reply({
            embeds = {err.embed},
            components = comps :: any,
        })

        if err.traceback then
            error(err.traceback, 1)
        end

        return res
    end

    local function replyautocomplete(choices: {discord.ApplicationCommandOptionChoiceObject})
        if #choices > 25 then
            -- Results are limited to 25 so we need to trim the table
            local trimmedResults = {}
            for i = 1, 25 do
                trimmedResults[i] = choices[i]
            end
            choices = trimmedResults
        end
        
        return createoriginalresponse({
            type = InteractionCallbackType.ApplicationCommandAutocompleteResult,
            data = {
                choices = if choices then setmetatable(choices, array_metatable) else nil,
            },
        } :: discordRestTypes.CreateInteractionRequest)
    end

    local function customid() return interaction.data and interaction.data.custom_id end
    local function responded() return hasresponded end

    local function userid(): string
        return if interaction.user then interaction.user.id elseif (interaction.member and interaction.member.user) then interaction.member.user.id else error("No user found")
    end

    return table.freeze{
        ctx = ctx,
        interaction = interaction,
        editoriginalresponse = editoriginalresponse,
        createoriginalresponse = createoriginalresponse,
        ack = ack,
        updatemessage = updatemessage,
        deferupdatemessage = deferupdatemessage,
        createfollowup = createfollowup,
        reply = reply,
        replyerror = replyerror,
        customid = customid,
        replyautocomplete = replyautocomplete,
        responded = responded,
        userid = userid
    }
end

--- Context for a message component interaction
export type MessageComponentContext = {
    --- The base framework
    read framework: Framework,
    --- The interaction
    read interaction: InteractionManager,
}

local function MessageComponentContext(framework: Framework, interaction: discord.InteractionObject): MessageComponentContext
    assert(interaction.type == InteractionType.MessageComponent, "interaction must be a message component")
    return table.freeze{
        framework = framework,
        interaction = InteractionManager(framework.ctx, interaction)
    }
end

--- Context for a command invokation
export type CommandContext = {
    --- The base framework
    read framework: Framework,
    --- The interaction
    read interaction: InteractionManager,
    --- The parsed command data
    read command: appcommands.ParsedApplicationCommand,
}

local function CommandContext(framework: Framework, interaction: discord.InteractionObject, command: appcommands.ParsedApplicationCommand): CommandContext
    assert(interaction.type == InteractionType.ApplicationCommand, "interaction must be a command")
    return table.freeze{
        framework = framework,
        interaction = InteractionManager(framework.ctx, interaction),
        command = command
    }
end

--- Context for a command invokation
export type CommandAutocompleteContext = {
    --- The base framework
    read framework: Framework,
    --- The interaction
    read interaction: InteractionManager,
    --- The parsed command data
    read command: appcommands.ParsedApplicationCommand,
}

local function CommandAutocompleteContext(framework: Framework, interaction: discord.InteractionObject, command: appcommands.ParsedApplicationCommand): CommandContext
    assert(interaction.type == InteractionType.ApplicationCommand, "interaction must be a message component")
    return table.freeze{
        framework = framework,
        interaction = InteractionManager(framework.ctx, interaction),
        command = command
    }
end

return {
    Callbacks = Callbacks,
    Framework = Framework,
    InteractionManager = InteractionManager,
    MessageComponentContext = MessageComponentContext,
    CommandContext = CommandContext,
    CommandAutocompleteContext = CommandAutocompleteContext
}