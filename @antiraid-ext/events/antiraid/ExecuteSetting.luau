local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- Run a callback when the `AntiRaid.ExecuteSetting` event is triggered.
--- @param event The event to listen for.
--- @param callback The callback to run when the event is triggered. The callback will receive the `events.SettingExecuteEvent` data.
--- @return data The data returned by the callback.
local function ExecuteSetting(callback: (ctx: Primitives.TemplateContext, data: events.SettingExecuteEvent) -> any)
    return createTab("ExecuteSetting", function(ctx)
        return callback(ctx, ctx:event().data)
    end) 
end

return ExecuteSetting