local Primitives = require "@antiraid-core/primitives"
local Promise = require "@antiraid/promise"

--- Represents a scheduled execution
export type ScheduledExecution = {
    id: string,
    data: any,
    template_name: string,
    --- String representation of the time the event is scheduled to run at
    ---
    --- This can be converted to an ``@antiraid/datetime`` using Timezone:fromString
    run_at: string
}

export type ScheduledExecutionList = {ScheduledExecution}


export type CreateScheduledExecution = {
    id: string,
    data: any,
    --- String representation of the time the event is scheduled to run at
    ---
    --- This can be converted from an ``@antiraid/datetime`` using tostring
    run_at: string
}

--- Allows templates to schedule executions of themselves with a specific id and data sometime
--- in the future
---
--- A scheduled execution is a task that is executed once at (or after) a specific time or interval.
--- When a scheduled execution errors, the caller should *not* remove the scheduled execution
--- and should instead retry it at the next interval.
---
--- All scheduled executions have an ID and data associated with them for use by the caller.
export type ScheduledExecExecutor = {
    --- Lists all scheduled executions. If ``id`` is provided, then all scheduled executions
    --- with that ID will be returned. Note that only the soonest scheduled execution with a 
    --- given ID will actually be run however it is guaranteed that all will be stored and hence
    --- returned by this function.
    list: (self: ScheduledExecExecutor, id: string?) -> Promise.LuaPromise<ScheduledExecutionList>,

    --- Creates a new scheduled execution
    ---
    --- Note that scheduled executions are not guaranteed to be run at the exact time specified and
    --- may be slightly late. 
    ---
    --- Note that reusing the same ID will store both scheduled executions and will dispatch an 
    --- set of created scheduled executions with the same ID. While the number of elements in this set is 
    --- undefined, the set is guaranteed to not be the empty/null set
    ---
    --- The ordering in which scheduled executions are triggered about a small time period is undefined.
    --- It is recommended to use the ``task`` library for small time periods.
    create: (self: ScheduledExecExecutor, data: CreateScheduledExecution) -> Promise.LuaPromise<nil>,

    --- Deletes all scheduled execution with a given ID
    delete: (self: ScheduledExecExecutor, id: string) -> Promise.LuaPromise<nil>,
}

local function new(token: Primitives.TemplateContext): ScheduledExecExecutor
    error("Implemented internally in AntiRaid runtime!")
end

return {
    new = new
}