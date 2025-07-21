local coretypes = require"./coretypes"
local Primitives = require"@antiraid-core/primitives"

local SHARED_FRAMEWORK_KEY = "__antiraid-ext-sharedFrameworks"
local globalFramework: coretypes.Framework?  = nil -- Upvalue to store the framework

--- Returns the current framework instance if it exists.
--- If it does not exist, returns nil.
local function get(): coretypes.Framework? 
    return globalFramework
end 

--- Sets the framework instance.
--- If it is already set, it will throw an error.
local function set(framework: coretypes.Framework)
    if not framework then
        error("Framework cannot be nil")
    end
    if globalFramework then
        error("Framework is already set")
    end

    globalFramework = framework
end

--- Replaces any current framework instance with a new one.
--- Unlike set, this does not throw an error if the framework is already set.
local function replace(newFramework: coretypes.Framework)
    if not newFramework then
        error("New framework cannot be nil")
    end
    globalFramework = newFramework
end

--- Helper method to share a framework with all other templates.
local function share(ctx: Primitives.TemplateContext, framework: coretypes.Framework)
    if not framework then
        error("Framework cannot be nil")
    end
    local storeTab = (ctx.store :: any)[SHARED_FRAMEWORK_KEY] :: {[string]: coretypes.Framework}
    if not storeTab then
        storeTab = {[framework.id] = framework}
    else
        storeTab[framework.id] = framework
    end
end

--- Helper method to return all shared frameworks.
local function getShared(ctx: Primitives.TemplateContext): {[string]: coretypes.Framework}
    return (ctx.store :: any)[SHARED_FRAMEWORK_KEY] :: {[string]: coretypes.Framework} or {}
end

return {
    get = get,
    set = set,
    replace = replace,
    share = share,
    getShared = getShared,
}