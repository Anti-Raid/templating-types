local Kittycat = require "@antiraid-core/kittycat"
local Primitives = require "@antiraid-core/primitives"
local Promise = require "@antiraid/promise"
local discord = require "@discord-types/apiTypes"

--- @class UserInfo
---
--- Represents a summary of a users permission related 
--- information on AntiRaid
---
--- @field discord_permissions discord.Snowflake The users discord permissions
--- @field kittycat_staff_permissions Kittycat.StaffPermissions The users kittycat staff permissions
--- @field kittycat_resolved_permissions {Kittycat.Permission} The users resolved kittycat permissions
--- @field guild_owner_id discord.Snowflake The ID of the guild owner
--- @field guild_roles {[discord.Snowflake]: discord.GuildRoleObject} The users guild roles
--- @field member_roles {discord.Snowflake} The users member roles
---
export type UserInfo = {
    discord_permissions: discord.Snowflake,
    kittycat_staff_permissions: Kittycat.StaffPermissions,
    kittycat_resolved_permissions: {Kittycat.Permission},
    guild_owner_id: discord.Snowflake,
    guild_roles: {[discord.Snowflake]: discord.GuildRoleObject},
    member_roles: {discord.Snowflake},
}

--- @class UserInfoExecutor
---
--- Allows templates to get permission-related information about a user
---
--- @field get (user_id: discord.Snowflake): Promise.LuaPromise<UserInfo> Gets the UserInfo for a user
export type UserInfoExecutor = {
    --- Gets the UserInfo for a user
    --- @param user_id discord.Snowflake The ID of the user to get the UserInfo for
    get: (user_id: discord.Snowflake) -> Promise.LuaPromise<UserInfo>,
}

local function new(token: Primitives.TemplateContext?): UserInfoExecutor
    error("Implemented internally in AntiRaid runtime!")
end

return {
    new = new
}