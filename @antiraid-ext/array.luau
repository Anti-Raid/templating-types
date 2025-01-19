--!nocheck
local interop = require("@antiraid/interop")

-- Create new array() function to allow easily creating arrays
-- 
-- This function sets the array_metatable as well
local function array(...)
    local arr = {}
    local packed = table.pack(...)
    for i = 1, select('#', ...) do
        table.insert(arr, packed[i])
    end

    setmetatable(arr, interop.array_metatable)
    return arr
end

local function internalProtectedEquals(o1, o2, ignore_mt, callList)
    if o1 == o2 then return true end
    local o1Type = type(o1)
    local o2Type = type(o2)
    if o1Type ~= o2Type then return false end
    if o1Type ~= 'table' then return false end

    -- add only when objects are tables, cache results
    local oComparisons = callList[o1]
    if not oComparisons then
        oComparisons = {}
        callList[o1] = oComparisons
    end
    -- false means that comparison is in progress
    oComparisons[o2] = false

    if not ignore_mt then
        local mt1 = getmetatable(o1)
        if mt1 and mt1.__eq then
            --compare using built in method
            return o1 == o2
        end
    end

    local keySet = {}
    for key1, value1 in pairs(o1) do
        local value2 = o2[key1]
        if value2 == nil then return false end

        local vComparisons = callList[value1]
        if not vComparisons or vComparisons[value2] == nil then
            if not internalProtectedEquals(value1, value2, ignore_mt, callList) then
                return false
            end
        end

        keySet[key1] = true
    end

    for key2, _ in pairs(o2) do
        if not keySet[key2] then
            return false
        end
    end

    -- comparison finished - objects are equal do not compare again
    oComparisons[o2] = true
    return true
end

---@param o1 any|table First object to compare
---@param o2 any|table Second object to compare
---@param ignore_mt boolean True to ignore metatables (a recursive function to tests tables inside tables)
local function arraysEqual(o1, o2, ignore_mt)
    return internalProtectedEquals(o1, o2, ignore_mt or true, {})
end

local function toArray<T>(a: T): T --[[ Converts a value to an array. If the value is already an array, it is returned as is. If the value is not an array, it is wrapped in an array. ]]
    if typeof(a) == "table" then
        if getmetatable(a) == interop.array_metatable then
            return a
        end
        return setmetatable(a, interop.array_metatable)
    else
        return array(a)
    end
end

return {
    array = array,
    arraysEqual = arraysEqual,
    toArray = toArray,
}