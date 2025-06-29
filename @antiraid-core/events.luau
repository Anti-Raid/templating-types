local discord = require("@discord-types/apiTypes")
local settings = require("@antiraid-core/settings")

--- Get settings event
export type GetSettingsEvent = {
    author: discord.Snowflake,
}

--- Setting execute event
export type SettingExecuteEvent = {
    --- ID of the setting being executed
    id: string,
    --- The author of the event
    author: discord.Snowflake,
    --- The operation being performed on the setting
    op: settings.OperationType,
    --- The fields
    fields: {[string]: any},
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

--- Data sent when a key expires.
export type KeyExpiryEvent = {
    id: string,
    key: string,
    scopes: {string}
}

return {}