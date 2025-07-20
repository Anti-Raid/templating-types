local typesext = require "@antiraid/typesext"
local ButtonBuilder = require"@discord-types/builders/message/components/button"
local ActionRowBuilder = require "@discord-types/builders/message/components/actionRow"
local apitypes = require "@discord-types/apiTypes"
local interactionutils = require "@antiraid-ext/utils/interaction"
local frameworktypes = require "@antiraid-ext/framework/coretypes"
local extractUserIdFromInteraction = require "@antiraid-ext/utils/modhierarchy".extractUserIdFromInteraction

export type PaginationOpts = {
    id: string,
    embed: (currentIdx: number) -> apitypes.EmbedObject,
    numPages: number,
    timeToExpiry: number? -- Optional, defaults to 120 seconds
}

local function paginate(data: frameworktypes.RunData, opts: PaginationOpts): ()
    local currentIdx = 1
    local timeToExpiry = opts.timeToExpiry or 120 -- Default to 120 seconds if not provided

    local jlPrevId = `{opts.id}:${typesext.randstring(16)}`
    local jlNextId = `{opts.id}:${typesext.randstring(16)}`

    local prevButton = ButtonBuilder.new()
    :setStyle("Grey")
    :setLabel("Previous Page")
    :setCustomId(jlPrevId)

    local nextButton = ButtonBuilder.new()
    :setStyle("Grey")
    :setLabel("Next Page")
    :setCustomId(jlNextId)
    
    task.delay(timeToExpiry, function() 
        data.dropButtonCallback(jlPrevId) -- Make sure to remove the callback so it doesn't get called again
        data.dropButtonCallback(jlNextId) -- Make sure to remove the callback so it doesn't get called again
    end)  

    local userid = extractUserIdFromInteraction(data.interaction) -- Current user id who invoked pagination
    data.attachButtonCallback(jlPrevId, function(data: frameworktypes.ButtonCallbackData): nil 
        local interactor = extractUserIdFromInteraction(data.interaction)
        if userid ~= interactor then return nil end
        
        currentIdx -= 1
        if currentIdx < 1 then
            currentIdx = 1
        end

        local embed = opts.embed(
            currentIdx
        )
        if not embed then 
            return nil -- This should never happen
        end

        if embed.title then
            embed.title ..= string.format(" (%d/%d)", currentIdx, opts.numPages)
        end

        interactionutils.replyUpdate(
            data.ctx,
            data.interaction,
            nil,
            {embed},
            {
                ActionRowBuilder.new()
                :addComponent(
                    prevButton:build()
                )
                :addComponent(
                    nextButton:build()
                )
                :build() :: apitypes.ComponentObjects
            }
        )

        return nil
    end)

    data.attachButtonCallback(jlNextId, function(data: frameworktypes.ButtonCallbackData): nil 
        local interactor = extractUserIdFromInteraction(data.interaction)
        if userid ~= interactor then return nil end
        currentIdx += 1
        if currentIdx > opts.numPages then
            currentIdx = opts.numPages
        end

        local embed = opts.embed(
            currentIdx
        )

        if embed.title then
            embed.title ..= string.format(" (%d/%d)", currentIdx, opts.numPages)
        end

        interactionutils.replyUpdate(
            data.ctx,
            data.interaction,
            nil,
            {embed},
            {
                ActionRowBuilder.new()
                :addComponent(
                    prevButton:build()
                )
                :addComponent(
                    nextButton:build()
                )
                :build() :: apitypes.ComponentObjects
            }
        )

        return nil    
    end)

    local embed = opts.embed(
        currentIdx
    )

    if embed.title then
        embed.title ..= string.format(" (%d/%d)", currentIdx, opts.numPages)
    end

    interactionutils.replySimple(
        data.ctx, 
        data.interaction,
        nil, 
        {embed},
        true,
        {
            ActionRowBuilder.new()
            :addComponent(
                prevButton:build()
            )
            :addComponent(
                nextButton:build()
            )
            :build() :: apitypes.ComponentObjects
        }
    )

    -- Mark the data as edited so further processing can know to use a followup
    -- message etc instead of an initial reply
    data.sethasEdited(true)
end

return {
    paginate = paginate
}