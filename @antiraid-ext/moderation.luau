local Primitives = require("@antiraid-core/primitives")
local event = require("@antiraid-ext/event")

type ModerationScope = {
    onStart: (event.ModerationStartEventData) -> (),
    onEnd: (event.ModerationStartEventData) -> (),
    onEndNoCorrelation: ((event.ModerationEndEventData) -> ())?,
}

type ModerationsDoneData = {
    evt: event.ModerationStartEventData,
    removeThread: thread
}

local moderationsDone: {[string]: ModerationsDoneData} = {}

local function on(evt: Primitives.Event, scope: ModerationScope)
    event.onModerationStart(evt, function(data)
        local removeThread = task.delay(60, function() 
            moderationsDone[data.correlation_id] = nil -- Clear the data so we don't keep it around forever
        end)    
        moderationsDone[data.correlation_id] = {
            evt = data,
            removeThread = removeThread,
        }
        scope.onStart(data) 
    end)

    event.onModerationEnd(evt, function(data)
        local modData = moderationsDone[data.correlation_id]
        task.cancel(modData.removeThread)
        moderationsDone[data.correlation_id] = nil -- Clear the data so we don't keep it around forever
        if modData == nil then
            if scope.onEndNoCorrelation ~= nil then
                scope.onEndNoCorrelation(data)
            end
            return
        end

        scope.onEnd(modData.evt)
    end)
end

return {
    on = on,
}