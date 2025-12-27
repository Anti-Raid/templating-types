local Primitives = require("@antiraid-core/primitives")

local function createTab(pat: string, callback: (Primitives.Event) -> any): {[string]: (Primitives.Event) -> any}
    return table.freeze{
        [pat] = callback
    }
end

local function eventList(...: {[string]: (Primitives.Event) -> any}): {[string]: (Primitives.Event) -> any}
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