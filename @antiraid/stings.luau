local Primitives = require "@antiraid-core/primitives"
local Promise = require "@antiraid/promise"

--- A type representing a new sting to be created.
export type StingCreate = {
    --- The source of the sting.
    src: string?,
    --- The number of stings.
    stings: number,
    --- The reason for the stings.
    reason: string?,
    --- The reason the stings were voided.
    void_reason: string?,
    --- The guild ID the sting targets. MUST MATCH THE GUILD ID THE TEMPLATE IS RUNNING ON
    guild_id: string,
    --- The creator of the sting. Must be either 'system' or 'user:{user_id}'
    creator: string,
    --- The target of the sting. Must be either 'system' or 'user:{user_id}'
    target: string,
    --- The state of the sting.
    state: "active" | "voided" | "handled",
    --- When the sting expires as a duration. Format: {duration}{unit} e.g. 1d, 1h, 1m, 1s
    duration: string?,
    --- The data/metadata present within the sting, if any.
    sting_data: any?,
}

--- A type representing a sting.
export type Sting = {
    --- The ID of the sting.
    id: string,
    --- The source of the sting.
    src: string?,
    --- The number of stings.
    stings: number,
    --- The reason for the stings.
    reason: string?,
    --- The reason the stings were voided.
    void_reason: string?,
    --- The guild ID the sting targets. MUST MATCH THE GUILD ID THE TEMPLATE IS RUNNING ON
    guild_id: string,
    --- The creator of the sting. Must be either 'system' or 'user:{user_id}'
    creator: string,
    --- The target of the sting. Must be either 'system' or 'user:{user_id}'
    target: string,
    --- The state of the sting.
    state: "active" | "voided" | "handled",
    --- When the sting expires as a duration. Format: {duration}{unit} e.g. 1d, 1h, 1m, 1s
    duration: string?,
    --- The data/metadata present within the sting, if any.
    sting_data: any?,
    --- The log of the sting as it was being handled internally by AntiRaid's internal systens
    handle_log: any?,
}

export type StingExecutor = {
    --- Lists a page of stings. The number of stings per page is undefined at this time
    --- @param page number The page to list
    --- @return Promise.LuaPromise<{Sting}> The list of stings
    list: (self: StingExecutor, page: number) -> Promise.LuaPromise<{Sting}>,
    --- Gets a sting by its ID
    --- @param id string The ID of the sting
    --- @return Promise.LuaPromise<Sting> The sting
    get: (self: StingExecutor, id: string) -> Promise.LuaPromise<Sting>,
    --- Creates a new sting
    --- @param data StingCreate The data to create the sting with
    --- @return Promise.LuaPromise<string> The ID of the created sting
    create: (self: StingExecutor, data: StingCreate) -> Promise.LuaPromise<string>,
    --- Updates a sting 
    --- @param data Sting The data to update the sting with. Note that the ID of the sting must exist in DB and the previous sting
    --- with said ID will be replaced with ``data``.
    --- @return Promise.LuaPromise<nil>
    update: (self: StingExecutor, data: Sting) -> Promise.LuaPromise<nil>,
    --- Deletes a sting by its ID
    --- @param id string The ID of the sting
    --- @return Promise.LuaPromise<nil>
    delete: (self: StingExecutor, id: string) -> Promise.LuaPromise<nil>,
}

local function new(token: Primitives.TemplateContext): StingExecutor
    error("Implemented internally in AntiRaid runtime!")
end

return {
    new = new
}