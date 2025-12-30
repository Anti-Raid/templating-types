local datetime = require "@antiraid/datetime"
local runtime = require"@antiraid-core/plugins/runtime"
local typesext = require"@antiraid/typesext"

export type TemplateSource = {
    read type: "custom",

    --- The key of the template attachment
    read key: string,

    --- Name of the template
    read name: string,

    --- Template language
    read language: "luau",

    --- Template Content
    read content: runtime.LazyContent,

    --- The date and time when the template was created
    read created_at: datetime.DateTime,

    --- The date and time when the template was last updated
    read last_updated_at: datetime.DateTime,
} | {
    read type: "builtins" -- This is a virtual source used to denote the 'builtins' core template. Cannot be fetched using byid or byname etc.
}

--- A Template object.
export type Template = {
    --- The ID of the template
    read id: string,

    --- The template attachment source
    read source: TemplateSource,

    --- The capabilities allowed for this template
    read allowed_caps: { string },

    --- Whether or not the template is paused
    read paused: boolean,

    --- The precomputed VFS of the template. Will be nil until computed.
    vfs: typesext.Vfs?,
}

--- A CreateTemplate object.
export type CreateTemplate = {
    --- Name of the template
    read name: string,

    --- Template language
    read language: "luau",

    --- Template Content
    read content: runtime.LazyContent,

    --- The capabilities allowed for this template
    allowed_caps: { string },

    --- Whether or not the template is paused
    paused: boolean,
}

export type TemplateManager = {
    --- Returns the builtins template
    builtins: () -> Template,
    --- Returns a list of all templates. Will always include the builtins template as the first entry
    list: () -> {Template},
    --- Returns a template by key. Will either return `nil` or error on non-custom templates
    getcustom: (key: string) -> Template?,
    --- Creates or updates a custom template (if id is set), returning the template ID
    setcustom: (key: string?, data: CreateTemplate) -> string,
    --- Deletes a custom template
    deletecustom: (key: string) -> (),
    --- Given a template, compute the VFS to use for it
    computevfs: (template: Template) -> typesext.Vfs,
}

return {}