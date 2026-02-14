export type Ticker = {
    --- Cancel the ticker
    ---
    --- Note that callback will continue to run to completion if it's currently running, but will not run again after that
    cancel: () -> (),
}

local function Ticker(interval: number, callback: () -> ()): Ticker
    local active = true
    local th = task.spawn(function()
        while active do
            task.wait(interval)
            task.defer(callback)
        end
    end)

    return {
        cancel = function()
            if not active then return end 
            active = false
            task.cancel(th)
        end
    }
end

return Ticker