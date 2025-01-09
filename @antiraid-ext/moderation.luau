local Primitives = require("@antiraid-core/primitives")
local event = require("@antiraid-ext/event")

type ModerationScope = {
    onStart: (event.ModerationStartEventData) -> (),
    onEnd: (event.ModerationStartEventData) -> (),
    onEndNoCorrelation: ((event.ModerationEndEventData) -> ())?,
}

local moderationsDone: {[string]: event.ModerationStartEventData} = {}

local function on(evt: Primitives.Event, scope: ModerationScope)
    event.onModerationStart(evt, function(data)
        moderationsDone[data.correlation_id] = data
        scope.onStart(data)
    end)

    event.onModerationEnd(evt, function(data)
        local modData = moderationsDone[data.correlation_id]
        moderationsDone[data.correlation_id] = nil -- Clear the data so we don't keep it around forever
        if modData == nil then
            if scope.onEndNoCorrelation ~= nil then
                scope.onEndNoCorrelation(data)
            end
            return
        end

        scope.onEnd(modData)
    end)
end

return {
    on = on,
}