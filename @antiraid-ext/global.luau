--- Retrieves a global variable 
---
--- @param k any
--- @returns any
local function get(k: any)
    return _G[k]
end

--- Sets a global variable
---
--- @param k any
--- @param v any
--- @returns void
local function set<T>(k: any, v: T)
    _G[k] = v
end

--- Updates a global variable with key `k`, a default value `default`, and a function `f`
--- returning the new value
---
--- @param k any
--- @param default any
--- @param f fun(v: any): any
--- @returns any
local function update<T>(k: any, default: () -> T, f: (T) -> T)
    local v = _G[k]
    if v == nil then
        v = default()
    end
    v = f(v :: T)
    _G[k] = v 
    return v
end

return {
    get = get,
    set = set,
    update = update
}