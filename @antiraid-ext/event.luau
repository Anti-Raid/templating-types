local Primitives = require("@antiraid-core/primitives")
local aloha = require("@antiraid-core/@aloha/DiscordTypes")

--- Function that checks if the event matches the name.
---
--- An event matches name when its ``base_name`` or ``name`` is equal to the ``name`` argument or when ``{base_name}.{name}`` is equal to the ``name`` argument.
---
--- For example, using either ``Message`` or ``Discord.Message`` as name would match a Discord Message event.
---
--- **Note that this function is case-insensitive and internally converts all strings to lowercase.**
local function doesEventMatch(pat: string, event: Primitives.Event)
    local baseName = string.lower(event.base_name)
    local name = string.lower(event.name)
    local pattern = string.lower(pat)
    
    return baseName == pattern or name == pattern or (baseName .. "." .. name) == pattern
end

--- Simple helper method that calls ``callback`` when the event matches the name. See ``doesEventMatch`` for more information
--- on how the name is matched.
local function onEvent(event: Primitives.Event, pats: string | {string}, callback: (Primitives.Event) -> ())    
    if type(pats) == "string" then
        if doesEventMatch(pats, event) then
            return callback(event)
        end
    else
        for _, pat in ipairs(pats) do
            if doesEventMatch(pat, event) then
                return callback(event)
            end
        end
    end
end

--- Run an event on message. This is a helper function that extracts the useful data from the event and calls the callback.
local function onMessage(event: Primitives.Event, callback: (msg: aloha.MessageData, event: Primitives.Event) -> ())
    onEvent(event, "Discord.Message", function(event)
        callback(event.data["Message"]["new_message"], event)
    end)
end

--- Run an event on interaction create. This is a helper function that extracts the useful data from the event and calls the callback.
local function onInteractionCreate(event: Primitives.Event, callback: (interaction: aloha.InteractionData, event: Primitives.Event) -> ())
    onEvent(event, "Discord.InteractionCreate", function(event)
        callback(event.data["InteractionCreate"]["interaction"], event)
    end)
end

type EventHandlerImpl = {
    __index: EventHandlerImpl,
    new: () -> EventHandler,
    registerEventHandler: (self: EventHandler, string, (Primitives.Event) -> ()) -> (),
    callEventHandlers: (self: EventHandler, Primitives.Event) -> (),
}

type EventHandlerProto = {
    RegisteredEventHandlers: {
        [string]: {(Primitives.Event) -> ()}
    }
}

--- A primitive for structured event handling
local EventHandler: EventHandlerImpl = {} :: EventHandlerImpl
EventHandler.__index = EventHandler

export type EventHandler = typeof(setmetatable({} :: EventHandlerProto, {} :: EventHandlerImpl))

function EventHandler.new()
    local self = setmetatable({} :: EventHandlerProto, EventHandler)
    self.RegisteredEventHandlers = {}
    return self
end

--- Registers an event handler for the given pattern. This can be used for structured
--- event handling.
function EventHandler.registerEventHandler(self: EventHandler, pat: string, callback: (Primitives.Event) -> ())
    if self.RegisteredEventHandlers[pat] then
        table.insert(self.RegisteredEventHandlers[pat], callback)
    else
        self.RegisteredEventHandlers[pat] = { callback }
    end
end

--- Calls all registered event handlers matching the event for the given event.
function EventHandler.callEventHandlers(self: EventHandler, event: Primitives.Event)
    for pat, callbacks in pairs(self.RegisteredEventHandlers) do
        if doesEventMatch(pat, event) then
            for _, callback in ipairs(callbacks) do
                callback(event)
            end
        end
    end
end

return {
    onEvent = onEvent,
    onMessage = onMessage,
    onInteractionCreate = onInteractionCreate,
    doesEventMatch = doesEventMatch,
    EventHandler = EventHandler,
}