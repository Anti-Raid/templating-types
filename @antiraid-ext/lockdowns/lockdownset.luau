local mode = require("./mode")
local handle = require("./handle")
local utils = require("./utils")
local settingsmanager = require("./settingsmanager")
local lockdownmanager = require("./lockdownmanager")
local guilddata = require("./guilddata")
local Primitives = require"@antiraid-core/primitives"

--- Represents a list of lockdowns
export type LockdownSet = {
    --- The current list of lockdowns
    lockdowns: {mode.Lockdown},
    --- Lockdown settings right now
    settings: settingsmanager.LockdownSettings,
    --- The current guild data
    guild_data: guilddata.GuildData,
    --- Applies a lockdown mode with a reason
    apply: (mode: mode.LockdownMode, reason: string) -> mode.Lockdown,
    --- Removes a lockdown by ID
    remove: (id: string) -> mode.Lockdown,
    --- Removes all lockdowns in order of specificity
    removeall: () -> (),
    --- Run the autofixer for a lockdown mode
    autofix: (mode: mode.LockdownMode) -> (),
}

--- Creates a new LockdownSet
local function LockdownSet(ctx: Primitives.TemplateContext): LockdownSet
    local self = {}

    local guild_data = guilddata.guildData(ctx)
    local lockdownmanager = lockdownmanager(ctx)
    local settingsmanager = settingsmanager(ctx)

    local lockdowns = lockdownmanager.list()
    local settings = settingsmanager.get() or settingsmanager.default()

    local criticalroles = utils.getCriticalRoles(guild_data.guild, settings.member_roles)

    -- The base lockdown mode data
    local baseLockdownModeData: mode.BaseLockdownModeData = {
        guild = guild_data.guild,
        channels = guild_data.channels,
        critical_roles = criticalroles,
        lockdowns = lockdowns,
        ctx = ctx
    }

    --- Returns a ExtLockdownModeData given handles and the lockdown
    local function _getExtLockdownModeData(lockdown: mode.Lockdown, handles: handle.LockdownModeHandles): mode.ExtLockdownModeData
        return {
            guild = guild_data.guild,
            channels = guild_data.channels,
            critical_roles = criticalroles,
            lockdowns = lockdowns,
            ctx = ctx,
            all_handles = handles,
            lockdown = lockdown
        }
    end

    local function _sort()
        table.sort(lockdowns, function(a, b)
            return a.type.specificity() > b.type.specificity()
        end)
    end

    --- Returns the handles for all lockdowns
    ---
    --- This is internal (for good reason) and may be removed/replaced with better algorithms in the future
    local function _getHandles(): handle.LockdownModeHandles 
        local handles = handle.LockdownModeHandles()

        for _, lockdown in lockdowns do 
            local handle = lockdown.type.handle(baseLockdownModeData, lockdown)

            -- Extend roles and channels
            handles.addhandle(handle, lockdown.type.specificity())
        end

        return handles
    end

    --- Adds a lockdown to the set returning the created lockdown
    local function apply(mode: mode.LockdownMode, reason: string): mode.Lockdown
        -- Test new lockdown if no_apply_test is false
        if not settings.no_apply_test then
            mode.test(baseLockdownModeData)
        end

        -- Setup the lockdown
        local data = mode.setup(baseLockdownModeData)

        -- Save the lockdown
        local createlockdown: lockdownmanager.CreateLockdown = {
            reason = reason,
            type = mode,
            data = data,
        }
        local createdlockdown = lockdownmanager.set(createlockdown)

        -- Get the current handles
        local handles = _getHandles()

        -- Apply the lockdown
        createdlockdown.type.create(
            _getExtLockdownModeData(createdlockdown, handles)
        )

        -- Add the lockdown to the list
        table.insert(lockdowns, createdlockdown)
        return createdlockdown
    end

    --- Removes a lockdown from the set
    local function remove(id: string): mode.Lockdown
        local lockdown: mode.Lockdown? = nil
        local idx: number? = nil
        for i, l in lockdowns do
            if l.id == id then
                lockdown = l
                idx = i
                break
            end
        end

        assert(lockdown, "Lockdown with ID " .. id .. " not found")
        assert(idx, "Lockdown with ID " .. id .. " not found in the list [idx not set]")

        local currenthandles = _getHandles()

        -- Remove handle from the set
        local handle = lockdown.type.handle(baseLockdownModeData, lockdown)
        currenthandles.removehandle(handle, lockdown.type.specificity())

        -- Revert the lockdown
        lockdown.type.revert(
            _getExtLockdownModeData(lockdown, currenthandles)
        )

        -- Remove the lockdown from the database
        lockdownmanager.delete(lockdown.id)

        -- Remove the lockdown from the list
        table.remove(lockdowns, idx)
        return lockdown
    end

    -- Remove all lockdowns in order of specificity
    local function removeall()
        -- Sort the lockdowns by specificity in descending order
        _sort()

        -- Remove each lockdown in order with the highest specificity first
        local ids = table.create(#lockdowns) :: {string}
        for _, lockdown in lockdowns do
            table.insert(ids, lockdown.id)
        end

        for _, id in ids do
            remove(id)
        end

        table.clear(lockdowns)
    end

    --- Run the autofixer for a lockdown mode
    local function autofix(mode: mode.LockdownMode)
        mode.autofix(baseLockdownModeData)
    end
    
    self.lockdowns = lockdowns
    self.settings = settings
    self.guild_data = guild_data
    
    -- Functions
    self.apply = apply
    self.remove = remove
    self.removeall = removeall
    self.autofix = autofix

    return self
end

return LockdownSet