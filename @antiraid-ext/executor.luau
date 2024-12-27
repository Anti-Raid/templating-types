local promise = require("@antiraid/promise")

local function yieldOrReturn<T>(v: promise.LuaPromise<T> | T): T
    if typeof(v) == "LuaPromise" then
        return promise.yield(v)
    else
        return v
    end
end