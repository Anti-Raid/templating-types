local Primitives = require("@antiraid-core/primitives")

type EventCall = {
    pat: string,
    cb: (Primitives.TemplateContext) -> any
}

local function createTab(pat: string, callback: (Primitives.TemplateContext) -> any): EventCall
    return {
        pat = pat,
        cb = callback
    }
end

local function eventList(...: EventCall): {[string]: (Primitives.TemplateContext) -> any}
    local tab = {}
    for _, map in (... :: {EventCall}) do 
        assert(map.pat, "map.pat not set")
        tab[map.pat] = map.cb
    end
    return tab
end

return {
    createTab = createTab,
    eventList = eventList
}