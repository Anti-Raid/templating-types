local ge = require "@antiraid-ext/executor"
local global = require "@antiraid-ext/global"

local function _getOnce(ge: ge.GlobalExecutor, id: string): boolean
    if not global.get("__once:" .. id) then
        return true
    elseif ge.kv:get("__once:" .. id) then
        global.set("__once:" .. id, "done")
        return true
    else
        return false
    end
end

--- Runs a function only once, when the template is first ever 
--- executed
---
--- @antiraid/kv is used for persistence here to avoid rerunning
--- the function on worker restart
local function once(ge: ge.GlobalExecutor, id: string, fn: () -> ())
    local hasRun = _getOnce(ge, id)

    if hasRun then
        return
    end

    global.set("__once:" .. id, "pending")
    local ok = pcall(fn)

    if ok then
        global.set("__once:" .. id, "done")
        ge.kv:set("__once:" .. id, true)
    end
end

--- Runs a function only once, when the template is first ever 
--- executed
---
--- Unlike ``once``, this function is not persistent across worker restarts
local function onceLocal(id: string, fn: () -> ())
    local hasRun = global.get("__once:" .. id)

    if hasRun then
        return
    end

    global.set("__once:" .. id, "pending")
    local ok = pcall(fn)

    if ok then
        global.set("__once:" .. id, "done")
    end
end

return {
    once = once,
    onceLocal = onceLocal,
} 