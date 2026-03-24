local discord = require"@discord-types/apiTypes"
local Kittycat = require "@antiraid-core/kittycat"
local Primitives = require "@antiraid-core/primitives"
local KeyManager = require"../keymanager"

export type GuildRolePermission = {
    position: Kittycat.PartialStaffPosition,
}

--- @class UserInfo
---
--- Represents a summary of a users permission related 
--- information on AntiRaid
---
--- @field userid discord.Snowflake The ID of the user
--- @field discord_permissions discord.Snowflake The users discord permissions
--- @field kittycat_staff_permissions Kittycat.StaffPermissions The users kittycat staff permissions
--- @field kittycat_resolved_permissions {Kittycat.Permission} The users resolved kittycat permissions
--- @field guild_owner_id discord.Snowflake The ID of the guild owner
--- @field guild_roles {[discord.Snowflake]: discord.GuildRoleObject} The users guild roles (may not be present if guildRolesNeeded is not set)
--- @field member_roles {discord.Snowflake} The users member roles
--- @field guild_permissions {Kittycat.PartialStaffPosition} The guild permissions configured on the server
export type UserInfo = {
    userid: discord.Snowflake,
    discord_permissions: discord.Snowflake,
    kittycat_staff_permissions: Kittycat.StaffPermissions,
    kittycat_resolved_permissions: {Kittycat.Permission},
    guild_owner_id: discord.Snowflake,
    guild_roles: {[discord.Snowflake]: discord.GuildRoleObject}?,
    member_roles: {discord.Snowflake},
    guild_permissions: {[discord.Snowflake]: GuildRolePermission}, 
    permission_override_entry: MemberPermissionOverrideEntry
}

--- Stage1Data is a basic collation of user info that can then be cheaply expanded into a full UserInfo object
export type Stage1Data = {
    resolvedPerms: discord.Snowflake,
    memberRoles: {discord.Snowflake},
    guildRoles: {discord.GuildRoleObject},
    guildOwnerId: discord.Snowflake,
    pathUsed: string
}

export type MemberPermissionOverrideEntry = {
    userid: discord.Snowflake,
    perm_overrides: {Kittycat.Permission},
}

--- UserInfoManager is a utility for fetching user info in a performant way
export type UserInfoManager = {
    --- Gets the Stage1Data for a user (basic collation of user info)
    --- @param user_id discord.Snowflake The ID of the user to get the UserInfo for
    --- @param interaction? discord.InteractionObject Optional interaction object to use for fetching permissions (can speed up fetching/remove unnecessary API calls)
    --- @return Stage1Data The Stage1Data for the user
    getStage1Data: (user_id: discord.Snowflake, interaction: discord.InteractionObject?) -> Stage1Data,

    --- Gets the UserInfo for a user (expansion of Stage1Data)
    --- @param user_id discord.Snowflake The ID of the user to get the UserInfo for
    --- @param interaction? discord.InteractionObject Optional interaction object to use for fetching permissions (can speed up fetching/remove unnecessary API calls)
    --- @return UserInfo The UserInfo for the user
    get: (user_id: discord.Snowflake, interaction: discord.InteractionObject?) -> UserInfo,

    --- Gets the guild permissions configured
    --- @return {Kittycat.PartialStaffPosition} The permissions globally set for the guild
    getGuildPermissions: () -> {GuildRolePermission},

    --- Returns the data of a single role
    --- @return GuildRolePermission The permissions globally set for the specific role on the guild
    getGuildPermissionForRole: (roleid: discord.Snowflake) -> GuildRolePermission?,

    --- Sets the guild permission for a position
    --- @param position Kittycat.PartialStaffPosition The position to set the permissions for
    --- @return nil
    setGuildPermission: (position: Kittycat.PartialStaffPosition) -> nil,

    --- Reorders the guild permissions for a list of roles
    --- @param reorderList { {role_id: discord.Snowflake, index: number} } The list of roles to reorder with their new indices
    --- @return nil
    applyReorder: (reorderList: { {role_id: discord.Snowflake, index: number} }) -> nil,

    --- Deletes the guild permission for a role
    --- @param roleid discord.Snowflake The ID of the role to delete the permissions
    --- @return nil
    deleteGuildPermission: (roleid: discord.Snowflake) -> nil,

    --- Gets all member permission overrides available
    ---
    --- @return {MemberPermissionOverwriteEntry} The permission overrides available on the server
    getMemberPermissionOverrides: () -> {MemberPermissionOverrideEntry},

    --- Gets the member permission overrides for a user
    --- @param userid discord.Snowflake The ID of the user to get the overrides for
    --- @return {Kittycat.Permission} The member permission overrides for the user
    getMemberPermissionOverridesForUser: (userid: discord.Snowflake) -> MemberPermissionOverrideEntry,

    --- Sets the member permission overrides for a user
    --- @param userid discord.Snowflake The ID of the user to set the overrides for
    --- @param permissions {Kittycat.Permission} The permissions to set for the user
    --- @return nil
    setMemberPermissionOverrides: (userid: discord.Snowflake, permissions: {Kittycat.Permission}) -> nil,

    --- Deletes the member permission overrides for a user
    --- @param userid discord.Snowflake The ID of the user to delete the overrides for
    --- @return nil
    deleteMemberPermissionOverrides: (userid: discord.Snowflake) -> nil,
}

