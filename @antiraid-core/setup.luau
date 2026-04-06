--!strict

local Primitives = require"@antiraid-core/primitives"
local runtime = require"@antiraid-core/plugins/runtime"
local isolate = require"@antiraid-ext/isolate"
local channel = require"@antiraid/channel"
local datetime = require"@antiraid/datetime"
local MutexFn = require"@antiraid-ext/sync/mutex"
local typesext = require"@antiraid/typesext"
local Discord = require"@antiraid-ext/system/discord"

-- Flags 

-- Other constants

--- How long to wait for template dispatch results before timing out and moving on (to avoid hanging the entire dispatch if a template is hanging)
local TEMPLATE_DISPATCH_TIMEOUT = datetime.timedelta_seconds(5) -- 5 seconds

-- Start code

--- @noyield
local function dummyprint() 
    if _G._debug then return _G._debug end
    return function(...) end
end

--- @noyield
local function EventManager(ctx: Primitives.TemplateContext): Primitives.EventManager
    local eventrefmu = MutexFn() -- Mutex for synchronizing access to event refs
    local exposedvfs = ctx.btd().base_vfs
    local attachedisolates: {[string]: Primitives.Dispatchable} = {
        ["builtins"] = isolate.new("builtins", typesext.Vfs.newoverlay({
            exposedvfs.Builtins or error("Internal error: Builtins VFS not found in exposed VFSs"),
            exposedvfs.TemplatingTypes or error("Internal error: TemplatingTypes VFS not found in exposed VFSs"),
        }), {})
    } -- map of all attached isolates
    local attachedisolatescount = 1 -- initially only one attached isolate

    local function isSubscribed(event: string, system: string): boolean 
        local ts = ctx.tenantstate()
        return ts.events[event] ~= nil and ts.events[event][system] ~= nil
    end

    local function subscribe(event: string, system: string, attachedop: runtime.StateOp?) 
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

            local res = ctx.syscall({
                op = "State",
                ops = ops
            })
            assert(res.op == "State", "internal error: State syscall did not return State op")
            return nil
        end)
    end

    local function unsubscribe(event: string, system: string) 
        eventrefmu.call(function() 
            local res = ctx.syscall({
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
            return nil
        end)
    end

    local function dispatch(event: Primitives.Event, targetId: string?): {Primitives.DispatchResult}
        if attachedisolatescount == 0 then return {} end -- unlikely but could happen

        -- Fast path: if there are no attached isolates besides builtins, we can avoid creating a new thread
        ctx.debug("[TemplateLoopManager] Dispatching event", event.name, "to ", targetId and `with id {targetId}` or "with no target id")
        if attachedisolatescount == 1 then
            local _, isol = next(attachedisolates)
            assert(isol)
            if targetId and isol.id ~= targetId then return {} end -- Ignore non-targetted template
            local ret = isol.runEventResult(ctx, event)
            if ret.type == "err" then 
                ctx.debug("[TemplateLoopManager] Error dispatching event to builtins template:", ret)
                return {ret}
            end
            return {ret}
        end
        
        local chan: channel.Stream<Primitives.DispatchResult> = channel.Stream<<Primitives.DispatchResult>>()
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

    local function attach(isolate: Primitives.Dispatchable) 
        if isolate.id == "builtins" then error("cannot modify protected isolate `builtins`") end
        if attachedisolates[isolate.id] then 
            attachedisolates[isolate.id] = isolate
        else
            attachedisolates[isolate.id] = isolate 
            attachedisolatescount += 1
        end
    end

    local function detach(id: string) 
        if id == "builtins" then error("cannot modify protected isolate `builtins`") end
        if not attachedisolates[id] then return end -- no op if not already attached
        attachedisolates[id] = nil 
        attachedisolatescount -= 1
    end

    return table.freeze{
        isSubscribed = isSubscribed,
        subscribe = subscribe,
        unsubscribe = unsubscribe,
        dispatch = dispatch,
        attach = attach,
        detach = detach
    }
end

--- @noyield
---
--- Creates a new TemplateLoopManager instance at initialization. Using this outside of initialization may fail or lead to hard-to-debug errors
---
--- Note: Do not use this outside of the initial loop creation
local function newinitloop(syscall: runtime.RawSyscall, ts: runtime.TenantState, btd: runtime.BaseTenantData): Primitives.TemplateContext
    local tenantstate = ts
    local function dosyscall(args: runtime.SyscallArgs): runtime.SyscallRet
        local res = syscall:async(args)
        if res.op == "State" and res.new_tenant_state then tenantstate = res.new_tenant_state end
        return res
    end
    local function dobtd() return btd end
    local function dotenantstate() return tenantstate end
    local eventmanager: Primitives.EventManager
    local discord: Discord.DiscordClient
    local ctx: Primitives.TemplateContext = {
        syscall = dosyscall,
        btd = dobtd,
        tenantstate = dotenantstate,
        debug = dummyprint(),
        loop = eventmanager,
        discord = discord
    }
    eventmanager = EventManager(ctx)
    discord = Discord(ctx)

    local ctxany = ctx :: any
    ctxany.discord = discord
    ctxany.loop = eventmanager
    
    return ctx    
end

return {
    newinitloop = newinitloop,
    EventManager = EventManager,
    Discord = Discord
}