--!strict

local ge = require "@antiraid-ext/executor"
local promise = require "@antiraid/promise"
local kv = require "@antiraid/kv"

local onceLocalTab: {[string]: string} = {} -- Stores local `once` calls to avoid re-execution

--- Runs a function only once, when the template is first ever 
--- executed
---
--- ``@antiraid/kv`` is used for persistence here to avoid rerunning
--- the function on worker restart
local function once<T>(ge: ge.GlobalExecutor, globalid: string, fn: () -> T): T?
    -- Check lock
    local id = "__once:" .. tostring(globalid)

    local hasRun = onceLocalTab[id]

    -- If done or if pending, return nil
    if hasRun == "done" or hasRun == "pending" then
        return nil
    end

    -- Lock in the vm itself to ensure yields cannot result in repeated calls to this function
    onceLocalTab[id] = "pending" -- Mark as pending to avoid re-entrant calls

    local ok, hasRunG = pcall(promise.yield, ge.kv:get(id))

    if not ok then 
        -- Release local lock
        onceLocalTab[id] = "error" -- Mark as error to avoid re-entrant calls
        error("once: Failed to check function initialization status for id: " .. id .. ": " .. tostring(hasRunG), 2)
    end
    
    -- Check if global status is already "done"
    if hasRunG == "done" then
        return nil -- The function has already run, so we can return early
    end

    local status, result = pcall(fn)
    if not status then
        -- Mark as error if the function fails
        onceLocalTab[id] = "error"
        error("once: Failed to execute function for id: " .. id .. ": " .. tostring(result), 2)
    end

    promise.yield(ge.kv:set(id, "done")) -- Set the status to done in the key-value store
    -- Unlock
    onceLocalTab[id] = "done" -- Mark as done to avoid locking
    return result
end

--- Runs a function only once for a given template version,
--- when the template is first ever executed.
---
--- ``@antiraid/kv`` is used for persistence here to avoid rerunning
--- the function on worker restart
---
--- **Difference from `once`**: This function concats `id` with the current template 
--- version to ensure that the function is executed once per version. This allows for new 
--- versions of a template to nullify the previous execution and run the function again if/when 
--- a new version is deployed.
local function oncePerVersion<T>(ge: ge.GlobalExecutor, id: string, version: string, fn: () -> T): T? 
    --- Use find to find all versions we've initialized for
    local foundRecords = promise.yield(ge.kv:find("__once:" .. id .. ":v%"))

    -- Check if the version already exists in the found records
    -- removing all previous records for the same id and version
    local foundKey = false
    for _, record in (foundRecords :: kv.KvRecordList) do
        if record.key == "__once:" .. id .. ":" .. version then
            -- The function has already run for this version, return early
            foundKey = true
        else 
            promise.yield(ge.kv:delete(record.key))
        end
    end

    if foundKey then
        return nil
    end

    local versionedId = id .. ":v" .. version 
    return once(ge, versionedId, fn) -- Call the existing once function with the versioned id
end

--- Runs a function only once, when the template is first ever 
--- executed. If the function errors, it will be re-executed on future runs
---
--- Unlike ``once``, this function is not persistent across worker restarts
local function onceLocal<T>(localid: string, fn: () -> T): T?
    local id = "__once:" .. tostring(localid)

    local hasRun = onceLocalTab[id]

    -- If done or if pending, return nil
    if hasRun == "done" or hasRun == "pending" then
        return nil
    end

    onceLocalTab[id] = "pending" -- Mark as pending to avoid re-entrant calls
    local status, result = pcall(fn) -- This may yield and hence run another template, so the pending set above is important to avoid re-entrant calls
    if not status then
        -- Handle the error
        onceLocalTab[id] = "error" -- Mark as error
        error("once: Failed to execute function for id: " .. id .. ": " .. tostring(result), 2)
    end
    onceLocalTab[id] = "done" -- Mark as done to avoid repeat calls
    return result -- Return the result of the function execution
end

return {
    once = once,
    oncePerVersion = oncePerVersion, -- Runs once per version
    onceLocal = onceLocal,
} 