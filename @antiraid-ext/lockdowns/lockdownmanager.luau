local Primitives = require "@antiraid-core/primitives"
local mode = require("./mode")
local assertString = require "@antiraid-ext/settings".assertString
local kv = require "@antiraid-core/plugins/kv"
local typesext = require "@antiraid/typesext"
local datetime = require "@antiraid/datetime"

export type CreateLockdown = {
    id: string?, -- ID of the lockdown, if not provided a random one will be generated
    reason: string, -- Reason for the lockdown
    type: mode.LockdownMode, -- The type of lockdown mode to use
    data: any, -- Data specific to the lockdown mode
}

export type LockdownManager = {
    --- Returns a list of all lockdowns
    list: () -> {mode.Lockdown},
    --- Returns a lockdown by ID
    get: (id: string) -> mode.Lockdown | nil,
    --- Sets a lockdown, creating it if it does not exist
    ---
    --- Returns the ID of the lockdown
    set: (lockdown: CreateLockdown) -> mode.Lockdown,
    --- Deletes a lockdown by ID
    delete: (id: string) -> (),
}

--- A data fetcher for lockdowns.
local function LockdownManager(ctx: Primitives.TemplateContext): LockdownManager
    local self = {}

    local function _parseLockdown(item: kv.KvRecord): mode.Lockdown
        assert(item.exists, "Internal error: Lockdown item does not exist")
        local lockdownId = item.id
        local reason = assertString("reason", item.value.reason)
        local type = assertString("type", item.value.type)
        local modev = mode.getLockdownMode(type)
        local ldata = item.value.data
        local createdAt = item.created_at

        return {
            id = lockdownId,
            reason = reason,
            type = modev or mode.DummyLockdownMode,
            data = ldata,
            created_at = createdAt
        }
    end

    local function list(): {mode.Lockdown}
        local data = ctx.KV:find("%%", {"builtins.lockdowns"})

        local lockdowns = {}
        for _, item in data do
            local lockdown = _parseLockdown(item)
            table.insert(lockdowns, lockdown)
        end

        return lockdowns
    end

    local function get(id: string): mode.Lockdown | nil
        local item = ctx.KV:getrecord(id, {"builtins.lockdowns"})
        if not item or not item.exists then
            return nil
        end

        return _parseLockdown(item)
    end

    local function set(lockdown: CreateLockdown): mode.Lockdown
        local id = lockdown.id
        if not id or #id == 0 then
            id = typesext.randstring(16)
        end
        
        assert(id, "Lockdown ID cannot be empty")

        ctx.KV:set(id, {
            reason = assertString("reason", lockdown.reason),
            type = assertString("type", lockdown.type.string_form()),
            data = lockdown.data,
        }, {"builtins.lockdowns"})

        return {
            id = id,
            reason = lockdown.reason,
            type = lockdown.type,
            data = lockdown.data,
            created_at = datetime.UTC:now(), -- For now, we just use the current time
        }
    end

    local function delete(id: string)
        ctx.KV:delete(id, {"builtins.lockdowns"})
    end

    self.list = list
    self.get = get
    self.set = set
    self.delete = delete

    return self
end

return LockdownManager