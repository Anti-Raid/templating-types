--- A CachedTable is a table that stores key-value pairs with an expiration time.
export type CachedTable<K, V> = {
    --- Gets a value from the cache by its key.
    --- @field {[K]: V} The table that stores the key-value pairs
    get: (self: CachedTable<K, V>, key: K) -> V?, 
    --- Sets a value in the cache with an expiration time.
    --- @param key The key to set the value for
    --- @param value The value to set
    --- @param expiry The time in seconds after which the value will expire
    --- @return nil
    set: (self: CachedTable<K, V>, key: K, value: V, expiry: number) -> (),
    --- Removes a value from the cache by its key.
    --- @param key The key to remove
    --- @return nil
    remove: (self: CachedTable<K, V>, key: K) -> (),
    --- Closes the cache, removing all key-value pairs and cancelling any pending expiries.
    --- @return nil
    close: (self: CachedTable<K, V>) -> (),
    --- Gets the number of key-value pairs in the cache.
    --- @return number The number of key-value pairs in the cache
    len: (self: CachedTable<K, V>) -> number,
}

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
    local expiries = self.__expiries :: any
    task.cancel(expiries[key])
    expiries[key] = nil
end

function CachedTable:close<K, V>()
    for key, _ in pairs(self.__tab) do
        self:remove(key)
    end
end

function CachedTable:len<K, V>(): number
    local tab: {} = self.__tab
    return #tab
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