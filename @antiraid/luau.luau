local Primitives = require("@antiraid-core/primitives")
local Promise = require("@antiraid/promise")

export type Chunk = {
    --- Requires the ``luau:eval.set_environment`` capability to modify
    environment: {[any]: any}?,
    --- Requires the ``luau:eval.set_optimization_level`` capability to modify
    optimization_level: number?,
    --- Requires the ``luau:eval.modify_set_code`` capability to modify
    code: string,
    --- Requires the ``luau:eval.set_chunk_name`` capability to modify
    chunk_name: string?,
    --- Requires the ``luau:eval.call`` capability to use. Takes in args and returns the 
    --- returned values from the ``code`` being evaluated.
    call: (self: Chunk, args: any) -> any,
    --- Requires the ``luau:eval.call_async`` capability to use. Takes in args and returns the
    --- returned values from the ``code`` being evaluated.
    ---
    --- This runs the code asynchronously
    call_async: (self: Chunk, args: any) -> Promise.LuaPromise<any>,
}

--- Requires the ``luau:eval`` capability to use. Be careful as this allows
--- for arbitrary code execution.
local function load(token: Primitives.TemplateContext, code: string): Chunk
    error("Implemented internally in AntiRaid runtime!")
end

return {
    load = load,
}