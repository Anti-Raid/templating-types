local coretypes = require"./coretypes"

local function Framework(base: coretypes.BaseFramework): coretypes.Framework 
    local self = {}
    self.base = base
    self.data = nil :: coretypes.BaseFrameworkData?

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

    local function getButtonCallback(buttonId: string): ((bcd: coretypes.ButtonCallbackData) -> nil)?
        return attachedButtonCallbacks[buttonId]
    end

    self.attachButtonCallback = attachButtonCallback
    self.dropButtonCallback = dropButtonCallback
    self.getButtonCallback = getButtonCallback

    return self
end

return {
    Framework = Framework,
}