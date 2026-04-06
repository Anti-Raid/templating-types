--!strict

--- Experimental in-luau implementation of event dispatching to templates based on event scopes
---
--- Extra stuff templateloop provides:
--- # Event subscription refcounting
--- Problem: when subscribing to events, it is often hard to know why an event is subscribed to 
--- (e.g. there is no refcount for event subscription). This can lead to situations where events are never unsubscribed
--- even when there are no consumers for them.
--- Solution: we maintain a map of event name to a set of "systems" that have subscribed to the event.
--- When a system subscribes to an event, we add it to the set. When it unsubscribes, we remove it from the set.
--- If the set is empty after removal, we remove the event from the tenant state entirely.
--- This way, we can ensure that events are only subscribed to when there are active consumers for them.

local Primitives = require"@antiraid-core/primitives"
local runtime = require"@antiraid-core/plugins/runtime"
local isolate = require"@antiraid-ext/isolate"
local channel = require"@antiraid/channel"
local datetime = require"@antiraid/datetime"
local templateloopImpl = require"@antiraid-core/templateloop"
local MutexFn = require"@antiraid-ext/sync/mutex"
local typesext = require"@antiraid/typesext"
local Discord = require"@antiraid-ext/system/discord"

-- Flags 

-- Other constants

--- How long to wait for template dispatch results before timing out and moving on (to avoid hanging the entire dispatch if a template is hanging)
local TEMPLATE_DISPATCH_TIMEOUT = datetime.timedelta_seconds(5) -- 5 seconds

-- Start code

--- @noyield
local function DebugManager(): templateloopImpl.DebugManager 
    if _G._debug then return { print = _G._debug } end
    return { print = function(...) end }
end

--- @noyield
local function TemplateLoopCommon(its: runtime.TenantState, ibtd: runtime.BaseTenantData): templateloopImpl.TemplateLoopCommon
    local ts = its
    local btd = ibtd
    local eventrefmu = MutexFn() -- Mutex for synchronizing access to event refs
    local function isSubscribed(event: string, system: string): boolean 
        return ts.events[event] ~= nil and ts.events[event][system] ~= nil
    end

    local function subscribeEvent(ctx: Primitives.TemplateContext, event: string, system: string, attachedop: runtime.StateOp?) 
        eventrefmu.call(function() 
            if isSubscribed(event, system) and not attachedop then return nil end
            local ops: {runtime.StateOp} = {}

            if not isSubscribed(event, system) then 
                table.insert(ops, {
                    op = "SubscribeEvent" :: "SubscribeEvent",
                    event = event,
                    system = system
                })
            end
            if attachedop then table.insert(ops, attachedop) end

            local res = ctx:syscall({
                op = "State",
                ops = ops
            })
            assert(res.op == "State", "internal error: State syscall did not return State op")
            if res.new_tenant_state then ts = res.new_tenant_state end
            return nil
        end)
    end

    local function unsubscribeEvent(ctx: Primitives.TemplateContext, event: string, system: string) 
        eventrefmu.call(function() 
            local res = ctx:syscall({
                op = "State",
                ops = {
                    {
                        op = "UnsubscribeEvent",
                        event = event,
                        system = system
                    }
                }
            })
            assert(res.op == "State", "internal error: State syscall did not return State op")
            if res.new_tenant_state then ts = res.new_tenant_state end
            return nil
        end)
    end

    return table.freeze{
        isSubscribed = isSubscribed,
        subscribeEvent = subscribeEvent,
        unsubscribeEvent = unsubscribeEvent,
        btd = btd,
        ts = ts
    }
end

