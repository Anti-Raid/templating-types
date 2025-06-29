--- Some nice helpers to make building pages easy and more ergonomic

local settings = require"@antiraid-core/settings"
local toArray = require"@antiraid-ext/array".toArray

local function stringColumnType(type: "Scalar" | "Array", min_length: number?, max_length: number?, allowed_values: {string}, kind: string): settings.ColumnType
    return {
        type = type,
        inner = {
            type = "String",
            min_length = min_length,
            max_length = max_length,
            allowed_values = toArray(allowed_values),
            kind = kind    
        },
    }
end

local function integerColumnType(type: "Scalar" | "Array"): settings.ColumnType
    return {
        type = type,
        inner = {
            type = "Integer" :: "Integer"
        }
    }
end

local function floatColumnType(type: "Scalar" | "Array"): settings.ColumnType
    return {
        type = type,
        inner = {
            type = "Float" :: "Float"
        }
    }
end

local function bitFlagColumnType(type: "Scalar" | "Array", values: {[string]: number}): settings.ColumnType
    return {
        type = type,
        inner = {
            type = "BitFlag" :: "BitFlag",
            values = values
        },
    }
end

local function booleanColumnType(type: "Scalar" | "Array"): settings.ColumnType
    return {
        type = type,
        inner = {
            type = "Boolean" :: "Boolean"
        }
    }
end

local function jsonColumnType(type: "Scalar" | "Array", style: string?): settings.ColumnType
    return {
        type = type,
        inner = {
            type = "Json" :: "Json",
            style = style or "json",
        },
    }
end

local function noSuggestions(): settings.ColumnSuggestion
    return {
        type = "None"
    }
end

local function staticSuggestions(suggestions: {string}): settings.ColumnSuggestion
    return {
        type = "Static",
        suggestions = toArray(suggestions)
    }
end

-- Common fields
local function columnCreatedAt(): settings.Column 
    return {
        id = "created_at",
        name = "Created At",
        description = "The time the item was created.",
        primary_key = false,
        column_type = stringColumnType("Scalar", nil, nil, {}, "timestamp"),
        nullable = false,
        readonly = {"View", "Create", "Update", "Delete"},
        secret = false,
        suggestions = noSuggestions(),
    }
end

local function columnCreatedBy(): settings.Column 
    return {
        id = "created_by",
        name = "Created By",
        description = "The user who created the item.",
        primary_key = false,
        column_type = stringColumnType("Scalar", nil, nil, {}, "user"),
        nullable = false,
        readonly = {"View", "Create", "Update", "Delete"},
        secret = false,
        suggestions = noSuggestions(),
    }
end

local function columnLastUpdatedAt(): settings.Column 
    return {
        id = "last_updated_at",
        name = "Last Updated At",
        description = "The time the item was last updated.",
        primary_key = false,
        column_type = stringColumnType("Scalar", nil, nil, {}, "timestamp"),
        nullable = false,
        readonly = {"View", "Create", "Update", "Delete"},
        secret = false,
        suggestions = noSuggestions(),
    }
end

local function columnLastUpdatedBy(): settings.Column 
    return {
        id = "last_updated_by",
        name = "Last Updated By",
        description = "The user who last updated the item.",
        primary_key = false,
        column_type = stringColumnType("Scalar", nil, nil, {}, "user"),
        nullable = false,
        readonly = {"View", "Create", "Update", "Delete"},
        secret = false,
        suggestions = noSuggestions(),
    }
end

return {
    stringColumnType = stringColumnType,
    integerColumnType = integerColumnType,
    floatColumnType = floatColumnType,
    bitFlagColumnType = bitFlagColumnType,
    booleanColumnType = booleanColumnType,
    jsonColumnType = jsonColumnType,
    noSuggestions = noSuggestions,
    staticSuggestions = staticSuggestions,

    -- columns
    columnCreatedAt = columnCreatedAt,
    columnCreatedBy = columnCreatedBy,
    columnLastUpdatedAt = columnLastUpdatedAt,
    columnLastUpdatedBy = columnLastUpdatedBy,
}