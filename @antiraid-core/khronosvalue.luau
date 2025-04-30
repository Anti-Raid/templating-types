local datetime = require "@antiraid/datetime"
local typesext = require "@antiraid/typesext"   

--[[
A number, I64, U64, boolean, vector, string, map, list, DateTime, TimeDelta, TimeZone or nil
]]
export type KhronosValue = string -- Text
    | number -- Integer (small), Float
    | typesext.I64 -- Integer (big)
    | typesext.U64 -- UnsignedInteger (big)
    | boolean -- Boolean
    | vector -- Vector
    | { [string]: KhronosValue } -- Map
    | { KhronosValue } -- List
    | datetime.DateTime -- Timestamptz
    | datetime.TimeDelta -- Interval
    | datetime.TimeZone -- TimeZone
    | nil -- Null
    | any

return {}