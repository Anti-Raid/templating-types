local function string_index(str: string, idx: number) --> string
    return str:sub(idx, idx)
end

return string_index