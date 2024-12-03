local __DARKLUA_BUNDLE_MODULES

__DARKLUA_BUNDLE_MODULES = {
    cache = {},
    load = function(m)
        if not __DARKLUA_BUNDLE_MODULES.cache[m] then
            __DARKLUA_BUNDLE_MODULES.cache[m] = {
                c = __DARKLUA_BUNDLE_MODULES[m](),
            }
        end

        return __DARKLUA_BUNDLE_MODULES.cache[m].c
    end,
}

do
    function __DARKLUA_BUNDLE_MODULES.a()
        return {}
    end
end

__DARKLUA_BUNDLE_MODULES.load('a')

local args, token = ...
local isDummyEvent = args == nil or token == nil

print('Is a dummy event: ' .. tostring(isDummyEvent))

if not isDummyEvent then
    local interop = require'@antiraid/interop'

    print(interop)
end
