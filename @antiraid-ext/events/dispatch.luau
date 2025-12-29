local Primitives = require("@antiraid-core/primitives")

local function createTab(pat: string, callback: (Primitives.TemplateContext) -> any): {[string]: (Primitives.TemplateContext) -> any}
    return table.freeze{
        [pat] = callback
    }
end

local function eventList(...: {[string]: (Primitives.TemplateContext) -> any}): {[string]: (Primitives.TemplateContext) -> any}
    local tab = {}
    for pat, cb in ... do 
        tab[pat] = cb
    end
    return tab
end

return {
    createTab = createTab,
    eventList = eventList
}