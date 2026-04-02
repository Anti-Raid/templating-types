local datetime = require"@antiraid/datetime"

export type StreamSender<T> = {
    --- Once called, sends a value to the channel ignoring any errors
    read send: (self: StreamSender<T>, message: T) -> (),
    --- Once called, sends a value to the channel erroring if the channel is already closed
    read sendstrict: (self: StreamSender<T>, message: T) -> (),
    --- Returns if the underlying stream channel is closed
    read isclosed: (self: StreamSender<T>) -> boolean,
}

--- A oneshot channel allows sending and receiving a single value across tasks (Lua threads etc.)
export type StreamReceiver<T> = {
    --- Waits for a value to be sent to the channel and receives it.
    read recv: (self: StreamReceiver<T>) -> T,
    --- Waits for a value to be sent to the channel and receives it, with a timeout.
    read recvtimeout: (self: StreamReceiver<T>, timeout: datetime.TimeDelta) -> T,
    --- Waits for a batch of messages or until timeout
    read recvbatch: (self: StreamReceiver<T>, expecteditems: number, timeout: datetime.TimeDelta) -> ({T}, "completed" | "closed" | "timeout")
}

export type Stream<T> = {
    read tx: StreamSender<T>,
    read rx: StreamReceiver<T>
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

local function Stream<T>(): Stream<T>
    error("Implemented internally in AntiRaid runtime!")
end

local function DelayChannel<T>(): DelayChannel<T>
    error("Implemented internally in AntiRaid runtime!")
end

return {
    Stream = Stream,
    DelayChannel = DelayChannel,
}