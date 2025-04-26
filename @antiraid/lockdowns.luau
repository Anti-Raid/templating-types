local Promise = require("@antiraid/promise")
local Primitives = require "@antiraid-core/primitives"
local ExecutorScope = require "@antiraid-core/executorscope"

--[[
impl LuaUserData for CreateLockdownMode {
    fn add_fields<F: LuaUserDataFields<Self>>(fields: &mut F) {
        fields.add_field_method_get("syntax", |_, this| {
            let syntax = this.0.syntax();
            Ok(syntax.to_string())
        });
    }

    fn add_methods<M: LuaUserDataMethods<Self>>(methods: &mut M) {
        methods.add_method("to_lockdown_mode", |_, this, string_form: String| {
            let lockdown_mode = this
                .0
                .to_lockdown_mode(&string_form)
                .map_err(|e| LuaError::external(e.to_string()))?;

            Ok(lockdown_mode.map(LockdownMode))
        });

        methods.add_meta_function(LuaMetaMethod::Iter, |lua, ud: LuaAnyUserData| {
            if !ud.is::<CreateLockdownMode>() {
                return Err(mlua::Error::external("Invalid userdata type"));
            }

            create_userdata_iterator_with_fields(
                lua,
                ud,
                [
                    // Fields
                    "syntax",
                    // Methods
                    "to_lockdown_mode",
                ],
            )
        });
    }
}

pub struct LockdownMode(pub Box<(dyn lockdowns::LockdownMode + 'static)>);

impl Clone for LockdownMode {
    fn clone(&self) -> Self {
        Self(self.0.clone())
    }
}

impl LuaUserData for LockdownMode {
    fn add_fields<F: LuaUserDataFields<Self>>(fields: &mut F) {
        fields.add_field_method_get("creator", |_, this| {
            let creator = this.0.creator();
            Ok(CreateLockdownMode(creator))
        });

        fields.add_field_method_get("string_form", |_, this| {
            let string_form = this.0.string_form();
            Ok(string_form)
        });

        fields.add_field_method_get("specificity", |_, this| {
            let specificity = this.0.specificity();
            Ok(specificity)
        });
    }
}]]

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
    created_at: string,
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
    --- Applies a lockdown. 
    ---
    --- This acquires a exclusive write lock on the LockdownSet
    apply: (self: LockdownSet, lockdown_type: LockdownMode, reason: string) -> Promise.LuaPromise<LockdownAddStatus>,
    --- Removes a lockdown by ID
    ---
    --- This acquires a exclusive write lock on the LockdownSet
    remove: (self: LockdownSet, id: string) -> Promise.LuaPromise<LockdownRemoveStatus>,
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
    display_changeset: (self: LockdownTestResult, lockdown_set: LockdownSet) -> Promise.LuaPromise<string>,
    --- Tries to autofix the issues
    try_auto_fix: (self: LockdownTestResult, lockdown_set: LockdownSet) -> Promise.LuaPromise<nil>,
}, {} :: {
    --- Converts the LockdownTestResult to a error string
   __tostring: (self: LockdownTestResult) -> string 
}))

--- LockdownExecutor allows templates to list, create and delete AntiRaid lockdowns
---@class LockdownExecutor
export type LockdownExecutor = {
    --- Fetches the current lockdown set of the guild
    ---
    --- A lockdown set is the main entrypoint for viewing and applying lockdowns
    ---
    --- Needed capability: ``lockdowns:fetch_lockdown_set``
    fetch_lockdown_set: (self: LockdownExecutor) -> Promise.LuaPromise<LockdownSet>,
}

local function new(token: Primitives.TemplateContext, scope: ExecutorScope.ExecutorScope?): LockdownExecutor
    error("Implemented internally in AntiRaid runtime!")
end


local CreateQuickServerLockdown: CreateLockdownMode = {} :: CreateLockdownMode
local CreateTraditionalServerLockdown: CreateLockdownMode = {} :: CreateLockdownMode
local CreateSingleChannelLockdown: CreateLockdownMode = {} :: CreateLockdownMode
local CreateRoleLockdown: CreateLockdownMode = {} :: CreateLockdownMode

local function QuickServerLockdown(): LockdownMode
    error("Implemented internally in AntiRaid runtime!")
end

local function TraditionalServerLockdown(): LockdownMode
    error("Implemented internally in AntiRaid runtime!")
end

local function SingleChannelLockdown(channel_id: string): LockdownMode
    error("Implemented internally in AntiRaid runtime!")
end

local function RoleLockdown(role_id: string): LockdownMode
    error("Implemented internally in AntiRaid runtime!")
end


return {
    new = new,
    CreateQuickServerLockdown = CreateQuickServerLockdown,
    CreateTraditionalServerLockdown = CreateTraditionalServerLockdown,
    CreateSingleChannelLockdown = CreateSingleChannelLockdown,
    CreateRoleLockdown = CreateRoleLockdown,
    QuickServerLockdown = QuickServerLockdown,
    TraditionalServerLockdown = TraditionalServerLockdown,
    SingleChannelLockdown = SingleChannelLockdown,
    RoleLockdown = RoleLockdown,
}