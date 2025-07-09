--- Retrieves a global variable 
---
--- @param k any
--- @return any
local function get<T>(k: any): T?
    return _G[k] 
end

--- Sets a global variable
---
--- @param k any
--- @param v any
--- @return void
local function set<T>(k: any, v: T)
    _G[k] = v
end

--- Updates a global variable with key `k`, a default value `default`, and a function `f`
--- returning the new value
---
--- @param k any
--- @param default any
--- @param f fun(v: any): any
--- @return The result of the function `f` applied to the value of `k`
local function update<T>(k: any, default: () -> T, f: (T) -> T): T
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