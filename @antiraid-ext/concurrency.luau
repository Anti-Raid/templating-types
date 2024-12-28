local timeouts = {}
local intervals = {}

--- Implementation of setTimeout for the AntiRaid runtime.
---
--- Functions like JavaScript's setTimeout.
---
--- Should also work on Roblox as well
local function setTimeout(callback: (any) -> (), delay: number?, ...): number
    local tid = #timeouts + 1
    timeouts[tid] = true
    
    local args = {...}

    if(typeof(delay) == "string") then
        -- Convert string to number
        delay = tonumber(delay)
    end

    -- Default delay is 0
    delay = (delay or 0)

    task.spawn(function()
        if(not timeouts[tid]) then
            return
        end

        task.wait((delay :: number)/1000)

        if(not timeouts[tid]) then
            return
        end

        task.spawn(function() callback(args) end)
    end)

    return tid
end

--- Implementation of clearTimeout for the AntiRaid runtime.
---
--- Functions like JavaScript's clearTimeout.
---
--- Should also work on Roblox as well
local function clearTimeout(tid: number)
    timeouts[tid] = false
end

--- Implementation of setInterval for the AntiRaid runtime.
---
--- Functions like JavaScript's setInterval.
---
--- Should also work on Roblox as well
local function setInterval(callback: (any) -> (), delay: number?, ...): number
    local tid = #intervals + 1
    intervals[tid] = true
    
    local args = {...}
    if(typeof(delay) == "string") then
        -- Convert string to number
        delay = tonumber(delay)
    end

    -- Default delay is 0
    delay = delay or 0

    task.spawn(function()
        while true do
            if(not intervals[tid]) then
                return
            end

            task.wait((delay :: number)/1000)

            if(not intervals[tid]) then
                return
            end

            task.spawn(function() callback(args) end)
        end
    end)

    return tid
end

--- Implementation of clearInterval for the AntiRaid runtime.
---
--- Functions like JavaScript's clearInterval.
---
--- Should also work on Roblox as well
local function clearInterval(tid: number)
    intervals[tid] = false
end

-- Test
if(_G._TEST_ASYNC_WORK ~= nil) then
    setTimeout(function()
        print("Task")
    end, 1000)

    print("Hello, world A")

    setTimeout(function()
        print("Task2")
    end, 2000)

    print("Hello, world B")

    setTimeout(function()
        print("Task3")
    end, 500)

    local idx = 0
    local tid;
    tid = setInterval(function()
        idx += 1
        print(idx)

        if(idx >= 5) then
            clearInterval(tid :: number)
        end
    end, 1000)
end

return {
    setTimeout = setTimeout,
    clearTimeout = clearTimeout,
    setInterval = setInterval,
    clearInterval = clearInterval
}