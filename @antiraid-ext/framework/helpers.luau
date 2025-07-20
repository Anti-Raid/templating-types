local SimpleBase = require"@self/simplebase"
local FlowBase = require"@self/flowbase"
local Framework = require"@self/framework"
local coretypes = require"@self/coretypes"

local function CustomFramework(base: coretypes.BaseFramework, ...: {coretypes.Command}) 
    if not base or type(base) ~= "table" then
        error("Base framework must be a valid BaseFramework instance")
    end

    local self = Framework.Framework(base)

    -- Register all commands passed to the framework
    for _, command in ... do
        if command and type(command) == "table" then
            self.base.registerCommand(command)
        else
            error("Invalid command provided")
        end
    end

    return self
end

local function SimpleFramework(strict_val: boolean?, ...: {coretypes.Command}) 
    return CustomFramework(SimpleBase.BaseFramework(strict_val), ...)
end

local function FlowFramework(strict_val: boolean?, ...: {coretypes.Command}) 
    return CustomFramework(FlowBase.BaseFramework(strict_val), ...)
end

return {
    CustomFramework = CustomFramework,
    SimpleFramework = SimpleFramework,
    FlowFramework = FlowFramework,
}