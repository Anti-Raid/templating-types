--- Syscall filterer
local Primitives = require"@antiraid-core/primitives"
local runtime = require"@antiraid-core/plugins/runtime"
local tloop = require"@antiraid-core/templateloop"
local tloopimpl = require"@antiraid-core/templateloop/impl"

export type JailOpts = {
    ops: {string},
    isblacklist: boolean
}

local function isoptallowed(jo: JailOpts, op: string) 
    local idx = table.find(jo.ops, op)
    -- found+blacklist=true, found+not blacklist (whitelist) = false
    if not idx then return jo.isblacklist else return not jo.isblacklist end
end

export type JailConfig = {
    discord: JailOpts,
    denyunsupported: boolean
}

-- Creates a new 'jailed' context with syscall limits
local function createjail(rootctx: Primitives.TemplateContext, jc: JailConfig): Primitives.TemplateContext 
    local innerctxref: Primitives.TemplateContext
    local function jailcall(innerctx: Primitives.TemplateContext, args: runtime.SyscallArgs): runtime.SyscallRet 
        assert(innerctx == innerctxref, "jailed context call from context that is not the jailed context")
        assert(type(args) == "table", "syscall arguments must be a table")
        assert(getmetatable(args) == nil, "jailed context call with arg containing a metatable")
        if args.op == "Discord" then 
            if not isoptallowed(jc.discord, args.req.op) then 
                error(`jailed context call attempted blacklisted op '{args.req.op}'`)
            end
        elseif jc.denyunsupported then
            error("unsupported syscall op")
        end
        return rootctx:syscall(args)
    end

    innerctxref = setmetatable({
        store = {},
        syscall = jailcall
    }, {__metatable = false})

    -- Setup inner tloop
    local rootloop = tloop.getRunningLoop(rootctx)
    tloopimpl.newloop(innerctxref, rootloop.common)

    return innerctxref
end

return createjail