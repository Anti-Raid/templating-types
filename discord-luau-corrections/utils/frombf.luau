local typesext = require "@antiraid/typesext"
local set = require"@antiraid-ext/set"
local bit = typesext.bitu64

local function fromBitflag(bitflag: typesext.U64Convertibles, flags: {[string]: typesext.U64Convertibles}): {string} 
	local bf = typesext.U64(bitflag)
	local permissions = {}
	for flag, permission in flags do
		if bit.band(bf, permission) == (permission :: any) then
			table.insert(permissions, flag)
		end
	end

	return permissions
end

local function fromBitflagToSet(bitflag: typesext.U64Convertibles, flags: {[string]: typesext.U64Convertibles}): set.Set<string> 
	local bf = typesext.U64(bitflag)
	local permissions = set.Set() :: set.Set<string>
	for flag, permission in flags do
		if bit.band(bf, permission) == (permission :: any) then
			permissions.add(flag)
		end
	end

	return permissions
end


return {
	fromBitflag = fromBitflag,
	fromBitflagToSet = fromBitflagToSet
}