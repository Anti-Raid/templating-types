local function string_contains(str: string, sub: string)
    return str:find(sub, 1, true) ~= nil
end

-- Test
if(_G._TEST_ASYNC_WORK ~= nil) then
    assert(string_contains("Hello, world!", "world") == true, "string_contains failed")
    assert(string_contains("Hello, world!", "World") == false, "string_contains failed")
end

return string_contains