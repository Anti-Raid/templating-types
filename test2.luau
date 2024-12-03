local Primitives = require("./types/Primitives")
local args: Primitives.Event, token: Primitives.TemplateContext = ...
local isDummyEvent = args == nil or token == nil
print("Is a dummy event: " .. tostring(isDummyEvent))

if not isDummyEvent then 
    local interop = require "@antiraid/interop"
    print(interop)
end