type IGuildPermissions = {
    index: number,
    perms: {string}
}

type IGuildMemberPermOverrides = {string}

local function UserInfoManager(ctx: Primitives.TemplateContext): UserInfoManager
    local self = {}
    local guildperms = KeyManager<<IGuildPermissions>>(ctx, "builtins.guild_permissions")
    local guildmemberpermoverrides = KeyManager<<IGuildMemberPermOverrides>>(ctx, "builtins.guild_permissions.overrides")

    local function getGuildPermissions(): {GuildRolePermission}
        local permissionRecords = guildperms.list()

        local userPositions: {GuildRolePermission} = {}
        for _, record in permissionRecords do
            local roleId = record.key
            local index = record.value.index 
            local permissionsSet = record.value.perms

            local kittycatPermissions = table.create<<Kittycat.Permission>>(#permissionsSet)
            for _, perm in permissionsSet do
                local kittycatPerm = Kittycat.Permission.from_string(perm)
                table.insert(kittycatPermissions, kittycatPerm)
            end

            table.insert(userPositions, {
                position = {
                    id = roleId,
                    index = index,
                    perms = kittycatPermissions,
                }
            })
        end

        return userPositions
    end

    local function getGuildPermissionForRole(roleid: discord.Snowflake): GuildRolePermission?
        local record = guildperms.get(roleid)
        if not record then return nil end
        if not record.value.index or not record.value.perms then
            error("internal error: index/perms not in role")
        end

        local roleId = record.key
        local index = record.value.index 
        local permissionsSet = record.value.perms

        local kittycatPermissions = table.create<<Kittycat.Permission>>(#permissionsSet)
        for _, perm in permissionsSet do
            local kittycatPerm = Kittycat.Permission.from_string(perm)
            table.insert(kittycatPermissions, kittycatPerm)
        end

        return {
            position = {
                id = roleId,
                index = index,
                perms = kittycatPermissions,
            },
        }
    end

    local function setGuildPermission(position: Kittycat.PartialStaffPosition): nil
        assert(position.id, "Guild Role ID is required.")
        assert(position.index, "Position index is required.")
        assert(position.perms, "Position permissions are required.")

        local permsSet = {}
        for _, perm in position.perms do
            table.insert(permsSet, tostring(perm))
        end

        local data: IGuildPermissions = {
            index = position.index,
            perms = permsSet,
        }

        if guildperms.exists(position.id) then 
            guildperms.updatedata(position.id, data)
        else
            guildperms.add(data, position.id)
        end

        return nil
    end

    local function applyReorder(reorderList: { {role_id: discord.Snowflake, index: number} }): nil
        assert(reorderList, "Reorder list is required.")

        -- Ensure no repeated index/other checks
        local indexes: {[number]: boolean} = {}
        local updates: {[discord.Snowflake]: IGuildPermissions} = {}
        for _, entry in reorderList do 
            assert(entry.role_id, "Role ID is required.")
            assert(entry.index, "Index is required.")

            -- Ensure no repeated indexes
            assert(not indexes[entry.index], "index  in reorder list")
            indexes[entry.index] = true

            -- Finally check if this role already uses this ID already and if not, add to updates
            local record = guildperms.get(entry.role_id)
            if not record then error("Role with ID " .. entry.role_id .. " does not exist in guild permissions.") end
            if record.value.index == entry.index then continue end
            updates[entry.role_id] = {
                perms = record.value.perms,
                index = entry.index
            }
        end

        for roleid, entry in updates do
            guildperms.updatedata(roleid, entry)
        end

        return nil
    end

    local function deleteGuildPermission(roleid: discord.Snowflake): nil
        guildperms.remove(roleid)
        return nil
    end

    local function getMemberPermissionOverrides(): {MemberPermissionOverrideEntry} 
        local overridesList = guildmemberpermoverrides.list()

        local overrideEntries: {MemberPermissionOverrideEntry} = {}

        for _, record in overridesList do 
            local kittycatPermissions = table.create<<Kittycat.Permission>>(#record.value)
            for _, perm in record.value do
                local kittycatPerm = Kittycat.Permission.from_string(perm)
                table.insert(kittycatPermissions, kittycatPerm)
            end

            table.insert(overrideEntries, {userid = record.key, perm_overrides = kittycatPermissions})
        end

        return overrideEntries
    end

    local function getMemberPermissionOverridesForUser(userid: discord.Snowflake): MemberPermissionOverrideEntry
        local overrides = guildmemberpermoverrides.get(userid)

        if not overrides then
            return {
                userid = userid,
                perm_overrides = {},
            }
        end

        local kittycatPermissions = table.create<<Kittycat.Permission>>(#overrides.value)
        for _, perm in overrides.value do
            local kittycatPerm = Kittycat.Permission.from_string(perm)
            table.insert(kittycatPermissions, kittycatPerm)
        end

        return {
            userid = userid,
            perm_overrides = kittycatPermissions,
        }
    end

    local function setMemberPermissionOverrides(userid: discord.Snowflake, permissions: {Kittycat.Permission}): nil
        local permsSet: {string} = {}
        for _, perm in permissions do
            table.insert(permsSet, tostring(perm))
        end

        if guildmemberpermoverrides.exists(userid) then guildmemberpermoverrides.updatedata(userid, permsSet) 
        else guildmemberpermoverrides.add(permsSet, userid) end
        return nil
    end

    local function deleteMemberPermissionOverrides(userid: discord.Snowflake): nil
        guildmemberpermoverrides.remove(userid)
        return nil
    end

    --- Fast path to get Stage1Data when we have resolved permissions and member roles
    local function _getS1D_FastPath_HasResolvedAndMemberRoles(
        user_id: discord.Snowflake,
        currentPathUsed: string,
        resolvedPerms: discord.Snowflake,
        memberRoles: {discord.Snowflake}
    ): Stage1Data
        -- We still need to fetc
        local guild = ctx.Discord:get_guild().data

        assert(guild, "Guild is nil. This is a bug and should not happen.")

        return {
            resolvedPerms = resolvedPerms,
            memberRoles = memberRoles,
            guildRoles = guild.roles or error("No guild roles found. This is a bug and should not happen."), 
            guildOwnerId = guild.owner_id or error("No owner_id found. This is a bug and should not happen."),
            pathUsed = currentPathUsed .. "/fast_hramr",
        }
    end

    local function _getS1D_SlowPath(user_id: discord.Snowflake, currentPathUsed: string): Stage1Data 
        -- Slow path: we need to do a call to antiraid_get_fused_member to get the member and resolved permissions
        local fusedMember = ctx.Discord:antiraid_get_fused_member({user_id})
        local member = fusedMember.data.members[1] or error("Fused member does not have a member. This is a bug and should not happen.")
        local resolvedPerms = member.resolved_perms or error("Fused member does not have resolved permissions. This is a bug and should not happen.")
        local memberRoles = member.member.roles or error("Fused member does not have roles. This is a bug and should not happen.")
        local guild = fusedMember.data.guild or error("Fused member does not have a guild. This is a bug and should not happen.")

        local guildRoles = guild.roles or error("Interaction does not have guild roles. This is a bug and should not happen.")
            
        assert(#guildRoles > 0, "Interaction guild roles is empty. This is a bug and should not happen.")

        local guildOwnerId = guild.owner_id or error("Guild owner ID is not available. This is a bug and should not happen.")
                    
        return {
            resolvedPerms = resolvedPerms,
            memberRoles = memberRoles,
            guildRoles = guildRoles,
            guildOwnerId = guildOwnerId,
            pathUsed = currentPathUsed .. "/slow",
        }
    end

    --- @param user_id discord.Snowflake
    --- @param interaction? discord.InteractionObject
    local function getStage1Data(user_id: discord.Snowflake, interaction: discord.InteractionObject?): Stage1Data
        -- Fast path: if we have an interaction with a member on it, we can use it to get the permissions and member roles directly with zero API calls
        if interaction and interaction.member and interaction.member.user then 
            -- 3 cases here
            if interaction.member.user.id == user_id then 
                -- Fast path 1: if the interaction member is the user we are looking for, we can use the interaction member directly
                local resolvedPerms = interaction.member.permissions or error("Interaction member does not have permissions. This is a bug and should not happen.")
                local memberRoles = interaction.member.roles or error("Interaction member does not have roles. This is a bug and should not happen.")
                
                return _getS1D_FastPath_HasResolvedAndMemberRoles(
                    user_id,
                    "fast_path_1",
                    resolvedPerms,
                    memberRoles
                )
            
            else 
                -- Loop over all resolved members in the interaction to find the one matching the user ID
                local resolvedMembers = interaction.data and interaction.data.resolved and interaction.data.resolved.members

                if type(resolvedMembers) == "table" then 
                    local member = resolvedMembers[user_id]
                    if member then 
                        -- Fast path 2: if the interaction has resolved members and we find the user ID, we can use that
                        local resolvedPerms = member.permissions or error("Interaction resolved member does not have permissions. This is a bug and should not happen.")
                        local memberRoles = member.roles or error("Interaction resolved member does not have roles. This is a bug and should not happen.")

                        return _getS1D_FastPath_HasResolvedAndMemberRoles(
                            user_id,
                            "fast_path_2",
                            resolvedPerms,
                            memberRoles
                        )
                    end
                end

                -- Slow path: we need to do a call to antiraid_get_fused_member to get the member and resolved permissions
                return _getS1D_SlowPath(
                    user_id,
                    "useless_interaction"
                )
            end
        else 
            return _getS1D_SlowPath(
                user_id,
                "slow_path_no_interaction"
            )
        end
    end

    local function get(user_id: discord.Snowflake, interaction: discord.InteractionObject?): UserInfo
        local stage1Data = getStage1Data(user_id, interaction)

        local guildPerms = getGuildPermissions()

        -- Convert to hashmap
        local guildPermsMap = {}
        for _, perm in guildPerms do
            guildPermsMap[perm.position.id] = perm
        end

        local memberPositions = table.create(#guildPerms) :: {Kittycat.PartialStaffPosition}
        for _, role in stage1Data.memberRoles do
            local roleObj = guildPermsMap[role]
            if roleObj then
                table.insert(memberPositions, roleObj.position)
            end
        end

        local permOverrides = getMemberPermissionOverridesForUser(user_id)

        if stage1Data.guildOwnerId == user_id then 
            table.insert(permOverrides.perm_overrides, Kittycat.Permission.from_string("global.*"))    
        end

        local staffPerms = Kittycat.StaffPermissions.new(memberPositions, permOverrides.perm_overrides)

        local guildRolesMap = {}
        if stage1Data.guildRoles then
            for _, role in stage1Data.guildRoles do
                if not role.id then
                    continue -- Skip roles without an ID (this should be impossible)
                end
                guildRolesMap[role.id] = role
            end
        end

        return {
            userid = user_id,
            discord_permissions = stage1Data.resolvedPerms,
            kittycat_staff_permissions = staffPerms,
            kittycat_resolved_permissions = staffPerms:resolve(),
            guild_owner_id = stage1Data.guildOwnerId,
            guild_roles = guildRolesMap,
            member_roles = stage1Data.memberRoles,
            guild_permissions = guildPermsMap,
            permission_override_entry = permOverrides
        }
    end

    self.getStage1Data = getStage1Data
    self.get = get
    self.getGuildPermissions = getGuildPermissions
    self.getGuildPermissionForRole = getGuildPermissionForRole
    self.setGuildPermission = setGuildPermission
    self.applyReorder = applyReorder
    self.deleteGuildPermission = deleteGuildPermission
    self.getMemberPermissionOverrides = getMemberPermissionOverrides
    self.getMemberPermissionOverridesForUser = getMemberPermissionOverridesForUser
    self.setMemberPermissionOverrides = setMemberPermissionOverrides
    self.deleteMemberPermissionOverrides = deleteMemberPermissionOverrides

    return self
end

return UserInfoManager