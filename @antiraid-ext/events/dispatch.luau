local Primitives = require("@antiraid-core/primitives")

--- Function that checks if the event matches the name.
---
--- An event matches name when its ``base_name`` or ``name`` is equal to the ``name`` argument or when ``{base_name}.{name}`` is equal to the ``name`` argument.
--- 
--- For example, using either ``Message`` or ``Discord.Message`` as name would match a Discord Message event.
---
--- **Note that this function is case-insensitive and internally converts all strings to lowercase.**
local function doesEventMatch(pat: string, event: Primitives.Event)
    local baseName = string.lower(event.base_name)
    local name = string.lower(event.name)
    local pattern = string.lower(pat)
    
    return baseName == pattern or name == pattern or (baseName .. "." .. name) == pattern
end

--- Simple helper method that calls ``callback`` when the event matches the name. See ``doesEventMatch`` for more information
--- on how the name is matched.
local function onEvent(event: Primitives.Event, pats: string | {string}, callback: (Primitives.Event) -> ())    
    if type(pats) == "string" then
        if doesEventMatch(pats, event) then
            return callback(event)
        end
    else
        for _, pat in ipairs(pats) do
            if doesEventMatch(pat, event) then
                return callback(event)
            end
        end
    end
end


return {
    doesEventMatch = doesEventMatch,
    onEvent = onEvent
}