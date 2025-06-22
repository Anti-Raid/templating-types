local datetime = require "@antiraid/datetime"

--- Structure for creating new lockdown modes
export type CreateLockdownMode = {
    --- The syntax of the lockdown mode
    syntax: string,
    --- Converts the string form of the lockdown mode to a LockdownMode
    to_lockdown_mode: (self: CreateLockdownMode, string_form: string) -> LockdownMode?,
}

--- LockdownMode represents a lockdown mode
export type LockdownMode = {
    --- The syntax of the lockdown mode
    syntax: string,
    --- The creator of the lockdown mode
    creator: CreateLockdownMode,
    --- The string form of the lockdown mode
    string_form: string,
    --- The specificity of the lockdown mode
    specificity: number,
}

--- Lockdown represents a currently applied lockdown
export type Lockdown = {
    --- The ID of the lockdown.
    id: string,
    --- The reason for the lockdown.
    reason: string,
    --- The type of the lockdown in its string form
    type: LockdownMode,
    --- The data internally stored for the lockdown.
    data: any,
    --- The timestamp when the lockdown was created.
    created_at: datetime.DateTime,
}

export type GuildLockdownSettings = {
    member_roles: {string},
    require_correct_layout: boolean,
}

export type LockdownSet = {
    --- Lockdowns currently applied to the guild
    lockdowns: {Lockdown},
    --- The settings for the guild
    settings: GuildLockdownSettings,
    --- Sorts the lockdowns by specificity in descending order. Mutates the lockdowns array of the LockdownSet
    ---
    --- This acquires a exclusive write lock on the LockdownSet
    sort: (self: LockdownSet) -> (),

    --- @yields
    ---
    --- Applies a lockdown. 
    ---
    --- This acquires a exclusive write lock on the LockdownSet
    apply: (self: LockdownSet, lockdown_type: LockdownMode, reason: string) -> LockdownAddStatus,

    --- @yields
    ---
    --- Removes a lockdown by ID
    ---
    --- This acquires a exclusive write lock on the LockdownSet
    remove: (self: LockdownSet, id: string) -> LockdownRemoveStatus,
}

--- LockdownAddStatus represents the result of adding a lockdown
export type LockdownAddStatus = typeof(setmetatable({} :: {
    --- Whether or not the lockdown was added
    ok: boolean?,
    --- The error type
    type: "Ok" | "Error" | "LockdownTestFailed",
    --- If ok is true, the ID of the created lockdown
    id: string?,
    --- If type is LockdownTestFailed, the test result (which can be used to try fixing the issue automagically)
    test_result: LockdownTestResult?,
    --- The error as a string
    error: string?,
}, {} :: {
    --- Converts the LockdownAddStatus to a error string
    ---
    --- The format is unspecified and may change in the future
   __tostring: (self: LockdownAddStatus) -> string 
}))

--- LockdownRemoveStatus represents the result of removing a lockdown
export type LockdownRemoveStatus = typeof(setmetatable({} :: {
    --- Whether or not the lockdown was removed
    ok: boolean?,
    --- The error type
    type: "Ok" | "Error" | "LockdownTestFailed",
    --- If type is LockdownTestFailed, the test result (which can be used to try fixing the issue automagically)
    test_result: LockdownTestResult?,
    --- The error as a string
    error: string?,
}, {} :: {
    --- Converts the LockdownRemoveStatus to a error string
    ---
    --- The format is unspecified and may change in the future
   __tostring: (self: LockdownAddStatus) -> string 
}))

--- The result of testing a servers state prior to applying a lockdown
export type LockdownTestResult = typeof(setmetatable({} :: {
    can_apply_perfectly: boolean,
    --- The role changes needed. Type is a tuple of (Add | Remove, Permissions)
    role_changes_needed: { [string]: any }, 
    --- Other changes needed
    other_changes_needed: { string },
    --- Display the changeset, resolved with role names
    display_changeset: (self: LockdownTestResult, lockdown_set: LockdownSet) -> string,

    --- @yields
    ---
    --- Tries to autofix the issues
    try_auto_fix: (self: LockdownTestResult, lockdown_set: LockdownSet) -> nil,
}, {} :: {
    --- Converts the LockdownTestResult to a error string
   __tostring: (self: LockdownTestResult) -> string 
}))

--- LockdownExecutor allows templates to list, create and delete AntiRaid lockdowns
---@class LockdownExecutor
export type LockdownExecutor = {
    --- @yields
    --- Fetches the current lockdown set of the guild
    ---
    --- A lockdown set is the main entrypoint for viewing and applying lockdowns
    ---
    --- Needed capability: ``lockdowns:fetch_lockdown_set``
    fetch_lockdown_set: (self: LockdownExecutor) -> LockdownSet,
}

export type Plugin = {
    Client: LockdownExecutor,
    CreateQuickServerLockdown: CreateLockdownMode,
    CreateTraditionalServerLockdown: CreateLockdownMode,
    CreateSingleChannelLockdown: (channel_id: string) -> CreateLockdownMode,
    CreateRoleLockdown: (role_id: string) -> CreateLockdownMode,
    QuickServerLockdown: () -> LockdownMode,
    TraditionalServerLockdown: () -> LockdownMode,
    SingleChannelLockdown: (channel_id: string) -> LockdownMode,
    RoleLockdown: (role_id: string) -> LockdownMode,
}

return {}