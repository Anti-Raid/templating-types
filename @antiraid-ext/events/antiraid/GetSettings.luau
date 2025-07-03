local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local onEventGeneric = require("@antiraid-ext/events/dispatch").onEventGeneric
local settings = require("@antiraid-core/settings")

type Result =  {
    isGetSettings: true,
    data: {settings.Setting},
} | {
    isGetSettings: false,
}

--- GetSettings
local function onGetSettings(event: Primitives.Event, callback: (data: events.GetSettingsEvent) -> {settings.Setting}): Result
    return onEventGeneric(event, "AntiRaid.GetSettings", function(event)
        return {isGetSettings = true :: true, data = callback(event.data) }
    end) or { isGetSettings = false :: false }
end

return onGetSettings