local Primitives = require"./primitives"
local runtime = require"./plugins/runtime"
local isolate = require"@antiraid-ext/isolate"
local Discord = require"@antiraid-ext/system/discord"

local TEMPLATE_LOOP_KEY = "__antiraid-builtins-templateloop"

--- A manager that handles the base event loop for a tenant
export type TemplateLoopManager = {
    --- Dispatch an event to all attached isolates, returning the result as desired
    ---
    --- If `event` is passed, the sub-context created for each template will have the event set to it.
    ---
    --- If `targetId` is passed, the event will only be sent to the targetted id
    read dispatchEvent: (event: Primitives.Event, targetId: string?) -> {isolate.DispatchResult},

    --- Subscribe to an event, adding the system to the event's refs
    ---
    --- If attachedop is set, the attached op will be run atomically with the event subscription
    read subscribeEvent: (event: string, system: string, attachedop: runtime.StateOp?) -> (),

    --- Unsubscribe from the event loop for a system, removing the system from the events ref
    --- and automatically removing the event if no systems use it anymore
    read unsubscribeEvent: (event: string, system: string) -> (),

    --- Returns if a system is subscribed to an event
    read isSubscribed: (event: string, system: string) -> boolean,

    --- Debug logging
    read debugmanager: DebugManager,

    --- Base tenant data
    read btd: runtime.BaseTenantData,

    --- Attach an isolate to the loop
    read attachisolate: (isolate: isolate.Isolate) -> (),

    --- Remove/detach an isolate from the loop
    read detachisolate: (id: string) -> (),

    --- Returns the underlying discord client wrapper
    read discord: Discord.DiscordClient
}

--- Debug logging
export type DebugManager = {
    --- Logs a debug message
    read print: (...any) -> (),
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
