--- Opaque promise type returned by antiraid
export type LuaPromise<T> = {}

--- Yields the coroutine and resumes it returning the end value of the promise when it resolves
local function yield<T>(promise: LuaPromise<T>): T 
    -- This function is internally implemented and just returns nil here
    return nil
end

return {
    yield = yield
}