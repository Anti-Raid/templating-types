local Primitives = require("@antiraid-core/primitives")
local createTab = require("@antiraid-ext/events/dispatch").createTab
local events = require"@antiraid-core/events"

local function ListLogEntries(callback: (ctx: Primitives.TemplateContext, event: events.GetLogEntriesEvent) -> ())
    return createTab("GetLogEntries", function(ctx, event)
        return callback(ctx, event.data)
    end)
end

return ListLogEntries