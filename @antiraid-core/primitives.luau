local runtimeP = require("@antiraid-core/plugins/runtime")
local Discord = require"@antiraid-ext/system/discord"
local channel = require"@antiraid/channel"

--- An event that has been dispatched to the template. 
--- 
--- In templates, this is ``arg``.
export type Event = {
    --- The name of the event.
    name: string,
    --- The authorized author of the event.
    ---
    --- Will be nil for events that are not explicitly user-authorized (e.g. using the website)
    author: string?,
    --- The data of the event.
    data: any,
}

export type DispatchResult = {
    type: "ok" | "err",
    id: string,
    value: any,
}

export type Dispatchable = {
    --- ID of the dispatchable
    read id: string,
    --- Spawns a task to dispatch an event to this dispatchable.
    read dispatchEvent: (rootctx: TemplateContext, event: Event, stream: channel.Stream<DispatchResult>) -> (),
    --- Executes the event in the same thread (no yield)
    read runEventResult: (rootctx: TemplateContext, event: Event) -> DispatchResult,
}

export type SyscallFn = (args: runtimeP.SyscallArgs) -> runtimeP.SyscallRet

export type EventManager = {
    --- Subscribe to an event, adding the system to the event's refs
    ---
    --- If attachedop is set, the attached op will be run atomically with the event subscription
    read subscribe: (event: string, system: string, attachedop: runtimeP.StateOp?) -> (),

    --- Unsubscribe from the event loop for a system, removing the system from the events ref
    --- and automatically removing the event if no systems use it anymore
    read unsubscribe: (event: string, system: string) -> (),

    --- Returns if a system is subscribed to an event
    read isSubscribed: (event: string, system: string) -> boolean,

    --- Dispatch an event to all attached isolates, returning the result as desired
    ---
    --- If `event` is passed, the sub-context created for each template will have the event set to it.
    ---
    --- If `targetId` is passed, the event will only be sent to the targetted id
    read dispatch: (event: Event, targetId: string?) -> {DispatchResult},

    --- Attach an isolate to the loop
    read attach: (isolate: Dispatchable) -> (),

    --- Remove/detach an isolate from the loop
    read detach: (id: string) -> (),
}

--- TemplateContext is a struct that represents the key context of a template
export type TemplateContext = {
    --- @yields
    ---
    --- Performs a system call
    ---
    --- This API is low-level and should be used with care.
    read syscall: SyscallFn,

    --- Returns the current tenant state 
    read tenantstate: () -> runtimeP.TenantState,

    --- Returns the current base tenant data
    read btd: () -> runtimeP.BaseTenantData,

    --- Returns the underlying discord client wrapper
    read discord: Discord.DiscordClient,

    --- Logs a debug message
    read debug: (...any) -> (),

    --- Event manager/'loop' of the context
    read loop: EventManager,
}

return {}
