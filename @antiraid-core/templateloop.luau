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
    dispatchEvent: (event: Primitives.Event, targetId: string?) -> {DispatchResult},

    --- Subscribe to an event, adding the system to the event's refs
    subscribeEvent: (event: string, system: string) -> (),

    --- Unsubscribe from an event for a system, removing the system from the events ref
    --- and automatically removing the event if no systems use it anymore
    unsubscribeEvent: (event: string, system: string) -> (),

    --- Returns if a system is subscribed to an event
    isSubscribed: (event: string, system: string) -> boolean,

    --- Debug logging
    read debugmanager: DebugManager,
}

--- Debug logging
export type DebugManager = {
    --- Logs a debug message
    read print: (msg: any) -> (),
    --- Retrieves the current stdout log as an array of timestamped messages
    read stdout: () -> {string}
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
