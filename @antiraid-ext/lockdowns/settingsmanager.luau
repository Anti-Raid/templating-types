local Primitives = require "@antiraid-core/primitives"
local assertStringArray = require "@antiraid-ext/settings".assertStringArray
local assertBoolean = require "@antiraid-ext/settings".assertBoolean

--- Stores common/persistent data required for lockdowns
export type LockdownSettings = {
    member_roles: {string},
    --- Whether or not lockdown tests should pass or not
    no_apply_test: boolean,
}

export type LockdownSettingsManager = {
    get: () -> LockdownSettings | nil,
    set: (settings: LockdownSettings) -> (),
    delete: () -> (),
    default: () -> LockdownSettings,
}

--- A settings manager for the lockdown settings.
local function LockdownSettingsManager(ctx: Primitives.TemplateContext): LockdownSettingsManager
    local self = {}

    local function get(): LockdownSettings | nil
        local data = ctx.KV:get("lockdown_settings", {"builtins.lockdown_settings"})

        if not data then
            return nil
        end

        local memberRoles = data.member_roles or {}
        local noApplyTest = data.no_apply_test or false

        local memberRolesStringArr = assertStringArray("member_roles", memberRoles)
        local noApplyTestBool = assertBoolean("no_apply_test", noApplyTest)

        return {
            member_roles = memberRolesStringArr,
            no_apply_test = noApplyTestBool,
        }
    end

    local function set(settings: LockdownSettings)
        local memberRoles = assertStringArray("member_roles", settings.member_roles)
        local noApplyTest = assertBoolean("no_apply_test", settings.no_apply_test)

        ctx.KV:set("lockdown_settings", {
            member_roles = memberRoles,
            no_apply_test = noApplyTest,
        }, {"builtins.lockdown_settings"})
    end

    local function delete()
        ctx.KV:delete("lockdown_settings", {"builtins.lockdown_settings"})
    end

    local function default(): LockdownSettings
        return {
            member_roles = {},
            no_apply_test = false,
        }
    end

    self.get = get
    self.set = set
    self.delete = delete
    self.default = default

    return self
end

return LockdownSettingsManager