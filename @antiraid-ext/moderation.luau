local Primitives = require("@antiraid-core/primitives")
local ModerationStart = require("@antiraid-ext/events/antiraid/ModerationStart")
local ModerationEnd = require("@antiraid-ext/events/antiraid/ModerationEnd")
local events = require("@antiraid-core/events")
local cache = require("@antiraid-ext/cache")

type ModerationScope = {
    onStart: (events.ModerationStartEventData) -> (),
    onEnd: (events.ModerationStartEventData) -> (),
    onEndNoCorrelation: ((events.ModerationEndEventData) -> ())?,
}

local moderationsDone = cache.CachedTable.new() :: cache.CachedTable<string, events.ModerationStartEventData>

local function on(evt: Primitives.Event, scope: ModerationScope)
    ModerationStart(evt, function(data)
        moderationsDone:set(data.correlation_id, data, 60)
        scope.onStart(data) 
    end)

    ModerationEnd(evt, function(data)
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