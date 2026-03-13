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

--- A set of ID'd callbacks that can be attached (with optional expiry)
export type Callbacks<T> = {
    --- Attaches a message component callback to the framework.
    ---
    --- Note: prefer using `addwithexpiry` instead.
    read add: (id: string, callback: (ctx: T) -> ()) -> (),
    --- Attaches a message component callback to the framework with a expiry at which the callback is automatically removed
    read addwithexpiry: (id: string, callback: (ctx: T) -> (), expirein: datetime.TimeDelta) -> (),
    --- Drops a message component callback from the framework.
    read remove: (id: string) -> (),
    --- Gets a message component callback from the framework.
    read get: (id: string) -> ((ctx: T) -> ())?,
}

local function Callbacks<T>(): Callbacks<T> 
    local callbacks: {[string]: (ctx: T) -> ()} = {}

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
        add = function(id: string, cb: (ctx: T) -> ()) 
            assert(not callbacks[id], "Callback with this ID has already been registered")
            callbacks[id] = cb 
        end,
        addwithexpiry = function(id: string, cb: (ctx: T) -> (), expirein: datetime.TimeDelta)
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
    read components: Callbacks<MessageComponentContext>
}

--- Creates a base framework
local function Framework(ctx: Primitives.TemplateContext): Framework
    local loop = tloop.getRunningLoop(ctx)
    local userinfomanager = userinfomanager(ctx)
    local componentcbs = Callbacks<<MessageComponentContext>>()

    return table.freeze{
        ctx = ctx,
        userinfomanager = userinfomanager,
        loop = loop,
        components = componentcbs
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
    read updatemessage: (data: discord.InteractionCallbackData) -> nil,
    --- If the interaction is a message component, defer updating of the message the component was attached to (for interactions that take a bit more time to make initial response with)
    read deferupdatemessage: () -> nil,
    --- Sends a followup message after the interaction has already been responded to
    read createfollowup: (data: discordRestTypes.CreateFollowupMessageRequest) -> discordP.LazyMessageObject,
    --- Replies to an interaction. Either responds directly or creates a followup message as desired
    read reply: (data: InteractionReplyData) -> discordP.LazyMessageObject?
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

    return table.freeze{
        ctx = ctx,
        interaction = interaction,
        editoriginalresponse = editoriginalresponse,
        createoriginalresponse = createoriginalresponse,
        ack = ack,
        updatemessage = updatemessage,
        deferupdatemessage = deferupdatemessage,
        createfollowup = createfollowup,
        reply = reply
    }
end

--- Context for a message component interaction
export type MessageComponentContext = {
    --- The base framework
    read framework: Framework,
    --- The interaction
    read interaction: InteractionManager,
}

--- Context for a command invokation
export type CommandContext = {
    --- The base framework
    read framework: Framework,
    --- The interaction
    read interaction: InteractionManager,
    --- The parsed command data
    read command: appcommands.ParsedApplicationCommand,
}

return {
    Callbacks = Callbacks,
    Framework = Framework,
    InteractionManager = InteractionManager
}