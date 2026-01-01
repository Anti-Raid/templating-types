local Primitives = require"./primitives"

local TEMPLATE_LOOP_KEY = "__antiraid-builtins-templateloop"

export type DispatchResult = {
    type: "ok" | "err",
    id: string,
    value: any,
}

--- A manager that handles template loops for a tenant
export type TemplateLoopManager = {
    --- Update the template cache due to a modification of a template with the provided `id`.
    ---
    --- Returns the result from the templates startup code.
    updateTemplateCache: (id: string) -> {DispatchResult},

    --- Dispatch an event to all cached templates, returning the result as desired
    ---
    --- If `event` is passed, the sub-context created for each template will have the event set to it.
    ---
    --- If `targetId` is passed, the event will only be sent to the targetted id
    dispatchEvent: (ctx: Primitives.TemplateContext, event: Primitives.Event?, targetId: string?) -> {DispatchResult},

    --- Subscribe to an event, adding the system to the event's refs
    ---
    --- If `nosave` is set, the settenantstate call will not be made
    subscribeEvent: (event: string, system: string, nosave: boolean?) -> (),

    --- Unsubscribe from an event for a system, removing the system from the events ref
    --- and automatically removing the event if no systems use it anymore
    ---
    --- If `nosave` is set, the settenantstate call will not be made
    unsubscribeEvent: (event: string, system: string, nosave: boolean?) -> (),
}

--- Returns a running templateloopmanager, errors if not found
local function getRunningLoop(ctx: Primitives.TemplateContext): TemplateLoopManager
    local tlm = ctx.store[TEMPLATE_LOOP_KEY] :: TemplateLoopManager?
    if not tlm then 
        error("No running template loop manager")
    end
    return tlm
end 

return {
    getRunningLoop = getRunningLoop,
    TEMPLATE_LOOP_KEY = TEMPLATE_LOOP_KEY
}
