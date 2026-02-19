--!strict
local Primitives = require"@antiraid-core/primitives"
local KeyExpiryManager = require "@antiraid-ext/keyexpirymanager"
local datetime = require"@antiraid/datetime"
local typesext = require"@antiraid/typesext"
local tloop = require"@antiraid-core/templateloop"

export type CheckpointContext<Data> = {
    --- The ID of the checkpoint, used to identify the checkpoint when resuming
    id: string,
    --- The template context
    tctx: Primitives.TemplateContext,
    --- Returns if we are resuming from a checkpoint
    resumed: boolean,
    --- slate stores temporary data for the checkpoint step
    slate: {[string]: any},
    --- The intermediate data for the checkpoint. This will be passed to each step function and can be used to store any data needed to resume the task.
    data: () -> Data,
    --- Save the intermediate state of the checkpoint. This will be used to resume from in the event of an interruption/crash/etc.
    save: (data: Data) -> (),
}

export type CheckpointStep<Data> = {
    step: string, -- Unique identifier for the step. Used to determine where to resume from.
    fn: (ctx: CheckpointContext<Data>) -> Data?,
}

export type CheckpointManager<Data> = {
    --- Creates a new checkpoint
    new: (initialdata: Data) -> ()
}

type DataWithStep<Data> = {
    step: string,
    data: Data,
}

--- Manages checkpoints for long-running tasks that may need to be resumed in the event of a VM crash etc.
---
--- @param ctx The template context
--- @param baseid A unique identifier for the checkpoint manager to allow different checkpoint managers to coexist/operate independently
--- @param expiry The amount of time after which checkpoints should expire and be automatically deleted. This is to prevent clutter and potential security issues from old checkpoints lingering around indefinitely.
--- @param steps The steps of the checkpoint, in order. Each step should have a unique step identifier. When resuming from a checkpoint, the step identifier will be used to determine which step to resume from.
local function CheckpointManager<Data>(ctx: Primitives.TemplateContext, baseid: string, expiry: datetime.TimeDelta, steps: {CheckpointStep<Data>}): CheckpointManager<Data>
    if #steps == 0 then error("Checkpoint must have at least one step") end
    local loop = tloop.getRunningLoop(ctx)

    local function loadinner(id: string, idatawithstep: DataWithStep<Data>, resumed: boolean, kexm: KeyExpiryManager.KeyExpiryManager) 
        local atstep = false
        
        -- May be mutated in place
        local datawithstep = idatawithstep

        local cctx: CheckpointContext<Data>
        cctx = {
            tctx = ctx,
            data = function() return datawithstep.data end,
            id = id,
            resumed = resumed,
            slate = {},
            save = function(newdata: Data) 
                datawithstep.data = newdata
                kexm.updatedata(id, datawithstep)
            end
        }
        for i, step in steps do 
            if step.step == datawithstep.step then atstep = true end -- We got the step
            if atstep then 
                local ok, res = xpcall(step.fn, debug.traceback :: any, cctx)
                if not ok then 
                    loop.debugmanager.print("[CheckpointManager] Error in checkpoint step", step.step, "for checkpoint", id, ":", res)
                    kexm.remove(id) -- Remove checkpoint on error to prevent getting stuck
                    error(res)
                else 
                    -- Look for next step
                    local nextstep = steps[i + 1]
                    if nextstep then
                        datawithstep.step = nextstep.step -- always update step to next
                        if res ~= nil then datawithstep.data = res end -- update data if step function returned new data
                        kexm.updatedata(id, datawithstep)
                    end
                end
            end
        end

        kexm.remove(id) -- No more steps, remove checkpoint
    end

    local kexm = KeyExpiryManager(ctx, "checkpoints/"..baseid, function(loop, record)
        return nil
    end, function(loop, records, kexm) 
        assert(kexm, "Internal error: kexm should not be nil in checkpoint manager callback")
        -- On init, resume any checkpoints
        loop.debugmanager.print("[CheckpointManager] Resuming checkpoints", records, "id:", baseid)
        for _, record in records do 
            local id = record.key
            local datawithstep = record.value :: DataWithStep<Data>
            task.spawn(loadinner, id, datawithstep, true, kexm)
        end
        return nil
    end)
    
    local function new(initialdata: Data) 
        -- Implementation goes here
        local id = typesext.randstring(32)
        local currstep = steps[1].step
        local data: DataWithStep<Data> = {
            step = currstep,
            data = initialdata,
        }

        -- Store checkpoint and start the process
        kexm.add(expiry, data, id)
        loadinner(id, data, false, kexm)
    end

    local self = {}
    self.new = new
    return self
end

return CheckpointManager