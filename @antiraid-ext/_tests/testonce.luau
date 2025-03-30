--!nocheck

local Primitives = require "@antiraid-core/primitives"
local once = require "@antiraid-ext/once"
local executor = require "@antiraid-ext/executor"
local promise = require "@antiraid/promise"

local _evt: Primitives.Event, ctx: Primitives.TemplateContext = ...

local ge = executor.NewGlobalExecutor(ctx)

local count = 0

local function cleanupFunc() 
    promise.yield(ge.kv:delete("__once:my_unique_id")) -- Clean up the key after testing
    promise.yield(ge.kv:delete("__once:my_unique_id2")) -- Clean up the key after testing
    promise.yield(ge.kv:delete("__once:my_unique_id3")) -- Clean up the key after testing
    promise.yield(ge.kv:delete("__once:my_unique_id4")) -- Clean up the key after testing
    promise.yield(ge.kv:delete("__once:my_unique_id5")) -- Clean up the key after testing
    promise.yield(ge.kv:delete("__once:my_unique_id6")) -- Clean up the key after testing
    print("Cleanup completed: Removed all test keys from the key-value store.")
end

local function assert(condition: boolean, message: string)
    if not condition then
        cleanupFunc() -- Clean up any keys before raising an error
        error(message, 2) -- Raise an error with the message provided
    end
end

print("[1] basic once_local")
for i = 1, 10 do
    once.onceLocal("my_unique_id", function()
        -- This function will only run once for the template
        count = (count :: number) + 1
        return 0
    end)
end

assert(count == 1, "The function should only have executed once, but it executed " .. tostring(count) .. " times.")

print("[2] basic once_local with yields")

local count2 = 0
task.delay(0.1, function() 
    once.onceLocal("my_unique_id2", function()
        -- This function will only run once for the template
        count2 = (count2 :: number) + 1
        return 0
    end)
end)

once.onceLocal("my_unique_id2", function()
    -- This function will only run once for the template
    count2 = (count2 :: number) + 1
    return 0
end)

task.wait(1)

assert(count2 == 1, "The function should only have executed once, but it executed " .. tostring(count2) .. " times.")

print("[3] onceLocal erroring then succeeding")

local count3 = 0

-- First call will error
pcall(once.onceLocal, "my_unique_id3", function()
    count3 = (count3 :: number) + 1
    error("This is an error")
end)

-- This will be called after the first one fails, but it should not error again
once.onceLocal("my_unique_id3", function()
    -- This function will only run once for the template
    count3 = (count3 :: number) + 1
    return 0
end)

assert(count3 == 2, "The function should have executed once after the first error, but it executed " .. tostring(count3) .. " times.")

print("[1] basic once")

local count4 = 0

for i = 1, 10 do
    once.once(ge, "my_unique_id4", function()
        -- This function will only run once for the template
        count4 = (count4 :: number) + 1
        return 0
    end)
end

assert(count4 == 1, "The function should only have executed once, but it executed " .. tostring(count4) .. " times.")

print("[2] basic once with yields")

local count5 = 0

task.delay(0.1, function() 
    once.once(ge, "my_unique_id5", function()
        -- This function will only run once for the template
        count5 = (count5 :: number) + 1
        return 0
    end)
end)

once.once(ge, "my_unique_id5", function()
    -- This function will only run once for the template
    count5 = (count5 :: number) + 1
    return 0
end)

task.wait(1)

assert(count5 == 1, "The function should only have executed once, but it executed " .. tostring(count5) .. " times.")

print("[3] once erroring then succeeding")

local count6 = 0

-- First call will error
pcall(once.once, ge, "my_unique_id6", function()
    count6 = (count6 :: number) + 1
    error("This is an error")
end)

-- This will be called after the first one fails, but it should not error again
once.once(ge, "my_unique_id6", function()
    -- This function will only run once for the template
    count6 = (count6 :: number) + 1
    return 0
end)

assert(count6 == 2, "The function should have executed once after the first error, but it executed " .. tostring(count6) .. " times.")

cleanupFunc() -- Clean up any keys created during the test to ensure no residual state affects future tests