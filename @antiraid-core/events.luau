local discord = require("@discord-types/apiTypes")
local userinfo = require("@antiraid/userinfo")

--[[#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct BuiltinCommandExecuteData {
    pub command: String,
    pub user_id: serenity::all::UserId,
    pub user_info: crate::userinfo::UserInfo,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct PermissionCheckData {
    pub perm: kittycat::perms::Permission,
    pub user_id: serenity::all::UserId,
    pub user_info: crate::userinfo::UserInfo,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
#[serde(tag = "action")]
pub enum ModerationAction {
    Kick {
        member: serenity::all::Member, // The target to kick
    },
    TempBan {
        user: serenity::all::User, // The target to ban
        duration: u64,             // Duration, in seconds
        prune_dmd: u8,
    },
    Ban {
        user: serenity::all::User, // The target to ban
        prune_dmd: u8,
    },
    Unban {
        user: serenity::all::User, // The target to unban
    },
    Timeout {
        member: serenity::all::Member, // The target to timeout
        duration: u64,                 // Duration, in seconds
    },
    Prune {
        user: Option<serenity::all::User>,
        prune_opts: serde_json::Value,
        channels: Vec<serenity::all::ChannelId>,
    },
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct ModerationStartEventData {
    pub correlation_id: sqlx::types::Uuid, // This will also be sent on ModerationEndEventData to correlate the events while avoiding duplication of data
    pub action: ModerationAction,
    pub author: serenity::all::Member,
    pub num_stings: i32,
    pub reason: Option<String>,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct ModerationEndEventData {
    pub correlation_id: sqlx::types::Uuid, // Will correlate with a ModerationStart's event data
}
]]--

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