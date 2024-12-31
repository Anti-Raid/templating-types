export type null = {
    ___placeholder: number
}

local null: null = {
    ___placeholder = 1
}

return {
    null = null,
    array_metatable = {
        __index = function(tab, key)
            return rawget(tab, key) -- Placeholder for AntiRaid's actual array metatable
        end
    },
    memusage = function()
        return 0
    end,
}