local Primitives = require("@antiraid-core/primitives")
local event = require("@antiraid-ext/event")
local cache = require("@antiraid-ext/cache")

type ModerationScope = {
    onStart: (event.ModerationStartEventData) -> (),
    onEnd: (event.ModerationStartEventData) -> (),
    onEndNoCorrelation: ((event.ModerationEndEventData) -> ())?,
}

local moderationsDone = cache.CachedTable.new() :: cache.CachedTable<string, event.ModerationStartEventData>

local function on(evt: Primitives.Event, scope: ModerationScope)
    event.onModerationStart(evt, function(data)
        moderationsDone:set(data.correlation_id, data, 60)
        scope.onStart(data) 
    end)

    event.onModerationEnd(evt, function(data)
        local modData = moderationsDone:get(data.correlation_id)
        moderationsDone:remove(data.correlation_id) -- Clear the data so we don't keep it around forever
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