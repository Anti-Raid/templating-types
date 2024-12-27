--- LuaStream provides a stream implementation. 
--- This is returned by MessageHandle's await_component_interaction for instance for handling button clicks/select menu choices etc.
export type LuaStream<T> = {}

--- Yields the coroutine and resumes it returning the next value of the stream when it resolves
local function next<T>(promise: LuaStream<T>): T 
    -- This function is internally implemented and just returns nil here
    return nil
end

return {
    next = next
}