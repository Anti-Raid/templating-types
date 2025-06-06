--!nocheck
-- -- Does not type under new type solver yet

--[[
	Implementation of discords Permissions as a Luau builder.	

	https://discord.com/developers/docs/topics/permissions#permissions
]]

local permissionTypes = require("@discord-types/permission")

local typesext = require("@antiraid/typesext")

local Permission = {}

Permission.Prototype = {}
Permission.Interface = {}

--[[
	set the bitflag for this builder.
]]
function Permission.Prototype.setPermissionBitflag(self: Permission, bitflag: typesext.U64Convertibles): Permission
	local ok, numberRepresentation = pcall(typesext.U64, bitflag)

	assert(ok, `Bitflag must be a number or a string representation of a number.`)

	self.bitflag = numberRepresentation :: typesext.U64

	return self
end

--[[
	add a specific permission to this permissions builder.
]]
function Permission.Prototype.addPermission(self: Permission, permission: permissionTypes.Permissions): Permission
	table.insert(self.addedPermissions, permission)

	return self
end

--[[
	remove a specific permission to this permissions builder.
]]
function Permission.Prototype.removePermission(self: Permission, permission: permissionTypes.Permissions): Permission
	table.insert(self.removedPermissions, permission)

	return self
end

--[[
	Returns the bitflag representation of the permission.
]]
function Permission.Prototype.build(self: Permission): JSON
	local bitflag = self.bitflag

	for _, permission in self.addedPermissions do
		bitflag = typesext.bitu64.bor(bitflag, permissionTypes[permission])
	end

	for _, permission in self.removedPermissions do
		bitflag = typesext.bitu64.band(bitflag, typesext.bitu64.bnot(permissionTypes[permission]))
	end

	return tostring(bitflag)
end

--[[
	Responsible for creating a new Permission.

	```lua
	
	```
]]
function Permission.Interface.new(resource: {
	bitflag: (string | number)?,
}?): Permission
	local self = setmetatable(
		{
			addedPermissions = {},
			removedPermissions = {},
		} :: Permission,
		{
			__index = Permission.Prototype,
		}
	)

	if resource then
		if resource.bitflag then
			self:setPermissionBitflag(resource.bitflag)
		end
	end

	return self
end

--[[
	Enables you to create a permission builder from a list of permissions.
]]
function Permission.Interface.fromPermissions(permissions: { permissionTypes.Permissions }): Permission
	local bitflag = 0

	for _, permission in permissions do
		bitflag = typesext.bitu64.bor(bitflag, permissionTypes[permission])
	end

	return Permission.Interface.new({
		bitflag = bitflag,
	})
end

export type Permission = typeof(Permission.Prototype) & {
	bitflag: typesext.U64,
	addedPermissions: { permissionTypes.Permissions },
	removedPermissions: { permissionTypes.Permissions },
}

export type JSON = typeof(Permission.Prototype.build(nil :: any))

return Permission.Interface
