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
    inner: InnerColumnType,
}

export type InnerColumnType = {
    type: "String",
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
    type: "Integer",
} | {
    type: "Float",
} | {
    type: "BitFlag",
    --- @field {string} The bitflag values as a hashmap
    values: {[string]: number}
} | {
    type: "Boolean",
} | {
    type: "Json",
    --- @field Style to use when rendering the JSON object
    style: string
}

export type OperationType = "View" | "Create" | "Update" | "Delete"

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

    --- @field string Is this column a primary key? This can be used when rendering the column in the UI.
    primary_key: boolean,

    --- @field boolean Whether or not the column is nullable
    nullable: boolean,

    --- @field ColumnSuggestion The suggestions for the column
    suggestions: ColumnSuggestion,

    --- @field boolean Whether or not the column is a secret field
    secret: boolean,

    --- @field {string} The operations for which the field should be ignored (essentially, read only)
    ---
    --- Semantics are defined by the template.
    readonly: {OperationType}
}

export type Setting = {
    --- @field string The ID of the option
    id: string,

    --- @field string The name of the option
    name: string,
    
    --- @field string The description of the option
    description: string,

    --- @field string Title template, used for the title of the embed
    title_template: string,

    --- @field {Column} The columns for this option
    columns: {Column},

    --- @field SettingOperations The supported operations for this option
    operations: {OperationType},
}

return {}