--- LuaStream provides a stream implementation. 
--- This is returned by MessageHandle's await_component_interaction for instance for handling button clicks/select menu choices etc.
export type LuaStream<T> = {
    --- Returns the next item in the stream.
    ---
    --- *This function may yield.*
    next: (self: LuaStream<T>) -> T?,
    --- Executes a callback for every entry in the stream.
    ---
    --- *This function may yield.*
    for_each: (self: LuaStream<T>, callback: (T) -> ()) -> (),
}


return {}