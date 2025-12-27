local Primitives = require "@antiraid-core/primitives"
local tlm = require "@antiraid-core/templateloop"

--- Returns the exact set of events the guild has subscribed to
local function getSubscribedEvents(ctx: Primitives.TemplateContext): {string}
    return ctx.Runtime:gettenantstate().events
end

--- Registers a event globally if required. Otherwise is a no-op
local function registerEvent(ctx: Primitives.TemplateContext, event: string): ()
    local runningTlm = tlm.getRunningLoop(ctx)
    local ts = runningTlm.getTenantState()
    if not table.find(ts.events, event) then 
        table.insert(ts.events, event)
        ctx.Runtime:settenantstate(ts)
    end
end

return {
    getSubscribedEvents = getSubscribedEvents,
    registerEvent = registerEvent,
}