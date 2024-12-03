local Primitives = require("./Primitives");

--- Sleep for a given duration
---
--- Returns the actual duration slept for.
---
--- **Only works in the actual AntiRaid runtime (and is implemented internally)**
function sleep(duration: Primitives.f64): Primitives.f64
    coroutine.yield()
    return duration
end

return {
    sleep = sleep
}