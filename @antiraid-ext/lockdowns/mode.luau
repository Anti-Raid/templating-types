-- WIP/TODO
local discord = require("@discord-types/apiTypes")
local datetime = require("@antiraid/datetime")
local handle = require("./handle")
local Primitives = require"@antiraid-core/primitives"

export type Lockdown = {
    --[[
    pub id: uuid::Uuid,
    pub reason: String,
    pub r#type: Box<dyn LockdownMode>,
    pub data: serde_json::Value,
    pub created_at: chrono::DateTime<chrono::Utc>,
    ]]
    id: string,
    reason: string,
    type: LockdownMode,
    data: any, -- Data specific to the lockdown mode
    created_at: datetime.DateTime -- Creation time of the lockdown
}

--- Base lockdown mode data
export type BaseLockdownModeData = {
    guild: discord.GuildObject,
    channels: { [discord.Snowflake]: discord.ChannelObject },
    critical_roles: {discord.Snowflake},
    lockdowns: {Lockdown}
}

--- Extended lockdown mode data
export type ExtLockdownModeData = BaseLockdownModeData & {
    ctx: Primitives.TemplateContext,
    all_handles: handle.LockdownModeHandles,
    lockdown: Lockdown,
}

export type LockdownMode = {
    --- Returns the string form of the lockdown mode
    string_form: () -> string,

    --- The specificity of the lockdown mode. More specific lockdowns should have higher specificity
    ---
    --- The specificity is used to determine which lockdowns should be applied/reverted in the event of multiple lockdowns
    --- handling the same roles/channels
    specificity: () -> number,

    --- Tests that a lockdown mode can in fact work
    ---
    --- Should error if the lockdown mode cannot be applied
    test: (data: BaseLockdownModeData) -> (),

    --- Try to automatically fix any issues that may prevent the lockdown mode from being applied
    autofix: (data: BaseLockdownModeData) -> (),

    --- Sets up the lockdown mode, returning any data to be stored with the lockdown
    setup: (data: BaseLockdownModeData) -> any,

    --- Returns the sharable lockdown data
    shareable: (lockdown: Lockdown) -> any,

    --- Creates a new lockdown
    create: (data: ExtLockdownModeData) -> (),

    --- Reverts a lockdown
    revert: (data: ExtLockdownModeData) -> (),

    --- Returns the handle for the lockdown
    handle: (data: BaseLockdownModeData, lockdown: Lockdown) -> handle.LockdownModeHandle,
}

return {}