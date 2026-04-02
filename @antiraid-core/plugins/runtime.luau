--!strict

local datetime = require("@antiraid/datetime")
local typesext = require"@antiraid/typesext"
local blob = require"@antiraid-core/blob"
local khronosvalue = require "@antiraid-core/khronosvalue"
local discord = require("@discord-types/apiTypes")
local discordsys = require("@antiraid-core/plugins/discord")

--- A result from a state operation
export type StateExecResult = {
    op: "Kv",

    --- The key of the record.
    key: string,
    --- The value of the record. This can be any type, depending on what was stored.
    value: khronosvalue.KhronosValue,
    --- The scopes the key has
    scope: string,
    --- The timestamp when the record was created, in ISO 8601 format.
    created_at: datetime.DateTime,
    --- The timestamp when the record was last updated, in ISO 8601 format.
    last_updated_at: datetime.DateTime,
} | {
    op: "GlobalKv",

    read key: string,

    --- The version of the record
    read version: number,

    --- The owner id of the record (for global kvs, this is the tenant id)
    read owner_id: string,

    --- The owner type of the record (user or guild)
    read owner_type: string,

    --- Short description of the record
    read short: string,

    --- Public metadata about the key-value
    read public_metadata: any,

    --- Contents of vfs is readable or not (paid templates)
    read public_data: boolean,

    --- Review state of the record (pending, approved, rejected)
    read review_state: string,

    --- An optional long description of the record
    read long: string?,

    --- An optional price for the record (if the record is for sale)
    read price: number?,

    --- The timestamp when the record was created
    read created_at: datetime.DateTime,

    --- The timestamp when the record was last updated at
    read last_updated_at: datetime.DateTime,
} | {
    op: "GlobalKvData",
    data: any
} | {
    op: "GlobalKvDataOpaque",
    data: any, -- todo: add opaque type,
}

export type TenantState = {
    --- The list of events the guild is (globally) subscribed to
    events: {string},
    --- Flags (such as whether we need to load in more data etc.)
    flags: number
}

export type Id = {
    read tenant_type: "guild" | "user",
    read tenant_id: string
}

export type BaseTenantData = {
    read bot: discord.UserObject,
    read id: Id,
    read dispatchable_events: {string},
    read base_vfs: { [string]: typesext.Vfs }
}

export type StateOp = {
    op: "KvFind",
    query: string,
    scope: string
} | {
    op: "KvGet",
    key: string,
    scope: string
} | {
    op: "KvSet",
    key: string,
    scope: string,
    value: khronosvalue.KhronosValue
} | {
    op: "KvDelete",
    key: string,
    scope: string
} | {
    op: "UpdateTenantState",
    events: {string},
    flags: number
} | {
    op: "GlobalKvFind",
    query: string,
    scope: string
} | {
    op: "GlobalKvGet",
    key: string,
    version: number,
    scope: string
} | {
    op: "GlobalKvCreate",
    key: string,
    version: number,
    short: string,
    public_metadata: khronosvalue.KhronosValue,
    scope: string,
    public_data: boolean,
    long: string?,
    data: khronosvalue.KhronosValue
} | {
    op: "GlobalKvDelete",
    key: string,
    version: number,
    scope: string
}

--- Metadata about an object.
export type ObjectMetadata = {
    read key: string,
    read last_modified: datetime.DateTime?,
    read size: number,
    read etag: string?,
}

export type ObjectStorageCall = 
    | { op: "ListFileMetas", prefix: string? }
    | { op: "GetFileMeta", key: string }
    | { op: "GetFileUrl", key: string, expiry: datetime.TimeDelta }
    | { op: "DownloadFile", key: string }
    | { op: "UploadFile", key: string, data: blob.BlobTaker }
    | { op: "DeleteFile", key: string }

export type ObjectStorageResult = 
    | { op: "ObjectMetadata", objs: { ObjectMetadata } }
    | { op: "FileUrl", url: string }
    | { op: "Blob", data: blob.Blob }
    | { op: "Ack" }

export type CdnCall = { op: "DownloadFile", url: string, as_buffer: boolean } -- only discord cdn urls are supported

export type CdnResult = { op: "Blob", data: blob.Blob } | { op: "Buffer", data: buffer }

--- The arguments to be passed into a system call
export type SyscallArgs = {
    op: "State",
    --- A set of 'state operations' to perform. Depending on implementation, this may end up performing a call
    --- into the master via grpc or otherwise (hence making 'State' ops expensive) but this purely a implementation
    --- detail that can and likely will change in the future
    ---
    --- # Guarantees 
    --- Antiraid guarantees that all 'state operations'
    --- of 'ops' will be performed atomically. That is, if any op in `ops` fails, the entire observable 
    --- db state remains unchanged/all changes from `op` are roll-backed.
    ops: {StateOp}
} | {
    op: "ObjectStorage",
    --- Object storage is mainly useful over kv when dealing with blobs of data
    --- (otherwise, kv is better+easier to use as it has support for serializing most AntiRaid types
    --- along with atomicity guarantees). 
    ---
    --- As an example, datetimes should be stored using kv for automatic
    --- conversion to/from the storage bit for you while object storage can be used for storing
    --- backups etc.
    ---
    --- Object storage also works over HTTP calls and may be slower than key-value which 
    --- may use a custom binary protocol or other optimizations
    req: ObjectStorageCall
} | {
    op: "Cdn",
    --- Cdn allows for downloading Discord CDN urls *only*
    req: CdnCall
} | {
    op: "Discord",
    req: discordsys.DiscordRequest
}

export type SyscallRet = {
    op: "State",
    res: {StateExecResult}
} | {
    op: "ObjectStorage",
    res: ObjectStorageResult
} | {
    op: "Cdn",
    res: CdnResult
} | {
    op: "Discord",
    req: discordsys.DiscordResponse
}

--- Runtime plugin provides basic hooks into the AntiRaid template-worker runtime
export type Plugin = {
    --- @yields
    ---
    --- Performs a system call
    syscall: (self: Plugin, args: SyscallArgs) -> SyscallRet,

    --- @yields
    ---
    --- Returns the statistics of the bot.
    stats: (self: Plugin) -> {
        total_cached_guilds: number,
        total_guilds: number,
        total_users: number,
        last_started_at: datetime.DateTime,
    },

    --- Returns various important links
    --- of the bot
    links: (self: Plugin) -> {
        support_server: string,
        api_url: string,
        frontend_url: string,
        docs_url: string,
    },
}

return {}