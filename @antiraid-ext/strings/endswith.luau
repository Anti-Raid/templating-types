local function string_endswith(str: string, ending: string)
    return ending == "" or str:sub(-#ending) == ending
end

-- Test
if(_G._TEST_ASYNC_WORK ~= nil) then
    assert(string_endswith("Hello, world!", "world!") == true, "string_endswith failed")
    assert(string_endswith("Hello, world!", "World!") == false, "string_endswith failed")
    assert(string_endswith("!", "World!") == false, "!string_endswith failed")
    assert(string_endswith("!", "!") == true, "!string_endswith failed")
end


return string_endswith