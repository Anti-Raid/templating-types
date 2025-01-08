local promise = require("@antiraid/promise")

--- A lazy value is a value that is only serialized when accessed
export type Lazy<T> = {
    --- The inner value. Only serialized when accessed and then cached.
    read data: T,
    --- Always returns true
    read lazy: boolean
}

--- A Promise<Lazy<T>> is such a common pattern, theres a type definition for it here
export type LazyPromise<T> = promise.LuaPromise<Lazy<T>>

local function new<T>(value: T): Lazy<T>
    error("Implemented internally in AntiRaid runtime!")
end

return {
    new = new
}