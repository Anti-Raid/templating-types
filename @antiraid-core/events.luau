local discord = require("@discord-types/apiTypes")
local userinfo = require("@antiraid-core/plugins/userinfo")

--- Data sent when a builtin command is executed.
export type BuiltinCommandExecuteData = {
    command: string,
    user_id: discord.Snowflake,
    user_info: userinfo.UserInfo
}

--- Data sent when a permission check is performed.
export type PermissionCheckData = {
    perm: string,
    user_id: discord.Snowflake,
    user_info: userinfo.UserInfo
}

--- A moderation action to be performed.
export type ModerationAction = {
    Kick: {
        member: discord.GuildMemberObject
    }
} | {
    TempBan: {
        user: discord.UserObject,
        duration: number,
        prune_dmd: number
    }
} | {
    Ban: {
        user: discord.UserObject,
        prune_dmd: number
    }
} | {
    Unban: {
        user: discord.UserObject
    }
} | {
    Timeout: {
        member: discord.GuildMemberObject,
        duration: number -- Duration, in seconds
    }
} | {
    Prune: {
        user: discord.UserObject?,
        prune_opts: any,
        channels: {discord.Snowflake}
    }
}

--- Data sent when a moderation action is started.
export type ModerationStartEventData = {
    correlation_id: string, -- This will also be sent on ModerationEndEventData to correlate the events while avoiding duplication of data
    action: any,
    author: discord.GuildMemberObject,
    num_stings: number,
    reason: string?
}

--- Data sent when a moderation action is ended.
---
--- This will correlate with a ModerationStart's event data (to avoid duplication of data)
export type ModerationEndEventData = {
    correlation_id: string -- Will correlate with a ModerationStart's event data
}

--- Data sent when a key is updated externally (through the web dashboard etc)
---
--- NOTE: To avoid recursive template executions, this does not trigger on in-template
--- key-value updates
export type ExternalKeyUpdateEventData = {
    key_modified: string,
    author: discord.Snowflake,
    action: "create" | "update" | "delete"
}

--- Data sent when a scheduled execution is triggered.
export type ScheduledExecutionEventData = {
    id: string,
    data: any,
    --- String representation of the time the event is scheduled to run at
    ---
    --- This can be converted to an ``@antiraid/datetime`` using datetime.UTC:fromString
    run_at: string
}

return {}