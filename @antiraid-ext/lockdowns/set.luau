--- Sets
---
--- Sets can add/get unique elements.
---
--- **Usage notes**
---
--- 1. The elements stored must be hashable (e.g. strings, numbers, etc.).
export type Set<K> = typeof(setmetatable({} :: {
    --- Adds an element to the set
    add: (element: K) -> (),
    --- Removes an element from the set 
    remove: (element: K) -> (),
    --- Returns if an element exists in the priority set or not
    exists: (element: K) -> boolean
}, {} :: {
    __iter: (self: Set<K>) -> () -> K?
}))

local function Set<K>(): Set<K>
    local self = {}

    local elements: {[K]: boolean} = {}

    local function add(element: K)
        if typeof(element) ~= "string" and typeof(element) ~= "number" then 
            error("Set can only be called using string and number arguments")
        end

        elements[element] = false
    end

    local function remove(element: K)
        elements[element] = nil
    end

    local function exists(element: K): boolean
        return elements[element] ~= nil
    end

    -- Should return iterator function and state as per Luau docs for generalized iterators.
    setmetatable(self, {
        --- Iterates over the elements and their highest priorities
        __iter = function()
            return function(k: {[K]: boolean}, v: K?): K?
                local nextEl, _ = next(k, v)
                return nextEl
            end, elements
        end,
    })

    self.add = add
    self.remove = remove
    self.exists = exists

    return self :: Set<K>
end

return Set