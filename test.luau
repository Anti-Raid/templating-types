local Primitives = require("./types/Primitives")

local args: Primitives.Event, token: Primitives.TemplateData = ...

-- The below should just work
print(args.name, token.path)

local LuaStream = require ("./types/LuaStream")

local MyDummyStream: LuaStream.LuaStream<string> = LuaStream.DummyLuaStream

print(MyDummyStream.next(MyDummyStream))