local apitypes = require"@discord-types/apiTypes"
local permissions = require"@discord-types/permission"
local typesext = require"@antiraid/typesext"
local set = require"@antiraid-ext/set"

--- Computes the 'base permissions' of a member
--- @param g The guild object
--- @param m The member object
--- @return number The base permissions of the member
---
--- As this uses a different algorithm from the Rust layer, the permissions returned may be different if there are bugs
local function BasePermissions(g: apitypes.GuildObject, m: apitypes.GuildMemberObject): typesext.U64
    assert(m.user, "Member must have a user object to use BasePermissions")
    assert(g.roles, "Guild must have roles to use BasePermissions")
    if g.owner_id == m.user.id then
        return permissions.PermissionsAll
    end

    -- Get everyone role of the guild
    local everyoneRole = nil
    local roleMap = {}

    for _, role in g.roles do
        roleMap[role.id] = role
        if role.id == g.id then
            everyoneRole = role
        end
    end

    local perms = typesext.U64(0)

    -- Apply everyone role
    if everyoneRole then
        perms = typesext.U64(everyoneRole.permissions)
    end

    -- Apply member roles
    for _, roleId in m.roles do
        local role = roleMap[roleId]
        if role then
            perms = typesext.bitu64.bor(perms, role.permissions)
        end
    end

    if typesext.bitu64.band(perms, permissions.Permissions.Administrator) == permissions.Permissions.Administrator then
        return permissions.PermissionsAll -- ADMINISTRATOR overrides all
    end

    return perms
end

--- Computes the permissions of a member in a channel
--- @param basePerms The base permissions of the member
--- @param g The guild object
--- @param m The member object
--- @param c The channel object
--- @return typesext.U64 The permissions of the member in the channel
local function ComputeMemberChannelOverwrites(basePerms: typesext.U64, g: apitypes.GuildObject, m: apitypes.GuildMemberObject, c: apitypes.ChannelObject): typesext.U64
    assert(m.user, "Member must have a user object to use ComputeMemberChannelOverwrites")
    if typesext.bitu64.band(basePerms, permissions.Permissions.Administrator) == permissions.Permissions.Administrator then
        return permissions.PermissionsAll -- ADMINISTRATOR overrides all
    end

    local perms = basePerms -- Start with base perms

    -- Now we have the base everyone perms, apply the rest of the perms in hierarchy order
    local everyoneOverwrite = nil
    local roleOverwrites = {}
    local memberOverwrite = nil
    for _, overwrite in c.permission_overwrites do
        if overwrite.type == permissions.OverwriteObjectTypeRole and overwrite.id == g.id then
            everyoneOverwrite = overwrite
        elseif overwrite.type == permissions.OverwriteObjectTypeRole then
            if table.find(m.roles, overwrite.id) then
                table.insert(roleOverwrites, overwrite)
            end
        elseif overwrite.type == permissions.OverwriteObjectTypeMember and overwrite.id == m.user.id then
            memberOverwrite = overwrite
        end
    end
    
    -- First, apply everyone overwrite
    if everyoneOverwrite then
        perms = typesext.bitu64.band(perms, typesext.bitu64.bnot(everyoneOverwrite.deny))
        perms = typesext.bitu64.bor(perms, everyoneOverwrite.allow)
    end

    -- Next, apply role overwrites
    local allow = typesext.U64(0)
    local deny = typesext.U64(0)
    for _, overwrite in roleOverwrites do
        allow = typesext.bitu64.bor(allow, overwrite.allow)
        deny = typesext.bitu64.bor(deny, overwrite.deny)
    end

    perms = typesext.bitu64.band(perms, typesext.bitu64.bnot(deny))
    perms = typesext.bitu64.bor(perms, allow)

    -- Finally, apply member overwrite
    if memberOverwrite then
        perms = typesext.bitu64.band(perms, typesext.bitu64.bnot(memberOverwrite.deny))
        perms = typesext.bitu64.bor(perms, memberOverwrite.allow)
    end 

    return perms
end

local function MemberChannelPerms(g: apitypes.GuildObject, m: apitypes.GuildMemberObject, c: apitypes.ChannelObject): typesext.U64
    local basePerms = BasePermissions(g, m)
    return ComputeMemberChannelOverwrites(basePerms, g, m, c)
end

--- Check if a permission u64 has a permission
--- @param perms typesext.U64 The permission u64 to check
--- @param perm typesext.U64Convertibles The permission to check for
--- @return boolean True if the permission is present, false otherwise
local function HasPermission(perms: typesext.U64, perm: typesext.U64Convertibles): boolean
    -- Check if admin
    if typesext.bitu64.band(perms, permissions.Permissions.Administrator) == permissions.Permissions.Administrator then
        return true -- ADMINISTRATOR overrides all
    end
    return typesext.bitu64.band(perms, perm) == perm
end

--- Check if a permission u64 has all permissions in a set
--- @param perms typesext.U64 The permission u64 to check
--- @param permSet set.Set<typesext.U64Convertibles> The set of permissions to check for
--- @return boolean True if all permissions are present, false otherwise
local function HasAllPermissions(perms: typesext.U64, permSet: set.Set<typesext.U64Convertibles>): boolean
    -- Check if admin
    if typesext.bitu64.band(perms, permissions.Permissions.Administrator) == permissions.Permissions.Administrator then
        return true -- ADMINISTRATOR overrides all
    end
    
    for perm in permSet do
        if typesext.bitu64.band(perms, perm) ~= perm then
            return false -- If any permission is missing, return false
        end
    end
    return true
end

return {
    BasePermissions = BasePermissions,
    ComputeMemberChannelOverwrites = ComputeMemberChannelOverwrites,
    MemberChannelPerms = MemberChannelPerms,
    HasPermission = HasPermission,
    HasAllPermissions = HasAllPermissions,
}