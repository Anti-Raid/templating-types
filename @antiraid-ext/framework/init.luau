local coretypes = require"@self/coretypes"
local storage = require"@self/storage"
local coreframework = require"@self/coreframework"

export type Framework = coretypes.Framework
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
    Framework = coreframework.Framework,
}