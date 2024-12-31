local globname = "___services"

--- Creates a new service returning the created data
---
--- @param name string
--- @param data T
--- @return Service<any>
local function CreateService<T>(name: string, exports: T): T
    if not _G[globname] then
        _G[globname] = {}
    end

    local service = exports

    _G[globname][name] = service
    return service :: T
end

--- Returns a service by name
---
--- @param name string
--- @return any
local function GetService<T>(name: string): T?
    if not _G[globname] then
        return nil
    end

    return _G[globname][name]
end

--- Destroys a service by name, returning the data in the service
--- @param name string
--- @return any
local function DestroyService(name: string) 
    if not _G[globname] then
        return nil
    end

    local data = _G[globname][name]
    _G[globname][name] = nil
    return data
end

--- Keeps waiting until the service is created, then returns the service
---
--- This requires that task.start() has been called to start the task scheduler before calling this function
--- @param name string
--- @return Service<any, any>
local function WaitForService<T>(name: string): T
    local service = GetService(name) :: T?;
    while not service do
        task.wait(0.1)
        service = GetService(name) :: T?
    end

    if not service then
        error("Service " .. name .. " was not created")
    end

    return service
end

--- Waits for a service with a timeout of `n` seconds, returning the service if it was created, otherwise nil
---
--- Like WaitForService, this requires that task.start() has been called to start the task scheduler before calling this function
--- @param name string
--- @param n number
--- @return any
local function WaitForServiceWithTimeout<T>(name: string, n: number): T?
    local service = GetService(name) :: T?
    local start = os.clock()
    while not service do
        if os.clock() - start >= n then
            return nil
        end

        task.wait(0.1)
        service = GetService(name) :: T?
    end

    return service
end


-- Test
if(_G._TEST_ASYNC_WORK ~= nil) then
    local signal = require("signal")

    -- Create new FooService
    local fooServiceSignal = signal()
    fooServiceSignal:connect(function(n: number)
        print("FooService fired!")
    end)

    type FooService = {
        signal: signal.Identity<number>,
    }

    local fooService = CreateService("FooService", {
        signal = fooServiceSignal,
    }) 

    -- Get FooService
    local fooService2 = GetService("FooService") :: FooService?

    assert(fooService2 == fooService, "GetService returned wrong service")
    
    local fooService3 = WaitForService("FooService") :: FooService

    -- Fire FooService
    local signalFire = fooService3.signal
    signalFire:fire(10)

    -- Test timeout with WaitForServiceWithTimeout on non-existing service
    local start = os.clock()
    local fooService4 = WaitForServiceWithTimeout("FooService2", 1) :: FooService
    local elapsed = os.clock() - start

    assert(fooService4 == nil, "WaitForServiceWithTimeout returned wrong service")
    assert(elapsed < 2, "WaitForServiceWithTimeout did not wait for 1 second, waited for " .. tostring(elapsed))

    -- Destroy FooService
    DestroyService("FooService")

    -- Test that FooService is destroyed
    local fooService5 = GetService("FooService") :: FooService
    assert(fooService5 == nil, "DestroyService did not destroy service")
end

return {
    CreateService = CreateService,
    GetService = GetService,
    DestroyService = DestroyService,
    WaitForService = WaitForService,
    WaitForServiceWithTimeout = WaitForServiceWithTimeout
}
