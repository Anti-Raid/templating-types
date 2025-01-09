export type CachedTable<K, V> = {
    get: (self: CachedTable<K, V>, key: K) -> V?, 
    set: (self: CachedTable<K, V>, key: K, value: V, expiry: number) -> (),
    remove: (self: CachedTable<K, V>, key: K) -> (),
    close: (self: CachedTable<K, V>) -> (),
}

--- @class CachedTable<K, V>
---
--- A CachedTable is a table that stores key-value pairs with an expiration time.
local CachedTable = {}
CachedTable.__index = CachedTable

function CachedTable.new<K, V>(): CachedTable<K, V>
    local self = setmetatable({}, CachedTable)
    self.__tab = {} :: {[K]: V}
    self.__expiries = {} :: {[K]: thread}
    return self :: CachedTable<K, V>
end 

function CachedTable:get<K, V>(key: K): V?
    return self.__tab[key]
end
 
function CachedTable:set<K, V>(key: K, value: V, expiry: number)
    self.__tab[key] = value
    self.__expiries[key] = task.delay(expiry, function()
        self.__tab[key] = nil
        self.__expiries[key] = nil
    end)
end

function CachedTable:remove<K, V>(key: K)
    self.__tab[key] = nil
    task.cancel(self.__expiries[key])
    self.__expiries[key] = nil
end

function CachedTable:close<K, V>()
    for key, _ in pairs(self.__tab) do
        self:remove(key)
    end
end

-- Test
if(_G._TEST_ASYNC_WORK ~= nil) then
    local cache = CachedTable.new() :: CachedTable<string, string>
    cache:set("test", "test", 5)
    print("Before", cache:get("test"))
    task.wait(5)
    print("After (hopeful) expiry", cache:get("test"))
    assert(cache:get("test") == nil, "Cache did not expire")
    cache:set("test", "test", 10000000)
    cache:remove("test")
    print("Should return now", cache:get("test"))
end

return {
    CachedTable = CachedTable,
}