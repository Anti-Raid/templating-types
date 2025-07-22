local Primitives = require "@antiraid-core/primitives"
local interop = require "@antiraid/interop"

--- Returns the exact set of events that builtins has access to
local function getSubscribedEvents(ctx: Primitives.TemplateContext): {string}
    return ctx.data.events
end

local function _cloneTableDespiteMetatable(t: {string}): {string} 
    local newTable = {}
    for _, v in t do
        table.insert(newTable, v)
    end
    setmetatable(newTable, interop.array_metatable)
    return newTable
end

--- Registers a event
local function registerEvent(ctx: Primitives.TemplateContext, event: string): ()
    local found = false
    for _, ev in ctx.data.events do
        if ev == event then
            found = true
            break
        end
    end

    if found then return end -- Already registered

    local ts = ctx.DataStores.TemplateStore
    if not ts then
        error("TemplateStore not found in context data")
    end

    local template = ts.get(ctx.data.name)

    if not template and ctx.data.name == "$builtins" then 
        -- Builtins special case: The template may not be on DB
        local events = _cloneTableDespiteMetatable(ctx.data.events)
        table.insert(events, event)
        ts.create({
            name = ctx.data.name,
            events = events,
            error_channel = ctx.data.error_channel,
            content = {},
            language = ctx.data.lang,
            allowed_caps = ctx.data.allowed_caps,
            paused = false,
        })
        return
    end

    assert(template, "Template not found in TemplateStore")

    local events = _cloneTableDespiteMetatable(template.events)
    table.insert(events, event)

    ts.update({
        name = ctx.data.name,
        events = events,
        error_channel = template.error_channel,
        content = template.content,
        language = template.language,
        allowed_caps = template.allowed_caps,
        paused = template.paused,
    })
end

return {
    getSubscribedEvents = getSubscribedEvents,
    registerEvent = registerEvent,
}