local blob = require"@antiraid-core/blob"

--- @param value: any
--- @return string (The YAML string representation of the value.)
--- Creates a YAML string from a value 'v'
local function toyamlstring(value: any): string
    error("Implemented internally in AntiRaid runtime!")
end

--- @param yamlstring: string (The YAML string or buffer containing the YAML data to parse.)
--- @return any (The Lua value represented by the YAML string.)
--- Parses a YAML string and returns the corresponding Lua value.
local function fromyamlstring(yamlstring: blob.BlobTaker): any
    error("Implemented internally in AntiRaid runtime!")
end

return {
    toyamlstring = toyamlstring,
    fromyamlstring = fromyamlstring
}