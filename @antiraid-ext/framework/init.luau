local coretypes = require"@self/coretypes"
local storage = require"@self/storage"
local flowbase = require"@self/flowbase"
local commandbuilder = require"@self/commandbuilder"

export type Framework = coretypes.Framework
export type BaseFramework = coretypes.BaseFramework
export type Command = coretypes.Command
export type KeyExpiryData = coretypes.KeyExpiryData
export type ButtonCallbackData = coretypes.ButtonCallbackData
export type RunData = coretypes.RunData
export type AutocompleteRunData = coretypes.AutocompleteRunData

-- Export the framework here
return {
    getFramework = storage.get,
    setFramework = storage.set,
    replaceFramework = storage.replace,

    CommandBuilder = commandbuilder,

    -- Base framework
    FlowBase = flowbase.BaseFramework,
}