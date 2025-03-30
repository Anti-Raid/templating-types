--- Opaque promise type returned by antiraid
export type LuaPromise<T> = {
    --- Note: this will always actually be nil but is required to enforce nominal typing properly
    read __phantom: T,
}

--- Yields the coroutine and resumes it returning the end value of the promise when it resolves
local function yield<T>(promise: LuaPromise<T>): T 
    error("Implemented internally in AntiRaid runtime!")
end

return {
    yield = yield
}