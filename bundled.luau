local __DARKLUA_BUNDLE_MODULES

__DARKLUA_BUNDLE_MODULES = {
    cache = {},
    load = function(m)
        if not __DARKLUA_BUNDLE_MODULES.cache[m] then
            __DARKLUA_BUNDLE_MODULES.cache[m] = {
                c = __DARKLUA_BUNDLE_MODULES[m](),
            }
        end

        return __DARKLUA_BUNDLE_MODULES.cache[m].c
    end,
}

do
    function __DARKLUA_BUNDLE_MODULES.a()
        return {}
    end
    function __DARKLUA_BUNDLE_MODULES.b()
        return {}
    end
    function __DARKLUA_BUNDLE_MODULES.c()
        __DARKLUA_BUNDLE_MODULES.load('b')
        __DARKLUA_BUNDLE_MODULES.load('a')

        local DummyLuaStream = {
            ___contents = {
                'a',
                'b',
                'c',
            },
            ___index = 0,
            next = function(self)
                local s = self

                if s.___index >= #s.___contents then
                    return nil
                end

                s.___index = s.___index + 1

                return s.___contents[s.___index]
            end,
            for_each = function(self, callback)
                local item = self:next()

                while item do
                    callback(item)

                    item = self:next()
                end

                return
            end,
        }

        function __randomString(length)
            local res = ''
            local chars = 
[[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]]

            for i = 1, length do
                local index = math.random(1, #chars)

                res = res .. chars:sub(index, index)
            end

            return res
        end
        function CreateDummyEvent(title, base_name, name, data)
            local tab = {
                title = title,
                base_name = base_name,
                name = name,
                data = table.clone(data),
                is_deniable = false,
                uid = __randomString(10),
            }

            tab.__index = function(self, key)
                if key == 'data' then
                    return table.clone(data)
                end

                return rawget(tab, key)
            end

            table.freeze(tab)

            local ud = newproxy(true)

            getmetatable(ud).__index = tab

            return ud
        end
        function CreateDummyTemplatePragma(lang, allowed_caps)
            return {
                lang = lang,
                allowed_caps = allowed_caps,
            }
        end
        function CreateDummyTemplateData(path, pragma)
            return {
                path = path,
                pragma = pragma,
            }
        end
        function CreateDummyTemplateContext(data)
            local tab = {
                template_data = table.clone(data),
            }

            tab.__index = function(self, key)
                if key == 'template_data' then
                    return table.clone(data)
                end

                return rawget(tab, key)
            end

            table.freeze(tab)

            local ud = newproxy(true)

            getmetatable(ud).__index = tab

            return ud
        end

        return {
            DummyLuaStream = DummyLuaStream,
            CreateDummyEvent = CreateDummyEvent,
            CreateDummyTemplatePragma = CreateDummyTemplatePragma,
            CreateDummyTemplateData = CreateDummyTemplateData,
            CreateDummyTemplateContext = CreateDummyTemplateContext,
        }
    end
end

__DARKLUA_BUNDLE_MODULES.load('a')
__DARKLUA_BUNDLE_MODULES.load('b')

local DummyLuaStream = __DARKLUA_BUNDLE_MODULES.load('c').DummyLuaStream
local CreateDummyEvent = __DARKLUA_BUNDLE_MODULES.load('c').CreateDummyEvent
local CreateDummyTemplateContext = __DARKLUA_BUNDLE_MODULES.load('c').CreateDummyTemplateContext
local CreateDummyTemplateData = __DARKLUA_BUNDLE_MODULES.load('c').CreateDummyTemplateData
local CreateDummyTemplatePragma = __DARKLUA_BUNDLE_MODULES.load('c').CreateDummyTemplatePragma
local MyDummyStream = DummyLuaStream
local next_value_in_stream = MyDummyStream.next(MyDummyStream)

while next_value_in_stream do
    print(next_value_in_stream)

    next_value_in_stream = MyDummyStream.next(MyDummyStream)
end

local args, token = ...
local isDummyEvent = args == nil or token == nil

if isDummyEvent then
    args = CreateDummyEvent('title', 'base_name', 'name', {
        data = 'data',
    })
    token = CreateDummyTemplateContext(CreateDummyTemplateData('dummy', CreateDummyTemplatePragma('lua', {
        'discord:create_message',
    })))
end

print('Event Name: ' .. args.name)
print('Event Data: data= ' .. tostring(args.data['data']))

if not isDummyEvent then
    local interop = require'@antiraid/interop'

    print(interop)
end
