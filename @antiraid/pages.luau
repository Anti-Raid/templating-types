local Primitives = require "@antiraid-core/primitives"
local Promise = require "@antiraid/promise"
local ExecutorScope = require "@antiraid-core/executorscope"

--- Supported setting operations for a setting
export type SettingOperations = {
    --- @field boolean Can the setting be viewed?
    view: boolean,

    --- @field boolean Can the setting be created?
    create: boolean,

    --- @field boolean Can the setting be updated?
    update: boolean,

    --- @field boolean Can the setting be deleted?
    delete: boolean,
}

--- A suggestion for a column. Can either be a static set of suggestions or no suggestions at all.
export type ColumnSuggestion = {
    type: "None"
} | {
    type: "Static",
    suggestions: {string}
}

--- The type-specific data about a column
export type ColumnType = {
    type: "Scalar" | "Array",
    inner: "String",
    --- @field number The minimum length of the string
    min_length: number?,
    --- @field number The maximum length of the string
    max_length: number?,
    --- @field {string} The allowed values for the string (will be rendered as either a select menu or otherwise)
    ---
    --- If empty, all values are allowed.
    allowed_values: {string},
    --- @field string The kind of string this is. This will be used to determine how the string is rendered client-side.
    --- e.g. textarea, channel, user, role, kittycat-permission, uuid, interval, timestamp etc.
    kind: string
} | {
    type: "Scalar" | "Array",
    inner: "Integer"
} | {
    type: "Scalar" | "Array",
    inner: "Float"
} | {
    type: "Scalar" | "Array",
    inner: "BitFlag",
    --- @field {string} The bitflag values as a hashmap
    values: {[string]: number}
} | {
    type: "Scalar" | "Array",
    inner: "Boolean"
} | {
    type: "Scalar" | "Array",
    inner: "Json",
    --- @field The maximum size, in bytes, of the JSON object
    max_bytes: number?,
}

--- A column in a setting
export type Column = {
    --- @field string The ID of the column
    id: string,

    --- @field string The friendly name of the column
    name: string,
    
    --- @field string The description of the column
    description: string,
    
    --- @field ColumnType The type of the column
    column_type: ColumnType,

    --- @field boolean Whether or not the column is nullable
    nullable: boolean,

    --- @field ColumnSuggestion The suggestions for the column
    suggestions: ColumnSuggestion,

    --- @field boolean Whether or not the column is a secret field
    secret: boolean,

    --- @field {string} The operations for which the field should be ignored (essentially, read only)
    ---
    --- Semantics are defined by the template.
    ignored_for: {"View" | "Create" | "Update" | "Delete"}
}

export type Setting = {
    --- @field string The ID of the option
    id: string,

    --- @field string The name of the option
    name: string,
    
    --- @field string The description of the option
    description: string,

    --- @field string The primary key of the table. This *should* be present in user responses to page settings
    --- as well but this is not guaranteed and must be checked for by the template.
    primary_key: string,

    --- @field string Title template, used for the title of the embed
    title_template: string,

    --- @field {Column} The columns for this option
    columns: {Column},

    --- @field SettingOperations The supported operations for this option
    supported_operations: SettingOperations
}

export type Page = {
    --- @field string The title of the page.
    title: string,
    --- @field string The description of the page.
    description: string,
    --- @field {Setting} The settings of the page.
    settings: {Setting}
}

export type PageExecutor = {
    --- @function () -> Page
    --- Returns the current page.
    get: (self: PageExecutor) -> Promise.LuaPromise<Page?>,
    --- @function () -> Promise<void>
    --- Sets a page to be the templates page. This will overwrite any existing page if one exists.
    set: (self: PageExecutor, page: Page) -> Promise.LuaPromise<{}>,
    --- @function () -> Promise<void>
    --- Deletes the templates page. This will not delete the page itself, but will remove it from the server's list of custom pages.
    delete: (self: PageExecutor) -> Promise.LuaPromise<{}>,
}

--- Creates a new PageExecutor
local function new(token: Primitives.TemplateContext, scope: ExecutorScope.ExecutorScope?): PageExecutor
    error("Implemented internally in AntiRaid runtime!")
end

return {
    new = new,
}