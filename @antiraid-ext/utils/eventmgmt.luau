local Primitives = require "@antiraid-core/primitives"
local tlm = require "@antiraid-core/templateloop"

--- Returns the exact set of events the guild has subscribed to
local function getSubscribedEvents(ctx: Primitives.TemplateContext): {string}
    return ctx.Runtime:gettenantstate().events
end

--- Subscribe to an event, adding the system to the event's refs
local function subscribeEvent(ctx: Primitives.TemplateContext, event: string, system: string): ()
    tlm.getRunningLoop(ctx).subscribeEvent(event, system)
end

--- Unsubscribe from an event for a system, removing the system from the events ref and automatically removing the event if no systems use it anymore
local function unsubscribeEvent(ctx: Primitives.TemplateContext, event: string, system: string): ()
    tlm.getRunningLoop(ctx).unsubscribeEvent(event, system)
end

return {
    getSubscribedEvents = getSubscribedEvents,
    subscribeEvent = subscribeEvent,
    unsubscribeEvent = unsubscribeEvent,
}