local settings = require("@antiraid-core/settings")

-- Optional parameter types for clean method signatures
type TextOpts = { description: string?, placeholder: string?, max_length: number?, disabled: boolean? }
type NumberOpts = { description: string?, min: number?, max: number?, disabled: boolean? }
type SelectOpts = { description: string?, disabled: boolean? }
type ToggleOpts = { description: string?, disabled: boolean? }

export type FormBuilder = {
    textblock: (self: FormBuilder, style: "Header" | "Paragraph", text: string) -> FormBuilder,
    text: (self: FormBuilder, id: string, label: string, value: string, opts: TextOpts?) -> FormBuilder,
    text_user: (self: FormBuilder, id: string, label: string, value: string, opts: TextOpts?) -> FormBuilder,
    number: (self: FormBuilder, id: string, label: string, value: number, opts: NumberOpts?) -> FormBuilder,
    select_text: (self: FormBuilder, id: string, label: string, choices: {{label: string, value: string}}, value: string, opts: SelectOpts?) -> FormBuilder,
    checkbox: (self: FormBuilder, id: string, label: string, value: boolean, opts: ToggleOpts?) -> FormBuilder,
    slider: (self: FormBuilder, id: string, label: string, value: boolean, opts: ToggleOpts?) -> FormBuilder,
    button: (self: FormBuilder, id: string, text: string, style: "Primary" | "Secondary" | "Danger", send_form: boolean) -> FormBuilder,
    
    --- Return the built form elements
    build: (self: FormBuilder) -> {settings.FormElement}
}

local function FormBuilder(): FormBuilder
    local elements: {settings.FormElement} = {}
    local self = {}

    function self:textblock(style: "Header" | "Paragraph", text: string): FormBuilder
        table.insert(elements, { type = "TextBlock" :: "TextBlock", style = style, text = text })
        return self
    end

    function self:text(id: string, label: string, value: string, opts: TextOpts?): FormBuilder
        opts = opts or {} :: TextOpts
        table.insert(elements, { type = "Text" :: "Text", id = id, label = label, value = value, description = opts.description, placeholder = opts.placeholder, max_length = opts.max_length, disabled = opts.disabled })
        return self
    end

    function self:text_user(id: string, label: string, value: string, opts: TextOpts?): FormBuilder
        opts = opts or {} :: TextOpts
        table.insert(elements, { type = "Text.User" :: "Text.User", id = id, label = label, value = value, description = opts.description, placeholder = opts.placeholder, max_length = opts.max_length, disabled = opts.disabled })
        return self
    end

    function self:number(id: string, label: string, value: number, opts: NumberOpts?): FormBuilder
        opts = opts or {} :: NumberOpts
        table.insert(elements, { type = "Number" :: "Number", id = id, label = label, value = value, description = opts.description, min = opts.min, max = opts.max, disabled = opts.disabled })
        return self
    end

    function self:select_text(id: string, label: string, choices: {{label: string, value: string}}, value: string, opts: SelectOpts?): FormBuilder
        opts = opts or {} :: SelectOpts
        table.insert(elements, { type = "Select.Text" :: "Select.Text", id = id, label = label, choices = choices, value = value, description = opts.description, disabled = opts.disabled })
        return self
    end

    function self:checkbox(id: string, label: string, value: boolean, opts: ToggleOpts?): FormBuilder
        opts = opts or {} :: ToggleOpts
        table.insert(elements, { type = "Toggle.Checkbox" :: "Toggle.Checkbox", id = id, label = label, value = value, description = opts.description, disabled = opts.disabled })
        return self
    end

    function self:slider(id: string, label: string, value: boolean, opts: ToggleOpts?): FormBuilder
        opts = opts or {} :: ToggleOpts
        table.insert(elements, { type = "Toggle.Slider" :: "Toggle.Slider", id = id, label = label, value = value, description = opts.description, disabled = opts.disabled })
        return self
    end

    function self:button(id: string, text: string, style: "Primary" | "Secondary" | "Danger", send_form: boolean): FormBuilder
        table.insert(elements, { type = "Button.Action" :: "Button.Action", id = id, text = text, style = style, send_form = send_form })
        return self
    end

    -- workaround for type solver bugs
    local function _build(self: FormBuilder): {settings.FormElement} return elements end
    self.build = _build

    return self
end

--- A scoped builder for inside sections
export type SectionBuilder<T> = {
    data: T,
    extract: (self: SectionBuilder<T>) -> ({settings.Component}, {[string]: {settings.FormElement}}),
    textblock: (self: SectionBuilder<T>, style: "Header" | "Paragraph", text: string) -> SectionBuilder<T>,
    form: (self: SectionBuilder<T>, id: string, title: string?, ephemeral: boolean, elements: {settings.FormElement}) -> SectionBuilder<T>,
    formref: (self: SectionBuilder<T>, id: string, tid: string, title: string?, ephemeral: boolean, data: {[string]: any}) -> SectionBuilder<T>,
    --- Define a reusable form template
    defineform: (self: SectionBuilder<T>, tid: string, elements: {settings.FormElement}) -> SectionBuilder<T>,
}

