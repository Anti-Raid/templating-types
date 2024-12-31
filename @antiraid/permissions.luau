local kittycat = require "@antiraid-core/kittycat"

--- Returns a Permission object from a string.
local function permission_from_string(str: string): kittycat.Permission
    return kittycat.Permission.from_string(str)
end

--- Returns a string from a Permission object.
local function permission_to_string(perm: kittycat.Permission): string
    return kittycat.Permission.__tostring(perm)
end

-- Checks if a list of permissions in Permission object form contains a specific permission.
local function has_perm(permissions: {kittycat.Permission}, permission: kittycat.Permission): boolean
    return kittycat.has_perm(permissions, permission)
end

--- Checks if a list of permissions in canonical string form contains a specific permission.
local function has_perm_str(permissions: {string}, permission: string): boolean
    return kittycat.has_perm_str(permissions, permission)
end

--- Resolves a StaffPermissions object into a list of Permission objects.
local function staff_permissions_resolve(sp: kittycat.StaffPermissions): {kittycat.Permission}
    return sp:resolve()
end

--- Checks if a list of permissions can be patched to another list of permissions.
local function check_patch_changes(manager_perms: {kittycat.Permission}, current_perms: {kittycat.Permission}, new_perms: {kittycat.Permission}): (boolean, kittycat.CheckPatchChangesError?)
    return kittycat.check_patch_changes(manager_perms, current_perms, new_perms)
end

return {
    permission_from_string = permission_from_string,
    permission_to_string = permission_to_string,
    has_perm = has_perm,
    has_perm_str = has_perm_str,
    staff_permissions_resolve = staff_permissions_resolve,
    check_patch_changes = check_patch_changes,
}