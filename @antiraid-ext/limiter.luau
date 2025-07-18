local DEFAULT_PENALTY_MULTIPLIER = 2.5
local DEFAULT_STORE_MULTIPLIER = 1.25
local tableext = require"@antiraid-ext/collections"

export type LockdownActionLimiter = {
    --- Attempts an action, if the limit is reached, it will sleep for a penalty time
    attempt: () -> (),
}

--- Limits to N attempted actions per time period.
---
--- After said time period, the limiter will auto sleep the thread for PENALTY times the time period.
---
--- Because of this, the limiter is a 'slowdown' mechanism, not a 'rate' limiter.
local function ActionLimiter(allowed: number, timePeriod: number, penalty_multiplier_val: number?, store_multiplier_val: number?): LockdownActionLimiter
    local penalty_multiplier = penalty_multiplier_val or DEFAULT_PENALTY_MULTIPLIER
    local store_multiplier = store_multiplier_val or DEFAULT_STORE_MULTIPLIER
    
    local self = {}
    local attempts: {number} = {}

    local function attempt() 
        local now = os.clock()
        -- Remove attempts that are older than the time period
        attempts = tableext.filter(attempts, function(attemptTime: number)
            return now - attemptTime < (timePeriod * store_multiplier)
        end)

        if #attempts >= allowed then
            -- Too many attempts, sleep for PENALTY_MULTIPLIER times the time period
            local sleepTime = timePeriod * penalty_multiplier
            task.wait(sleepTime)
            table.clear(attempts) -- Clear attempts after sleeping
            return
        end

        -- Record the attempt
        table.insert(attempts, os.clock())
        return
    end

    self.attempt = attempt

    return self
end

return ActionLimiter