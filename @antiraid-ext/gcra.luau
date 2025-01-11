-- Define a RateLimiter class using the GCRA algorithm

type RateLimiter<BucketKey> = {
    count: number,  -- Maximum number of actions allowed
    period: number,  -- Time period for the rate limit
    costModifier: number, -- GCRA cost modifier, normally should be one
    buckets: {[BucketKey]: number },  -- Buckets for different keys
    attemptAction: (self: RateLimiter<BucketKey>, key: BucketKey) -> boolean
}

local RateLimiter = {}
RateLimiter.__index = RateLimiter

-- Constructor for RateLimiter
function RateLimiter.new<BucketKey>(
    count: number,  -- Maximum number of actions allowed
    period: number,  -- Time period for the rate limit
    costModifier: number? -- GCRA cost modifier, normally should be one
): RateLimiter<BucketKey>
    local self = setmetatable({}, RateLimiter)
    self.count = count
    self.period = period
    self.costModifier = costModifier or 1
    self.buckets = {}
    return self :: RateLimiter<BucketKey>
end

-- Function to attempt an action (this is where the rate limit check happens)
--
-- returns true if the action is allowed, false if it is denied
function RateLimiter.attemptAction<BucketKey>(rl: RateLimiter<BucketKey>, key: BucketKey): boolean
    print(tostring(rl.count) .. " per " .. tostring(rl.period) .. " seconds | " .. tostring(rl.costModifier))
    local EMISSION_INTERVAL = rl.period / rl.count -- aka separation
    local NOW = os.clock()
    
    local tat = rl.buckets[key]

    if not tat then
        tat = NOW
        rl.buckets[key] = tat
    end

    local TAT = math.max(tat, NOW)
    local SEPARATION = TAT - NOW
    local MAX_INTERVAL = rl.period - EMISSION_INTERVAL

    local reject: boolean
    if SEPARATION > MAX_INTERVAL then
        reject = true
    else 
        reject = false
        local new_tat = math.max(TAT, NOW) + EMISSION_INTERVAL
        rl.buckets[key] = new_tat
    end
    return not reject
end

-- Example Usage
local limiter = RateLimiter.new(
    5,
    10
)  -- 5 actions per 10 seconds

-- Try to perform actions in a loop
for i = 1, 10 do
    if limiter:attemptAction("abc") then
        print("Action " .. tostring(i) .. " allowed!")
    else
        print("Action " .. tostring(i) .. " denied (rate limited)!")
    end
    task.wait(0.2)  
end