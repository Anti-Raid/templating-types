local Primitives = require "@antiraid-core/primitives"
local function store(ctx: Primitives.TemplateContext)
    error("Internally implemented in the AntiRaid runtime")
end

return {
    store = store,
}