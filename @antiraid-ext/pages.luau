--- Some nice helpers to make building pages easy and more ergonomic

local pages = require"@antiraid-core/plugins/pages"
local toArray = require"@antiraid-ext/array".toArray

local function stringColumnType(type: "Scalar" | "Array", min_length: number?, max_length: number?, allowed_values: {string}, kind: string): pages.ColumnType
    return {
        type = type,
        inner = "String",
        min_length = min_length,
        max_length = max_length,
        allowed_values = toArray(allowed_values),
        kind = kind
    }
end

local function integerColumnType(type: "Scalar" | "Array"): pages.ColumnType
    return {
        type = type,
        inner = "Integer"
    }
end

local function floatColumnType(type: "Scalar" | "Array"): pages.ColumnType
    return {
        type = type,
        inner = "Float"
    }
end

local function bitFlagColumnType(type: "Scalar" | "Array", values: {[string]: number}): pages.ColumnType
    return {
        type = type,
        inner = "BitFlag",
        values = values
    }
end

local function booleanColumnType(type: "Scalar" | "Array"): pages.ColumnType
    return {
        type = type,
        inner = "Boolean"
    }
end

local function jsonColumnType(type: "Scalar" | "Array", max_bytes: number?): pages.ColumnType
    return {
        type = type,
        inner = "Json",
        max_bytes = max_bytes
    }
end

local function ignoredFor(ignoredFor: {pages.OperationType}): {pages.OperationType}
    return toArray(ignoredFor)
end

local function noSuggestions(): pages.ColumnSuggestion
    return {
        type = "None"
    }
end

local function staticSuggestions(suggestions: {string}): pages.ColumnSuggestion
    return {
        type = "Static",
        suggestions = toArray(suggestions)
    }
end

local function supportedOperations(view: boolean, create: boolean, update: boolean, delete: boolean): pages.SettingOperations
    return {
        view = view,
        create = create,
        update = update,
        delete = delete
    }
end

return {
    stringColumnType = stringColumnType,
    integerColumnType = integerColumnType,
    floatColumnType = floatColumnType,
    bitFlagColumnType = bitFlagColumnType,
    booleanColumnType = booleanColumnType,
    jsonColumnType = jsonColumnType,
    ignoredFor = ignoredFor,
    noSuggestions = noSuggestions,
    staticSuggestions = staticSuggestions,
    supportedOperations = supportedOperations,
}