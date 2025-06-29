local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local onEventGeneric = require("@antiraid-ext/events/dispatch").onEventGeneric
local settings = require("@antiraid-core/settings")
local arraymt = require("@antiraid/interop").array_metatable

local EMPTY_ARRAY = setmetatable({}, arraymt)

--- GetSettings
local function onGetSettings(event: Primitives.Event, callback: (data: events.ExternalKeyUpdateEventData) -> {settings.Setting}): {settings.Setting}
    return onEventGeneric(event, "AntiRaid.GetSettings", function(event)
        return callback(event.data)
    end) or EMPTY_ARRAY
end

return onGetSettings