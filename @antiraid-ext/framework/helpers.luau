local SimpleBase = require"./simplebase"
local FlowBase = require"./flowbase"
local Framework = require"./framework"
local coretypes = require"./coretypes"

local function CustomFramework(base: coretypes.BaseFramework, suffix: string?, commands: {coretypes.Command}) 
    if not base or type(base) ~= "table" then
        error("Base framework must be a valid BaseFramework instance")
    end

    local self = Framework.Framework(base)

    -- Register all commands passed to the framework
    for _, command in commands do
        if command and type(command) == "table" then
            self.base.registerCommand(command)
        else
            error("Invalid command provided")
        end
    end

    return self
end

local function SimpleFramework(strict_val: boolean, suffix: string?, commands: {coretypes.Command}) 
    return CustomFramework(SimpleBase.BaseFramework(strict_val), suffix, commands)
end

local function FlowFramework(strict_val: boolean, suffix: string?, commands: {coretypes.Command}) 
    return CustomFramework(FlowBase.BaseFramework(strict_val), suffix, commands)
end

return {
    CustomFramework = CustomFramework,
    SimpleFramework = SimpleFramework,
    FlowFramework = FlowFramework,
}