local function string_insert(str: string, pos: number, text: string)
    return str:sub(1, pos - 1) .. text .. str:sub(pos)
end

-- Test
if(_G._TEST_ASYNC_WORK ~= nil) then
    assert(string_insert("Hello, world!", 8, "beautiful ") == "Hello, beautiful world!", "string_insert failed")
end

return string_insert