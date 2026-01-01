local datetime = require"@antiraid/datetime"

export type OneshotChannel<T> = {
    --- Once called, sends a value to the channel and destroys it. Errors if receiver is destroyed before sending a value
    read send: (self: OneshotChannel<T>, message: T) -> (),
    --- Waits for a value to be sent to the channel and receives it. Errors if sender is destroyed before sending a value
    read recv: (self: OneshotChannel<T>) -> T,
    --- Waits for a value to be sent to the channel and receives it, with a timeout. Errors if sender is destroyed before sending a value or if timeout is reached
    read recvtimeout: (self: OneshotChannel<T>, timeout: datetime.TimeDelta) -> T,
}

export type DelayChannel<T> = {
    --- Returns the maximum delay time supported by the delay channel
    read maxdelay: (self: DelayChannel<T>) -> datetime.TimeDelta,
    --- Adds a value to the delay queue, to be received after the specified delay
    read add: (self: DelayChannel<T>, message: T, delay: datetime.TimeDelta) -> (),
    --- Adds a value to the delay queue, to be received after the specified delay
    --- and returns a handle that can be used to cancel the delayed message
    read addwithhandle: (self: DelayChannel<T>, message: T, delay: datetime.TimeDelta) -> KeyHandle<T>,
    --- Waits for the next value in the delay queue to be ready and receives it
    ---
    --- Next should always only ever be called *once*. The exact behavior of calling next multiple times is undefined
    --- (and may result in either a error or the thread being perpetually yielded forever.)
    read next: (self: DelayChannel<T>) -> T,
}

export type KeyHandle<T> = typeof(setmetatable({} :: {
    --- Cancels the delayed message associated with this handle. Returns true if removed, else false
    --- 
    --- The value will be sent if the boolean is true
    cancel: (self: KeyHandle<T>) -> (boolean, T?),
}, {} :: {
    --- Returns true if the two KeyHandles point to the same delayed message, false otherwise
    __eq: (self: KeyHandle<T>, other: KeyHandle<T>) -> boolean,
}))

local function OneshotChannel<T>(): OneshotChannel<T>
    error("Implemented internally in AntiRaid runtime!")
end

local function DelayChannel<T>(): DelayChannel<T>
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
    DelayChannel = DelayChannel,
    selectoneshots = selectoneshots,
}