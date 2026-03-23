local datetime = require "@antiraid/datetime"
local typesext = require"@antiraid/typesext"

export type TemplateSource = {
    read type: "custom",

    --- Name of the template
    read name: string,

    --- Template language
    read language: "luau",

    --- Template Content
    read content: typesext.MemoryVfs,

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
    read content: typesext.MemoryVfs,

    --- Whether or not the template is paused
    paused: boolean,
}

export type TemplateManager = {
    --- Returns the builtins template
    builtins: () -> Template,
    --- Returns a list of all templates. Will always include the builtins template as the first entry
    list: () -> {Template},
    --- Returns a count of the number of custom templates we have
    countcustom: () -> number,
    --- Returns a template by key. Will either return `nil` or error on non-custom templates
    getcustom: (key: string) -> Template?,
    --- Creates or updates a custom template
    setcustom: (data: CreateTemplate) -> (),
    --- Deletes a custom template
    deletecustom: (key: string) -> (),
    --- Given a template, compute the VFS to use for it
    computevfs: (template: Template) -> typesext.Vfs,
}

return {}