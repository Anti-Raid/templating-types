local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local onEventGeneric = require("@antiraid-ext/events/dispatch").onEventGeneric
local settings = require("@antiraid-core/settings")

export type Result =  {
    isGetSettings: true,
    data: {settings.Setting},
} | {
    isGetSettings: false,
}

--- Run a callback when the `AntiRaid.GetSettings` event is triggered (a user requests the list of settings from the server).
--- @param event The event to listen for.
--- @param callback The callback to run when the event is triggered. The callback will receive the `events.GetSettingsEvent` data and is expected to return a list of settings to be displayed to the user
--- @return Result The result of the operation, containing a list of settings if successful
local function onGetSettings(event: Primitives.Event, callback: (data: events.GetSettingsEvent) -> {settings.Setting}): Result
    return onEventGeneric(event, "AntiRaid.GetSettings", function(event)
        return {isGetSettings = true :: true, data = callback(event.data) }
    end) or { isGetSettings = false :: false }
end

return onGetSettings