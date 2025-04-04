local typesext = require "@antiraid/typesext"
local bit = typesext.bitu64

local function fromBitflag(bitflag: typesext.U64Convertibles, flags: {[string]: typesext.U64Convertibles}): {string} 
	local bf = typesext.U64(bitflag)
	local permissions = {}
	for _, permission in flags do
		if bit.band(bf, permission :: typesext.U64) == (permission :: any) then
			table.insert(permissions, flags[permission :: any])
		end
	end

	return permissions
end

return fromBitflag