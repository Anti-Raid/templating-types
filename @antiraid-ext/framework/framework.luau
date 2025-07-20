local coretypes = require"@self/coretypes"

local function Framework(base: coretypes.BaseFramework): coretypes.Framework 
    local self = {}
    self.base = base

    local attachedButtonCallbacks = {} :: { [string]: (bcd: coretypes.ButtonCallbackData) -> nil }

    -- Internal function to attach a button callback
    local function attachButtonCallback(buttonId: string, callback: (bcd: coretypes.ButtonCallbackData) -> nil) 
        attachedButtonCallbacks[buttonId] = callback
        return nil
    end

    local function dropButtonCallback(buttonId: string): nil
        attachedButtonCallbacks[buttonId] = nil
        return nil
    end    

    self.attachButtonCallback = attachButtonCallback
    self.dropButtonCallback = dropButtonCallback

    return self
end

return {
    Framework = Framework,
}