--- @noyield
local function TemplateLoopManager(ctx: Primitives.TemplateContext, common: templateloopImpl.TemplateLoopCommon): templateloopImpl.TemplateLoopManager 
    local discord = Discord(ctx)
    local debugmanager = DebugManager()

    local exposedvfs = common.btd.base_vfs
    local attachedisolates: {[string]: isolate.Isolate} = {
        ["builtins"] = isolate.new("builtins", typesext.Vfs.newoverlay({
            exposedvfs.Builtins or error("Internal error: Builtins VFS not found in exposed VFSs"),
            exposedvfs.TemplatingTypes or error("Internal error: TemplatingTypes VFS not found in exposed VFSs"),
        }), {})
    } -- map of all attached isolates
    local attachedisolatescount = 1 -- initially only one attached isolate

    local function dispatchEvent(event: Primitives.Event, targetId: string?): {isolate.DispatchResult}
        if attachedisolatescount == 0 then return {} end -- unlikely but could happen

        -- Fast path: if there are no attached isolates besides builtins, we can avoid creating a new thread
        debugmanager.print("[TemplateLoopManager] Dispatching event", event.name, "to ", targetId and `with id {targetId}` or "with no target id")
        if attachedisolatescount == 1 then
            local _, isol = next(attachedisolates)
            assert(isol)
            if targetId and isol.id ~= targetId then return {} end -- Ignore non-targetted template
            local ret = isol.runEventResult(ctx, event)
            if ret.type == "err" then 
                debugmanager.print("[TemplateLoopManager] Error dispatching event to builtins template:", ret)
                return {ret}
            end
            return {ret}
        end
        
        local chan: channel.Stream<isolate.DispatchResult> = channel.Stream<<isolate.DispatchResult>>()
        local numitems = 0
        for _, isol in attachedisolates do
            if targetId and isol.id ~= targetId then
                continue -- Ignore non-targetted template
            end

            -- Dispatch event to isolate
            isol.dispatchEvent(ctx, event, chan)
            numitems += 1
        end

        local results, timedout = chan.rx:recvbatch(numitems, TEMPLATE_DISPATCH_TIMEOUT)
        if timedout == "timeout" then
            -- TODO: Log warning about timeout
        end
        return results
    end

    local function attachisolate(isolate: isolate.Isolate) 
        if isolate.id == "builtins" then error("cannot modify protected isolate `builtins`") end
        if attachedisolates[isolate.id] then 
            attachedisolates[isolate.id] = isolate
        else
            attachedisolates[isolate.id] = isolate 
            attachedisolatescount += 1
        end
    end

    local function detachisolate(id: string) 
        if id == "builtins" then error("cannot modify protected isolate `builtins`") end
        if not attachedisolates[id] then return end -- no op if not already attached
        attachedisolates[id] = nil 
        attachedisolatescount -= 1
    end

    local function subscribeEvent(event: string, system: string, attachedop: runtime.StateOp?) return common.subscribeEvent(ctx, event, system, attachedop) end
    local function unsubscribeEvent(event: string, system: string) return common.unsubscribeEvent(ctx, event, system) end

    return table.freeze{
        debugmanager = debugmanager,
        discord = discord,
        subscribeEvent = subscribeEvent,
        unsubscribeEvent = unsubscribeEvent,
        isSubscribed = common.isSubscribed,
        dispatchEvent = dispatchEvent,
        attachisolate = attachisolate,
        detachisolate = detachisolate,
        common = common,
        btd = common.btd
    }
end

--- @noyield
---
--- Creates a new TemplateLoopManager instance at initialization. Using this outside of initialization may fail or lead to hard-to-debug errors
---
--- Note: Do not use this outside of the initial loop creation
local function newinitloop(baseCtx: Primitives.TemplateContext, ts: runtime.TenantState, btd: runtime.BaseTenantData): templateloopImpl.TemplateLoopManager
    if baseCtx.store[templateloopImpl.TEMPLATE_LOOP_KEY] then error("cannot call newinitloop if context already exists") end
    local common = TemplateLoopCommon(ts, btd)
    local tlm = TemplateLoopManager(baseCtx, common)
    baseCtx.store[templateloopImpl.TEMPLATE_LOOP_KEY] = tlm
    return tlm
end

--- @noyield
---
--- Creates a new TemplateLoopManager instance and stores it in the underlying context
local function newloop(ctx: Primitives.TemplateContext, common: templateloopImpl.TemplateLoopCommon) 
    if ctx.store[templateloopImpl.TEMPLATE_LOOP_KEY] then error("cannot call newloop if context already exists") end
    local tlm = TemplateLoopManager(ctx, common)
    ctx.store[templateloopImpl.TEMPLATE_LOOP_KEY] = tlm
    return tlm
end

return {
    newinitloop = newinitloop,
    TemplateLoopManager = TemplateLoopManager,
    newloop = newloop
    -- Note that templateloopcommon is intentionally not exported as it should be reused from the currently running TemplateLoopManager
}