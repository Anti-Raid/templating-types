-- AntiRaid primitives, see https://docs.antiraid.xyz/user/templating/2-plugins#primitives
-- 
-- Last updated: December 3rd 2024

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

--- An event that has been dispatched to the template. 
--- 
--- In templates, this is ``arg``.
export type Event = {
    --- The title name of the event.
    title: string,
    --- The base name of the event.
    base_name: string,
    --- The name of the event.
    name: string,
    --- The data of the event.
    data: any,
    --- Whether the event can be denied.
    is_deniable: boolean,
    --- The unique identifier ID of the event. Will be guaranteed to be unique at a per-guild level.
    uid: string,
    --- The author of the event, if any. If there is no known author, this field will either be `nil` or `null`.
    author: string?
}

--- TemplatePragma contains the pragma of the template. 
--- 
--- Note that the list of fields below in non-exhaustive as templates can define extra fields on the pragma as well
export type TemplatePragma = {
    --- The language of the template.
    lang: string,
    --- The allowed capabilities provided to the template
    allowed_caps: {string},
}

--- TemplateData
export type TemplateData = {
    --- The path of the template
    ---
    --- Official docs say "template token" but this is incorrect and a known doc inaccuracy
    path: string,
    --- The pragma of the template.
    pragma: TemplatePragma,
}

--- TemplateContext is a struct that represents the context of a template. 
--- 
--- Stores data including the templates data, pragma and what capabilities it should have access to. 
---
--- Passing a TemplateContext is often required when using AntiRaid plugins for security purposes.
---
--- **NOTE THAT ALL FIELDS IN TEMPLATECONTEXT ARE READONLY AND WILL NOT CHANGE EVEN IF ATTEMPTED MUTATION
--- DOES NOT RUNTIME ERROR**
export type TemplateContext = {
    --- The data associated with the template.
    template_data: TemplateData,
}

return {}