local function SectionBuilder<T>(data: T): SectionBuilder<T>
    local components: {settings.Component} = {}
    local formtemplates: {[string]: {settings.FormElement}} = {}
    local self = {}
    
    function self:textblock(style: "Header" | "Paragraph", text: string): SectionBuilder<T>
        table.insert(components, { type = "TextBlock" :: "TextBlock", style = style, text = text })
        return self
    end

    function self:form(id: string, title: string?, ephemeral: boolean, elements: {settings.FormElement}): SectionBuilder<T>
        table.insert(components, { type = "Form" :: "Form", id = id, title = title, ephemeral = ephemeral, form = elements })
        return self
    end

    function self:formref(id: string, tid: string, title: string?, ephemeral: boolean, data: {[string]: any}): SectionBuilder<T>
        table.insert(components, { type = "#FormRef" :: "#FormRef", id = id, tid = tid, title = title, ephemeral = ephemeral, data = data })
        return self
    end

    function self:defineform(tid: string, elements: {settings.FormElement}): SectionBuilder<T>
        assert(not formtemplates[tid], `form template '{tid}' already exists in page`)
        formtemplates[tid] = elements
        return self
    end

    -- workaround for type solver bugs
    local function _extract(self: SectionBuilder<T>): ({settings.Component}, {[string]: {settings.FormElement}}) return components, formtemplates end
    self.extract = _extract

    self.data = data
    return self
end

export type PageBuilder<T> = {
    data: T,
    --- Add a section to the page
    section: (self: PageBuilder<T>, id: string, title: string, description: string, cb: (sb: SectionBuilder<T>) -> ()) -> PageBuilder<T>,
    --- Define a reusable form template
    defineform: (self: PageBuilder<T>, tid: string, elements: {settings.FormElement}) -> PageBuilder<T>,
    
    textblock: (self: PageBuilder<T>, style: "Header" | "Paragraph", text: string) -> PageBuilder<T>,
    form: (self: PageBuilder<T>, id: string, title: string?, ephemeral: boolean, elements: {settings.FormElement}) -> PageBuilder<T>,
    formref: (self: PageBuilder<T>, id: string, tid: string, title: string?, ephemeral: boolean, data: {[string]: any}) -> PageBuilder<T>,

    --- Return the built page
    build: (self: PageBuilder<T>) -> settings.Page,
}

local function PageBuilder<T>(data: T): PageBuilder<T> 
    local components: {settings.Component} = {}
    local formtemplates: {[string]: {settings.FormElement}} = {}
    local self = {}

    function self:section(id: string, title: string, description: string, cb: (sb: SectionBuilder<T>) -> ()): PageBuilder<T>
        local sb = SectionBuilder(self.data)
        cb(sb)
        local comps, fts = sb:extract()
        
        -- Extract the scoped components + form templaes
        table.insert(components, {
            type = "Section" :: "Section",
            id = id,
            title = title,
            description = description,
            entries = comps
        })
        for tid, elements in fts do 
            assert(not formtemplates[tid], `form template '{tid}' already exists in page [add from section]`)
            formtemplates[tid] = elements
        end

        return self
    end

    function self:defineform(tid: string, elements: {settings.FormElement}): PageBuilder<T>
        assert(not formtemplates[tid], `form template '{tid}' already exists in page`)
        formtemplates[tid] = elements
        return self
    end

    function self:textblock(style: "Header" | "Paragraph", text: string): PageBuilder<T>
        table.insert(components, { type = "TextBlock" :: "TextBlock", style = style, text = text })
        return self
    end

    function self:form(id: string, title: string?, ephemeral: boolean, elements: {settings.FormElement})
        table.insert(components, { type = "Form" :: "Form", id = id, title = title, ephemeral = ephemeral, form = elements })
        return self
    end

    function self:formref(id: string, tid: string, title: string?, ephemeral: boolean, data: {[string]: any})
        table.insert(components, { type = "#FormRef" :: "#FormRef", id = id, tid = tid, title = title, ephemeral = ephemeral, data = data })
        return self
    end

    function self:build()  
        -- If no templates were defined, set it to nil to save wire bytes
        local templates = if next(formtemplates) == nil then nil else formtemplates
        return { components = components, form_templates = templates }
    end

    self.data = data
    return self :: PageBuilder<T>
end

return table.freeze{ FormBuilder = FormBuilder, PageBuilder = PageBuilder }