local qsl = require"./modes/quickserverlockdown"
local tsl = require"./modes/traditionalserverlockdown"
local scl = require"./modes/singlechannellockdown"
local role = require"./modes/rolelockdown"
local mode = require"./mode"

local qsl_regcallback: mode.RegistryCall = function(stringform: string): mode.LockdownMode?
    if stringform == "qsl" then
        return qsl()
    end
    return nil
end

local tsl_regcallback: mode.RegistryCall = function(stringform: string): mode.LockdownMode?
    if stringform == "tsl" then
        return tsl()
    end
    return nil
end

local scl_regcallback: mode.RegistryCall = function(stringform: string): mode.LockdownMode?
    if stringform:sub(1, 4) == "scl/" then
        local channelid = stringform:sub(5)

        -- Try converting to a number
        if not tonumber(channelid) then
            error("Invalid channel ID format in SingleChannelLockdown: " .. channelid)
        end

        return scl(channelid)
    end
    return nil
end

local role_regcallback: mode.RegistryCall = function(stringform: string): mode.LockdownMode?
    if stringform:sub(1, 5) == "role/" then
        local roleid = stringform:sub(6)

        -- Try converting to a number
        if not tonumber(roleid) then
            error("Invalid role ID format in RoleLockdown: " .. roleid)
        end

        return role(roleid)
    end
    return nil
end

local DEFAULT_REGISTRY: mode.LockdownModeRegistry = {
    qsl_regcallback,
    tsl_regcallback,
    scl_regcallback,
    role_regcallback
}

return {
    DEFAULT_REGISTRY = DEFAULT_REGISTRY,
}