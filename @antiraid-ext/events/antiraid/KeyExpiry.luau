local Primitives = require("@antiraid-core/primitives")
local events = require("@antiraid-core/events")
local createTab = require("@antiraid-ext/events/dispatch").createTab

--- Run a callback when the `AntiRaid.KeyExpiry` event is triggered (a key is expired).
--- @param event The event to listen for.
--- @param callback The callback to run when the event is triggered. The callback will receive the `events.KeyExpiryEvent` data.
local function KeyExpiry(callback: (ctx: Primitives.TemplateContext, data: events.KeyExpiryEvent) -> ())
    return createTab("KeyExpiry", function(ctx)
        return callback(ctx, ctx:event().data)
    end)
end

return KeyExpiry