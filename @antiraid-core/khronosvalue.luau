local datetime = require "@antiraid/datetime"
local typesext = require "@antiraid/typesext"   

--[[
#[derive(Debug, Clone)]
pub enum KhronosValue {
    Text(String),
    Integer(i64),
    UnsignedInteger(u64),
    Float(f64),
    Boolean(bool),
    Vector((f32, f32, f32)), // Luau vector
    Map(indexmap::IndexMap<String, KhronosValue>),
    List(Vec<KhronosValue>),
    Timestamptz(chrono::DateTime<chrono::Utc>),
    Interval(chrono::Duration),
    TimeZone(chrono_tz::Tz),
    Null,
}
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

return {}