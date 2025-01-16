--!nocheck
local function string_contains(str: string, sub: string)
    return str:find(sub, 1, true) ~= nil
end

local function string_startswith(str: string, start: string)
    return str:sub(1, #start) == start
end

local function string_endswith(str: string, ending: string)
    return ending == "" or str:sub(-#ending) == ending
end

local function string_replace(str: string, old: string, new: string)
    local s = str
    local search_start_idx = 1

    while true do
        local start_idx, end_idx = string.find(s, old, search_start_idx, true)
        if (not start_idx or not end_idx) then
            break
        end

        local postfix = string.sub(s, end_idx + 1)
        s = s:sub(1, (start_idx - 1)) .. new .. postfix

        search_start_idx = -1 * postfix:len()
    end

    return s
end

local function string_insert(str: string, pos: number, text: string)
    return str:sub(1, pos - 1) .. text .. str:sub(pos)
end

--- Splits a string into a table of substrings, using a separator string.
--- Stops splitting after n substrings have been found or the end of the string is reached.
local function string_splitn(str: string, sep: string, n: number)
    local parts = {}
    local i = 1

    while i <= n do
        local start_idx, end_idx = str:find(sep, 1, true)
        if (not start_idx or not end_idx) then
            break
        end

        table.insert(parts, str:sub(1, start_idx - 1))
        str = str:sub(end_idx + 1)
        i = i + 1
    end

    table.insert(parts, str)
    return parts
end

-- Test
if(_G._TEST_ASYNC_WORK ~= nil) then
    assert(string_contains("Hello, world!", "world") == true, "string_contains failed")
    assert(string_contains("Hello, world!", "World") == false, "string_contains failed")
    assert(string_startswith("Hello, world!", "Hello") == true, "string_startswith failed")
    assert(string_startswith("Hello, world!", "hello") == false, "string_startswith failed")
    assert(string_endswith("Hello, world!", "world!") == true, "string_endswith failed")
    assert(string_endswith("Hello, world!", "World!") == false, "string_endswith failed")
    assert(string_replace("Hello, world!", "world", "moon") == "Hello, moon!", "string_replace failed")
    assert(string_replace("Hello, world!", "World", "moon") == "Hello, world!", "string_replace failed")
    assert(string_replace("Hello, world!", "l", "L") == "HeLLo, worLd!", "string_replace failed")
    assert(string_insert("Hello, world!", 8, "beautiful ") == "Hello, beautiful world!", "string_insert failed")

    assert(string_splitn("Hello, world!", ",", 1)[1] == "Hello", "string_splitn failed., got " .. string_splitn("Hello, world!", ",", 1)[1])
    assert(string_splitn("Hello, world!", ",", 2)[2] == " world!", "string_splitn failed., got " .. string_splitn("Hello, world!", ",", 2)[2])
    
    for k, v in string_splitn("a=b=c!", "=", 1) do
        print(k, v)
    end
end

return {
    string_contains = string_contains,
    string_startswith = string_startswith,
    string_endswith = string_endswith,
    string_replace = string_replace,
    string_insert = string_insert,
    string_splitn = string_splitn
}