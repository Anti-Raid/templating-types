local Primitives = require("./types/Primitives")
local LuaStream = require ("./types/LuaStream")
local DummyLuaStream = require ("./types/DummyImpls").DummyLuaStream
local CreateDummyEvent = require ("./types/DummyImpls").CreateDummyEvent
local CreateDummyTemplateContext = require ("./types/DummyImpls").CreateDummyTemplateContext
local CreateDummyTemplateData = require ("./types/DummyImpls").CreateDummyTemplateData
local CreateDummyTemplatePragma = require ("./types/DummyImpls").CreateDummyTemplatePragma

-- Example of Streams
local MyDummyStream: LuaStream.LuaStream<string> = DummyLuaStream

local next_value_in_stream = MyDummyStream.next(MyDummyStream)
while next_value_in_stream do
    print(next_value_in_stream)
    next_value_in_stream = MyDummyStream.next(MyDummyStream)
end

local args: Primitives.Event, token: Primitives.TemplateContext = ...

-- To handle the dummy event case
local isDummyEvent = args == nil or token == nil
if isDummyEvent then     
    args = CreateDummyEvent("title", "base_name", "name", {data = "data"})
    token = CreateDummyTemplateContext(
        CreateDummyTemplateData("dummy", CreateDummyTemplatePragma("lua", {"discord:create_message"}))
    )
end

-- The below should just work
print("Event Name: " .. args.name)
print("Event Data: data= " .. tostring(args.data["data"]))

if not isDummyEvent then 
    local interop = require "@antiraid/interop"
    print(interop)
end