local datetime = require"@antiraid/datetime"

--- A oneshot channel allows sending and receiving a single value across tasks (Lua threads etc.)
export type OneshotChannel<T> = {
    --- Once called, sends a value to the channel and destroys it. Errors if receiver is destroyed before sending a value
    read send: (self: OneshotChannel<T>, message: T) -> (),
    --- Waits for a value to be sent to the channel and receives it. Errors if sender is destroyed before sending a value
    read recv: (self: OneshotChannel<T>) -> T,
    --- Waits for a value to be sent to the channel and receives it, with a timeout. Errors if sender is destroyed before sending a value or if timeout is reached
    read recvtimeout: (self: OneshotChannel<T>, timeout: datetime.TimeDelta) -> T,
}

--- A delay channel allows sending values that will be received after a specified delay
export type DelayChannel<T> = typeof(setmetatable({} :: {
    --- Adds a value to the delay queue, to be received after the specified delay
    --- and returns a handle that can be used to cancel the delayed message
    read add: (self: DelayChannel<T>, message: T, delay: datetime.TimeDelta) -> KeyHandle<T>,
    --- Waits for the next value in the delay queue to be ready and receives it
    ---
    --- Next should always only ever be called *once*. The exact behavior of calling next multiple times is undefined
    --- (and may result in either a error or the thread being perpetually yielded forever.)
    read next: (self: DelayChannel<T>) -> T,
    --- Clears all pending delayed messages from the delay queue
    read clear: (self: DelayChannel<T>) -> (),
}, {} :: {
    __len: (self: DelayChannel<T>) -> number,
}))

--- A handle to a delayed message in a DelayChannel, which can be used to cancel the message before it's sent
---
--- Note that the underlying key may change if the items expiry is too large (leading to the item being reinserted
--- periodically). This is not exposed to the user as it is an implementation detail.
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