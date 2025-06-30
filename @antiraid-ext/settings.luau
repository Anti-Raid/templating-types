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

-- assertX functions

--- Asserts that the value is a string and returns it.
local function assertString(what: string, value: any): string
    assert(type(value) == "string", "Expected a string, got " .. type(value) .. " for " .. what)
    return value
end

--- Asserts that the value is a string and one of the choices.
local function assertStringChoices(what: string, value: any, choices: {string}): string
    assert(type(value) == "string", "Expected a string, got " .. type(value) .. " for " .. what)
    for _, choice in choices :: {string} do
        if value == choice then
            return value
        end
    end
    error("Expected one of " .. table.concat(choices, ", ") .. ", got " .. value .. " for " .. what)
end

--- Asserts that the value is an integer and returns it.
local function assertInteger(what: string, value: any): number
    assert(type(value) == "number" and value % 1 == 0, "Expected an integer, got " .. type(value) .. " for " .. what)
    return value
end

--- Asserts that the value is a float and returns it.
local function assertFloat(what: string, value: any): number
    assert(type(value) == "number", "Expected a float, got " .. type(value) .. " for " .. what)
    return value
end

--- Asserts that the value is a boolean and returns it.
local function assertBoolean(what: string, value: any): boolean
    assert(type(value) == "boolean", "Expected a boolean, got " .. type(value) .. " for " .. what)
    return value
end

--- Asserts that the value is an array of strings and returns it.
local function assertStringArray(what: string, value: any): {string}
    assert(type(value) == "table", "Expected a array of strings, got " .. type(value))
    for _, v in value :: {string} do
        assert(type(v) == "string", "Expected a string in the array, got " .. type(v))
    end
    return value
end

--- Asserts that the value is an array of integers and returns it.
local function assertIntegerArray(what: string, value: any): {number}
    assert(type(value) == "table", "Expected a array of integers, got " .. type(value))
    for _, v in value :: {number} do
        assert(type(v) == "number" and v % 1 == 0, "Expected an integer in the array, got " .. type(v))
    end
    return value
end

--- Asserts that the value is an array of floats and returns it.
local function assertFloatArray(what: string, value: any): {number}
    assert(type(value) == "table", "Expected a array of floats, got " .. type(value))
    for _, v in value :: {number} do
        assert(type(v) == "number", "Expected a float in the array, got " .. type(v))
    end
    return value
end

--- Asserts that the value is an array of booleans and returns it.
local function assertBooleanArray(what: string, value: any): {boolean}
    assert(type(value) == "table", "Expected a array of booleans, got " .. type(value))
    for _, v in value :: {boolean} do
        assert(type(v) == "boolean", "Expected a boolean in the array, got " .. type(v))
    end
    return value
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

    -- assertX functions
    assertString = assertString,
    assertStringChoices = assertStringChoices,
    assertInteger = assertInteger,
    assertFloat = assertFloat,
    assertBoolean = assertBoolean,
    assertStringArray = assertStringArray,
    assertIntegerArray = assertIntegerArray,
    assertFloatArray = assertFloatArray,
    assertBooleanArray = assertBooleanArray,
}