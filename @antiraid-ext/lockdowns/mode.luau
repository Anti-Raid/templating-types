-- WIP/TODO
export type LockdownMode = {
    --- Returns the string form of the lockdown mode
    string_form: () -> string,

    --- The specificity of the lockdown mode. More specific lockdowns should have higher specificity
    ---
    --- The specificity is used to determine which lockdowns should be applied/reverted in the event of multiple lockdowns
    --- handling the same roles/channels
    specificity: () -> number,
}