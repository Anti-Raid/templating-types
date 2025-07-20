local coretypes = require"@self/coretypes"
local storage = require"@self/storage"
local framework = require"@self/framework"
local flowbase = require"@self/flowbase"
local simplebase = require"@self/simplebase"
local commandbuilder = require"@self/commandbuilder"
local helpers = require"@self/helpers"
local paginate = require"@self/paginate"
local dispatch = require"@self/dispatch"

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
    SimpleBase = simplebase.BaseFramework,
    Framework = framework.Framework,
    dispatch = dispatch.dispatch,

    -- Utilities
    paginate = paginate.paginate,

    -- Helpers
    CustomFramework = helpers.CustomFramework,
    SimpleFramework = helpers.SimpleFramework,
    FlowFramework = helpers.FlowFramework,
}