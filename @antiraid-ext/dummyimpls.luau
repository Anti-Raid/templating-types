--!nocheck
-- DummyImpls provides dummy implementations of many common things for testing AntiRaid APIs

local LuaStream = require ("@antiraid/stream")
local Primitives = require ("@antiraid-core/primitives")

local DummyLuaStream: LuaStream.LuaStream<string> = {
    ___contents = {
        "a",
        "b",
        "c"
    },
    ___index = 0,
}

-- Creates a random string for the dummy functions
function __randomString(length: number): string
    local res = ""
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    for i = 1, length do
        local index = math.random(1, #chars)
        res = res .. chars:sub(index, index)
    end
    return res
end

function CreateDummyEvent(title: string, base_name: string, name: string, data: any) : Primitives.Event
    local tab = {
        title = title,
        base_name = base_name,
        name = name,
        data = table.clone(data),
        is_deniable = false,
        uid = __randomString(10),
    }

    tab.__index = function(self, key)
        if key == "data" then
            return table.clone(data)
        end
        return rawget(tab, key)
    end

    table.freeze(tab)

    local ud = newproxy(true)
    local mt: any = getmetatable(ud)
    mt.__index = tab
    return ud
end

function CreateDummyTemplatePragma(lang: string, allowed_caps: {string}) : Primitives.TemplatePragma
    return {
        lang = lang,
        allowed_caps = allowed_caps
    }
end

function CreateDummyTemplateData(path: string, pragma: Primitives.TemplatePragma) : Primitives.TemplateData
    return {
        path = path,
        pragma = pragma
    }
end

function CreateDummyTemplateContext(data: Primitives.TemplateData) : Primitives.TemplateContext
    local tab = {
        template_data = table.clone(data),
        guild_id = "1",
        current_user = {
            id = "1234567890",
            username = "DummyUser",
            discriminator = "0000",
            global_name = "DummyUser1234",
        }
    }

    tab.__index = function(self, key: string)
        if key == "template_data" then
            return table.clone(data)
        end
        return rawget(tab, key)
    end

    table.freeze(tab)

    local ud = newproxy(true)

    local mt: any = getmetatable(ud)
    mt.__index = tab

    return ud
end

return {
    DummyLuaStream = DummyLuaStream,
    CreateDummyEvent = CreateDummyEvent,
    CreateDummyTemplatePragma = CreateDummyTemplatePragma,
    CreateDummyTemplateData = CreateDummyTemplateData,
    CreateDummyTemplateContext = CreateDummyTemplateContext,
}