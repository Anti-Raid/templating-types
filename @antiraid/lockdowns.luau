local Promise = require("@antiraid/promise")
local Primitives = require "@antiraid-core/primitives"

--- Lockdown represents a currently applied lockdown
---@class Lockdown
---@field id string The ID of the lockdown.
---@field reason string The reason for the lockdown.
---@field type string The type of the lockdown in its string form
---@field data string The data internally stored for the lockdown.
---@field created_at string The timestamp when the lockdown was created.
export type Lockdown = {
    id: string,
    reason: string,
    type: string,
    data: any,
    created_at: string,
}

--- LockdownExecutor allows templates to list, create and delete AntiRaid lockdowns
---@class LockdownExecutor
export type LockdownExecutor = {
    --- Lists all active lockdowns
    --- @return Promise.LuaPromise<{Lockdown}> The active lockdowns
    list: (self: LockdownExecutor) -> Promise.LuaPromise<{Lockdown}>,
    --- Starts a quick server lockdown
    --- @param reason string The reason for the lockdown
    qsl: (self: LockdownExecutor, reason: string) -> Promise.LuaPromise<nil>,
    --- Starts a traditional server lockdown.
    --- 
    --- This is *much* slower than a QSL but also does not require
    --- any special server setup.
    --- @param reason string The reason for the lockdown
    tsl: (self: LockdownExecutor, reason: string) -> Promise.LuaPromise<nil>,
    --- Starts a lockdown on a single channel
    --- @param channel_id string The ID of the channel to lock down
    --- @param reason string The reason for the lockdown
    scl: (self: LockdownExecutor, channel_id: string, reason: string) -> Promise.LuaPromise<nil>,
    --- Starts a lockdown on a role
    --- @param role_id string The ID of the role to lock down
    --- @param reason string The reason for the lockdown
    role: (self: LockdownExecutor, role_id: string, reason: string) -> Promise.LuaPromise<nil>,
    --- Removes a lockdown (ends it)
    --- @param id string The ID of the lockdown to remove
    remove: (self: LockdownExecutor, id: string) -> Promise.LuaPromise<nil>,
}

local function new(token: Primitives.TemplateContext?): LockdownExecutor
    error("Implemented internally in AntiRaid runtime!")
end

return {
    new = new
}