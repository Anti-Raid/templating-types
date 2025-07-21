local coretypes = require"./coretypes"
local Primitives = require"@antiraid-core/primitives"

local FRAMEWORK_KEY = "__antiraid_ext_framework"

--- Returns the current framework instance if it exists.
--- If it does not exist, returns nil.
local function get(): coretypes.Framework? 
    return _G[FRAMEWORK_KEY] :: coretypes.Framework?
end 

--- Sets the framework instance.
--- If it is already set, it will throw an error.
local function set(framework: coretypes.Framework)
    if not framework then
        error("Framework cannot be nil")
    end
    if _G[FRAMEWORK_KEY] then
        error("Framework is already set")
    end

    _G[FRAMEWORK_KEY] = framework
end

--- Replaces any current framework instance with a new one.
--- Unlike set, this does not throw an error if the framework is already set.
local function replace(newFramework: coretypes.Framework)
    if not newFramework then
        error("New framework cannot be nil")
    end
    _G[FRAMEWORK_KEY] = newFramework
end

--- Helper method to share a framework with all other templates.
local function share(ctx: Primitives.TemplateContext, framework: coretypes.Framework)
    if not framework then
        error("Framework cannot be nil")
    end
    local storeTab = (ctx.store :: any)[FRAMEWORK_KEY] :: {[string]: coretypes.Framework}
    if not storeTab then
        storeTab = {[framework.id] = framework}
    else
        storeTab[framework.id] = framework
    end
end

--- Helper method to return all shared frameworks.
local function getShared(ctx: Primitives.TemplateContext): {[string]: coretypes.Framework}
    return (ctx.store :: any)[FRAMEWORK_KEY] :: {[string]: coretypes.Framework} or {}
end

return {
    get = get,
    set = set,
    replace = replace,
    share = share,
    getShared = getShared,
}