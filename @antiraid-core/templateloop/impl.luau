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
local LazyLoad = require"@antiraid-ext/sync/lazyload"
local typesext = require"@antiraid/typesext"
local Discord = require"@antiraid-ext/system/discord"

-- Flags 

-- Other constants

--- How long to wait for template dispatch results before timing out and moving on (to avoid hanging the entire dispatch if a template is hanging)
local TEMPLATE_DISPATCH_TIMEOUT = datetime.timedelta_seconds(5) -- 5 seconds

-- Start code

-- stdout logging for debugging
local function DebugManager(): templateloopImpl.DebugManager 
    if _G._debug then return { print = _G._debug } end
    return { print = function(...) end }
end

type Args = {
    ctx: Primitives.TemplateContext,
    ts: runtime.TenantState,
    btd: runtime.BaseTenantData
}

--- Creates a new TemplateLoopManager instance
local lazyloader = LazyLoad(function(args: Args)
    local baseCtx = args.ctx
    local ts = args.ts
    local btd = args.btd
    local discord = Discord(baseCtx)

    -- Setup base state
    local self = {}
    baseCtx.store[templateloopImpl.TEMPLATE_LOOP_KEY] = self

    local debugmanager = DebugManager()
    local eventrefmu = MutexFn() -- Mutex for synchronizing access to event refs

    local exposedvfs = btd.base_vfs
    local attachedisolates: {[string]: isolate.Isolate} = {
        ["builtins"] = isolate.new("builtins", typesext.Vfs.newoverlay({
            exposedvfs.Builtins or error("Internal error: Builtins VFS not found in exposed VFSs"),
            exposedvfs.TemplatingTypes or error("Internal error: TemplatingTypes VFS not found in exposed VFSs"),
        }), {})
    } -- map of all attached isolates
    local attachedisolatescount = 1 -- initially only one attached isolate

    local function isSubscribed(event: string, system: string): boolean 
        return ts.events[event] ~= nil and ts.events[event][system] ~= nil
    end

    local function subscribeEvent(event: string, system: string, attachedop: runtime.StateOp?) 
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

            local res = baseCtx:syscall({
                op = "State",
                ops = ops
            })
            assert(res.op == "State", "internal error: State syscall did not return State op")
            if res.new_tenant_state then ts = res.new_tenant_state end
            return nil
        end)
    end

    local function unsubscribeEvent(event: string, system: string) 
        eventrefmu.call(function() 
            local res = baseCtx:syscall({
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

    local function dispatchEvent(event: Primitives.Event, targetId: string?): {isolate.DispatchResult}
        if attachedisolatescount == 0 then return {} end -- unlikely but could happen

        -- Fast path: if there are no attached isolates besides builtins, we can avoid creating a new thread
        debugmanager.print("[TemplateLoopManager] Dispatching event", event.name, "to ", targetId and `with id {targetId}` or "with no target id")
        if attachedisolatescount == 1 then
            local _, isol = next(attachedisolates)
            assert(isol)
            if targetId and isol.id ~= targetId then return {} end -- Ignore non-targetted template
            local ret = isol.runEventResult(baseCtx, event)
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
            isol.dispatchEvent(baseCtx, event, chan)
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

    self.debugmanager = debugmanager
    self.btd = btd
    self.discord = discord
    self.subscribeEvent = subscribeEvent
    self.unsubscribeEvent = unsubscribeEvent
    self.isSubscribed = isSubscribed
    self.dispatchEvent = dispatchEvent
    self.attachisolate = attachisolate
    self.detachisolate = detachisolate

    return self
end)

--- Creates a new TemplateLoopManager instance if it doesn't already exist, otherwise creates one
local function TemplateLoopManager(baseCtx: Primitives.TemplateContext, ts: runtime.TenantState, btd: runtime.BaseTenantData): templateloopImpl.TemplateLoopManager
    local existing = baseCtx.store[templateloopImpl.TEMPLATE_LOOP_KEY] :: templateloopImpl.TemplateLoopManager?
    if existing then return existing end
    return lazyloader.get({ ctx = baseCtx, ts = ts, btd = btd }) -- The lazyloader autosets the value into the store automatically
end

return TemplateLoopManager