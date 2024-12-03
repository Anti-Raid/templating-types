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

local DummyLuaStream: LuaStream<string> = {
    ___contents = {
        "a",
        "b",
        "c"
    },
    ___index = 0,
    next = function(self: LuaStream<string>): string?
        local s: any = self;

        if s.__index >= #s.__contents then
            return nil;
        end

        s.__index = s.__index + 1;
        return s.__contents[s.__index];
    end,
    for_each = function(self: LuaStream<string>, callback: (string) -> ())
        local item: string? = self:next();
        while item do
            callback(item);
            item = self:next();
        end
        return
    end
}

return {
    DummyLuaStream = DummyLuaStream
}