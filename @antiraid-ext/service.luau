local signal = require("signal.luau")

local globname = "___services"

type Service<T, U> = {
    exports: T,
    signal: signal.Identity<U>
}

--- Creates a new service returning the created data
---
--- @param name string
--- @param data T
--- @return Service<any>
local function CreateService<T, U>(name: string, exports: T): Service<T, U>
    if not _G[globname] then
        _G[globname] = {}
    end

    local service = {
        exports = exports,
        signal = signal()
    }

    -- If onFire is defined on exports, connect it to the signal
    local exportsCast = exports :: any -- Needed to avoid type errors
    if exportsCast.onFire and typeof(exportsCast) == "function" then
        service.signal:connect(exportsCast.onFire :: (U) -> ())
    end

    _G[globname][name] = service
    return service
end

--- Returns a service by name
---
--- @param name string
--- @return any
local function GetService<T, U>(name: string): Service<T, U>?
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
local function WaitForService<T, U>(name: string): Service<T, U>
    local service = GetService(name) :: Service<T, U>?;
    while not service do
        task.wait(0.1)
        service = GetService(name) :: Service<T, U>?
    end

    if not service then
        error("Service was not created")
    end

    return service
end

--- Waits for a service with a timeout of `n` seconds, returning the service if it was created, otherwise nil
---
--- Like WaitForService, this requires that task.start() has been called to start the task scheduler before calling this function
--- @param name string
--- @param n number
--- @return any
local function WaitForServiceWithTimeout<T, U>(name: string, n: number): Service<T, U>?
    local service = GetService(name) :: Service<any, any>?
    local start = os.clock()
    while not service do
        if os.clock() - start >= n then
            return nil
        end

        task.wait(0.1)
        service = GetService(name) :: Service<any, any>?
    end

    return service
end

return {
    CreateService = CreateService,
    GetService = GetService,
    DestroyService = DestroyService,
    WaitForService = WaitForService,
    WaitForServiceWithTimeout = WaitForServiceWithTimeout
}