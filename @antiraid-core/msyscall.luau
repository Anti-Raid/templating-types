--!strict
local khronosvalue = require "@antiraid-core/khronosvalue"
local runtime = require "@antiraid-core/plugins/runtime"

-- Re-export/Alias state types from runtime
export type Id = runtime.Id
export type StateOp = runtime.StateOp
export type StateExecResult = runtime.StateExecResult
export type TenantState = runtime.TenantState

-- types/auth.ts
export type UserSession = {
    id: string,
    name: string?,
    user_id: string,
    created_at: string,
    type: string,
    expiry: string,
}

export type AuthorizedSession = {
    user_id: string,
    id: string,
    state: string,
    type: string,
}

-- types/bot.ts
export type ShardConn = {
    status: string,
    latency: number,
}

export type BotStatus = {
    shard_conns: { [string]: ShardConn },
    total_guilds: number,
    total_users: number,
    uptime: number,
}

export type BotConfig = {
    support_server_invite: string,
    client_id: string,
}

-- types/discord.ts
export type DashboardGuild = {
    id: string,
    name: string,
    icon: string?,
    permissions: string,
    owner: boolean,
}

export type DashboardGuildData = {
    guilds: { DashboardGuild },
    guilds_exist: { boolean },
}

export type ApiPartialGuildChannel = {
    id: string,
    name: string,
    position: number,
    parent_id: string?,
    type: number,
}

export type GuildChannelWithPermissions = {
    user: string,
    bot: string,
    channel: ApiPartialGuildChannel,
}

export type ApiPartialRole = {
    id: string,
    name: string,
    position: number,
    permissions: string,
}

export type BaseGuildUserInfo = {
    owner_id: string,
    name: string,
    icon: string?,
    roles: { ApiPartialRole },
    user_roles: { string },
    bot_roles: { string },
    channels: { GuildChannelWithPermissions },
}

export type PartialUser = {
    id: string,
    username: string,
    global_name: string?,
    avatar: string?,
}

-- types/gkv.ts
export type PartialGlobalKv = {
    key: string,
    version: number,
    owner_id: string,
    owner_type: string,
    price: number?,
    short: string,
    public_metadata: khronosvalue.KhronosValue,
    scope: string,
    created_at: string,
    last_updated_at: string,
    public_data: boolean,
    review_state: string,
    long: string?,
    data: khronosvalue.KhronosValue?,
}

-- syscall/auth.ts
export type MAuthSyscall = 
    | { op: "CreateLoginSession", code: string, redirect_uri: string, code_verifier: string? }
    | { op: "CreateApiSession", name: string, expiry: number }
    | { op: "GetUserSessions" }
    | { op: "DeleteSession", session_id: string }

export type MAuthSyscallRet = 
    | { op: "CreatedSession", session: UserSession, token: string, user: PartialUser? }
    | { op: "UserSessions", sessions: { UserSession } }
    | { op: "Ack" }

-- syscall/bot.ts
export type MBotSyscall = 
    | { op: "GetBotCommands" }
    | { op: "GetBotConfig" }
    | { op: "GetBotStatus" }
    | { op: "DispatchEvent", id: Id, name: string, data: khronosvalue.KhronosValue }
    | { op: "GetBlobData", payload: string, signature: string }
    | { op: "AdminRelaxedDispatchEvent", id: Id, name: string, data: khronosvalue.KhronosValue, allow_non_web_event_names: boolean, allow_self_event: boolean, mock_id: string? }
    | { op: "AdminGetUncachedBotStatus" }
    | { op: "AdminDropTenant", id: Id }
    | { op: "AdminSetTenantStateModFlags", id: Id, modflags: number }
    | { op: "AdminState", id: Id, ops: { StateOp } }
    | { op: "AdminFetchTenantState", id: Id }

export type MBotSyscallRet = 
    | { op: "CommandList", commands: { any } }
    | { op: "BotConfig", support_server_invite: string, client_id: string }
    | { op: "BotStatus", status: BotStatus }
    | { op: "KhronosValue", data: khronosvalue.KhronosValue }
    | { op: "State", res: { StateExecResult }, new_tenant_state: TenantState? }
    | { op: "TenantState", ts: TenantState }
    | { op: "BlobData", data: khronosvalue.KhronosValue }
    | { op: "Ack" }

-- syscall/discord.ts
export type MDiscordSyscall = 
    | { op: "GetUserGuilds", refresh: boolean }
    | { op: "GetGuildInfo", guild_id: string }

export type MDiscordSyscallRet = 
    | { op: "UserGuilds", data: DashboardGuildData }
    | { op: "GuildInfo", data: BaseGuildUserInfo }

-- syscall/gkv.ts
export type MGkvSyscall = 
    | { op: "FindGlobalKvs", scope: string, query: string }
    | { op: "GetGlobalKv", scope: string, key: string, version: number }
    | { op: "AdminSetGlobalKvReviewState", key: string, version: number, scope: string, review_state: string }

export type MGkvSyscallRet = 
    | { op: "GlobalKvList", gkvs: { PartialGlobalKv } }
    | { op: "GlobalKv", gkv: PartialGlobalKv }
    | { op: "Ack" }

-- syscall/index.ts
export type MSyscallArgs = 
    | { op: "Auth", req: MAuthSyscall }
    | { op: "Bot", req: MBotSyscall }
    | { op: "Discord", req: MDiscordSyscall }
    | { op: "Gkv", req: MGkvSyscall }

export type MSyscallRet = 
    | { op: "Auth", data: MAuthSyscallRet }
    | { op: "Bot", data: MBotSyscallRet }
    | { op: "Discord", data: MDiscordSyscallRet }
    | { op: "Gkv", data: MGkvSyscallRet }

export type MSyscallError = 
    | { op: "Generic", message: string }
    | { op: "InvalidEvent", reason: string }
    | { op: "ContextInsecure" }
    | { op: "ContextRequiresUser" }
    | { op: "ContextRequiresOauth" }
    | { op: "BotNotOnGuild" }
    | { op: "UserOauth2Needed" }
    | { op: "AuthError", reason: any }
    | { op: "Unauthorized", reason: string }
    | { op: "EntityNotFound", reason: string }

return {}
