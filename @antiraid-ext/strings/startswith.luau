local function string_startswith(str: string, start: string)
    return str:sub(1, #start) == start
end

-- Test
if(_G._TEST_ASYNC_WORK ~= nil) then
    assert(string_startswith("Hello, world!", "Hello") == true, "string_startswith failed")
    assert(string_startswith("Hello, world!", "hello") == false, "string_startswith failed")
end

return string_startswith