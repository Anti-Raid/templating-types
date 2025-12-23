local datetime = require"@antiraid/datetime"

export type OneshotChannel<T> = {
    --- Once called, sends a value to the channel and destroys it. Errors if receiver is destroyed before sending a value
    read send: (self: OneshotChannel<T>, message: T) -> (),
    --- Waits for a value to be sent to the channel and receives it. Errors if sender is destroyed before sending a value
    read recv: (self: OneshotChannel<T>) -> T,
    --- Waits for a value to be sent to the channel and receives it, with a timeout. Errors if sender is destroyed before sending a value or if timeout is reached
    read recvtimeout: (self: OneshotChannel<T>, timeout: datetime.TimeDelta) -> T,
}

local function OneshotChannel<T>(): OneshotChannel<T>
    error("Implemented internally in AntiRaid runtime!")
end

--- Waits on multiple oneshot channels and returns the values received from the ones that completed before the timeout
---
--- Returns a list of the received values and a boolean indicating whether the timeout was reached
local function selectoneshots<T>(channels: {OneshotChannel<T>}, timeout: datetime.TimeDelta): ({T}, boolean)
    error("Implemented internally in AntiRaid runtime!")
end

return {
    OneshotChannel = OneshotChannel,
    selectoneshots = selectoneshots,
}