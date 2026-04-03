local runtimeP = require("@antiraid-core/plugins/runtime")

-- AntiRaid primitives

-- Core types
export type u8 = number
export type u16 = number
export type u32 = number
export type u64 = number
export type i8 = number
export type i16 = number
export type i32 = number
export type i64 = number
export type f32 = number
export type f64 = number
export type bool = boolean
export type char = string
export type byte = number

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

--- TemplateContext is a struct that represents the context of a template. 
--- 
--- Stores key data including the templates data, pragma and what capabilities it should have access to. 
---
--- Passing a TemplateContext is often required when using AntiRaid plugins for getting the inner context
--- of a template.
export type TemplateContext = {
    --- @yields
    ---
    --- Performs a system call
    syscall: (self: TemplateContext, args: runtimeP.SyscallArgs) -> runtimeP.SyscallRet,

    --- The global/common store table shared across all templates within the same
    --- server
    store: {[any]: any},
}

return {}
