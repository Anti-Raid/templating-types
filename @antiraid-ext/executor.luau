local Primitives = require "@antiraid-core/primitives"
local promise = require("@antiraid/promise")
local discord = require "@antiraid/discord"
local kv = require "@antiraid/kv"
local lockdowns = require "@antiraid/lockdowns"
local stings = require "@antiraid/stings"
local userinfo = require "@antiraid/userinfo"
local ExecutorScope = require "@antiraid-core/executorscope"

--- Either yields the promise or return a value
local function yieldOrReturn<T>(v: promise.LuaPromise<T> | T): T
    if typeof(v) == "LuaPromise" then
        return promise.yield(v)
    else
        return v
    end
end

--- @class GlobalExecutor
---
--- Sometimes, it is useful to be able to just make one single object that
--- includes all of AntiRaids executors as fields (versus having to do the
--- import->new pattern)
--- 
--- GlobalExecutor is a type that does this for you. Executors are lazily 
--- initialized when accessed using __index metamethod.
export type GlobalExecutor = {
    discord: discord.DiscordExecutor,
    kv: kv.KvExecutor,
    lockdowns: lockdowns.LockdownExecutor,
    stings: stings.StingExecutor,
    userinfo: userinfo.UserInfoExecutor,
} 

--- Creates a new GlobalExecutor. For safety reasons, scope will only be set
--- for KvExecutor.
--- 
--- @param token Primitives.TemplateContext The token to use for the executors
--- @param scope ExecutorScope.ExecutorScope The scope to use for the executors
local function NewGlobalExecutor(token: Primitives.TemplateContext, scope: ExecutorScope.ExecutorScope?): GlobalExecutor
    local ge = setmetatable({}, {
        __index = function(self, key)
            local potExec = rawget(self, key)
            if potExec ~= nil then
                return potExec
            end

            if key == "discord" then
                local exec = discord.new(token)
                rawset(self, key, exec)
                return exec
            elseif key == "kv" then
                local exec = kv.new(token, scope)
                rawset(self, key, exec)
                return exec
            elseif key == "lockdowns" then
                local exec = lockdowns.new(token)
                rawset(self, key, exec)
                return exec
            elseif key == "stings" then
                local exec = stings.new(token)
                rawset(self, key, exec)
                return exec
            elseif key == "userinfo" then
                local exec = userinfo.new(token)
                rawset(self, key, exec)
                return exec
            else
                error("Unknown executor: " .. tostring(key))
            end
         end,
        __newindex = function()
            error("GlobalExecutor is read-only")
        end
    })

    return ge :: GlobalExecutor 
end

return {
    yieldOrReturn = yieldOrReturn,
    NewGlobalExecutor = NewGlobalExecutor,
}