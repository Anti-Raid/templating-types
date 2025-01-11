-- Define a RateLimiter class using the GCRA algorithm

export type RateLimiter<BucketKey> = {
    count: number,  -- Maximum number of actions allowed
    period: number,  -- Time period for the rate limit
    emission_interval: number,  -- Time interval between allowed actions
    buckets: {[BucketKey]: number },  -- Buckets for different keys
    attempt_action: (self: RateLimiter<BucketKey>, key: BucketKey) -> boolean
}

local RateLimiter = {}
RateLimiter.__index = RateLimiter

-- Constructor for RateLimiter
function RateLimiter.new<BucketKey>(
    count: number,  -- Maximum number of actions allowed
    period: number  -- Time period for the rate limit
): RateLimiter<BucketKey>
    local self = setmetatable({}, RateLimiter)
    self.count = count
    self.period = period
    self.emission_interval = period / count
    self.buckets = {}
    return self :: RateLimiter<BucketKey>
end

-- Function to attempt an action (this is where the rate limit check happens)
--
-- returns true if the action is allowed, false if it is denied
function RateLimiter.attempt_action<BucketKey>(rl: RateLimiter<BucketKey>, key: BucketKey): boolean
    print(tostring(rl.count) .. " per " .. tostring(rl.period) .. " seconds")
    local now = os.clock()
    
    local tat = rl.buckets[key]

    if not tat then
        tat = now
        rl.buckets[key] = tat
    end

    tat = math.max(tat, now) 
    local separation = tat - now
    local maxinterval = rl.period - rl.emission_interval

    if separation > maxinterval then
        return false
    else 
        local new_tat = math.max(tat, now) + rl.emission_interval
        rl.buckets[key] = new_tat
        return true
    end
end

-- Test
if(_G._TEST_ASYNC_WORK ~= nil) then
    local limiter = RateLimiter.new(
        5,
        10
    )  -- 5 actions per 10 seconds

    -- Try to perform actions in a loop
    for i = 1, 100 do
        if limiter:attempt_action("abc") then
            print("Action " .. tostring(i) .. " allowed!")
        else
            print("Action " .. tostring(i) .. " denied (rate limited)!")
            task.wait(1)
        end
    end
end

return RateLimiter