local Primitives = require "@antiraid-core/primitives"

local currentContext: Primitives.TemplateContext? = nil

--- Returns the currently stored context
local function getCurrentContext(): Primitives.TemplateContext
    if currentContext == nil then
        error("Internal error: No current context set. Use `setCurrentContext` to set the current context first!")
    end

    return currentContext
end

--- Sets the currently stored context
---
--- This stored context can then be used by other things in ``@antiraid-ext``
local function setCurrentContext(context: Primitives.TemplateContext)
    currentContext = context
end

return {
    getCurrentContext = getCurrentContext,
    setCurrentContext = setCurrentContext,
}