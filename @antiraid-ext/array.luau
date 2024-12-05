local interop = require("@antiraid/interop")

-- Create new array() function to allow easily creating arrays
-- 
-- This function sets the array_metatable as well
function array(...)
    local arr = {}
    local packed = table.pack(...)
    for i = 1, select('#', ...) do
        table.insert(arr, packed[i])
    end

    setmetatable(arr, interop.array_metatable)
    return arr
end

return {
    array = array
}