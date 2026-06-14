local settings = require("@antiraid-core/settings")

-- Optional parameter types for clean method signatures
type TextOpts = { description: string?, placeholder: string?, disabled: boolean? }
type TextUserOpts = { description: string?, placeholder: string?, disabled: boolean? }
type ArrayTextOpts = { description: string?, disabled: boolean? }
type NumberOpts = { description: string?, placeholder: string?, disabled: boolean? }
type SelectOpts = { description: string?, disabled: boolean? }
type ToggleOpts = { description: string?, disabled: boolean? }

export type FormBuilder = {
    display: (self: FormBuilder, element: settings.DisplayElement) -> FormBuilder,
    text: (self: FormBuilder, id: string, label: string, opts: TextOpts?) -> FormBuilder,
    text_user: (self: FormBuilder, id: string, label: string, opts: TextUserOpts?) -> FormBuilder,
    array_text: (self: FormBuilder, id: string, style: "Normal" | "Kittycat", label: string, opts: ArrayTextOpts?) -> FormBuilder,
    number: (self: FormBuilder, id: string, label: string, opts: NumberOpts?) -> FormBuilder,
    select_text: (self: FormBuilder, id: string, label: string, choices: {{label: string, value: string}}, opts: SelectOpts?) -> FormBuilder,
    checkbox: (self: FormBuilder, id: string, label: string, opts: ToggleOpts?) -> FormBuilder,
    slider: (self: FormBuilder, id: string, label: string, opts: ToggleOpts?) -> FormBuilder,
    button: (self: FormBuilder, id: string, text: string, style: "Primary" | "Secondary" | "Danger", send_form: boolean) -> FormBuilder,
    
    --- Return the built form elements
    build: (self: FormBuilder) -> {settings.FormElement}
}

local function FormBuilder(): FormBuilder
    local elements: {settings.FormElement} = {}
    local self = {}

    function self:display(element: settings.DisplayElement): FormBuilder
        table.insert(elements, { type = "DisplayElement" :: "DisplayElement", element = element })
        return self
    end

    function self:text(id: string, label: string, opts: TextOpts?): FormBuilder
        opts = opts or {} :: TextOpts
        table.insert(elements, { type = "Text" :: "Text", id = id, label = label, description = opts.description, placeholder = opts.placeholder, disabled = opts.disabled })
        return self
    end

    function self:text_user(id: string, label: string, opts: TextUserOpts?): FormBuilder
        opts = opts or {} :: TextUserOpts
        table.insert(elements, { type = "Text.User" :: "Text.User", id = id, label = label, description = opts.description, placeholder = opts.placeholder, disabled = opts.disabled })
        return self
    end

    function self:array_text(id: string, style: "Normal" | "Kittycat", label: string, opts: ArrayTextOpts?): FormBuilder
        opts = opts or {} :: ArrayTextOpts
        table.insert(elements, { type = "Array.Text" :: "Array.Text", style = style, id = id, label = label, description = opts.description, disabled = opts.disabled })
        return self
    end

    function self:number(id: string, label: string, opts: NumberOpts?): FormBuilder
        opts = opts or {} :: NumberOpts
        table.insert(elements, { type = "Number" :: "Number", id = id, label = label, description = opts.description, placeholder = opts.placeholder, disabled = opts.disabled })
        return self
    end

    function self:select_text(id: string, label: string, choices: {{label: string, value: string}}, opts: SelectOpts?): FormBuilder
        opts = opts or {} :: SelectOpts
        table.insert(elements, { type = "Select.Text" :: "Select.Text", id = id, label = label, choices = choices, description = opts.description, disabled = opts.disabled })
        return self
    end

    function self:checkbox(id: string, label: string, opts: ToggleOpts?): FormBuilder
        opts = opts or {} :: ToggleOpts
        table.insert(elements, { type = "Toggle.Checkbox" :: "Toggle.Checkbox", id = id, label = label, description = opts.description, disabled = opts.disabled })
        return self
    end

    function self:slider(id: string, label: string, opts: ToggleOpts?): FormBuilder
        opts = opts or {} :: ToggleOpts
        table.insert(elements, { type = "Toggle.Slider" :: "Toggle.Slider", id = id, label = label, description = opts.description, disabled = opts.disabled })
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
    extract: (self: SectionBuilder<T>) -> ({settings.Component}, {[string]: {settings.FormData}}),
    display: (self: SectionBuilder<T>, element: settings.DisplayElement) -> SectionBuilder<T>,
    formset: (self: SectionBuilder<T>, id: string, form: {settings.FormElement}, reorderable: boolean) -> SectionBuilder<T>,
}

local function SectionBuilder<T>(data: T): SectionBuilder<T>
    local components: {settings.Component} = {}
    local formdata: {[string]: {settings.FormData}} = {}
    local self = {}
    
    function self:display(element: settings.DisplayElement): SectionBuilder<T>
        table.insert(components, { type = "DisplayElement" :: "DisplayElement", element = element })
        return self
    end

    function self:formset(id: string, form: {settings.FormElement}, reorderable: boolean): SectionBuilder<T>
        table.insert(components, { type = "FormSet" :: "FormSet", id = id, form = form, reorderable = reorderable })
        return self
    end

    -- workaround for type solver bugs
    local function _extract(self: SectionBuilder<T>): ({settings.Component}, {[string]: {settings.FormData}}) return components, formdata end
    self.extract = _extract

    self.data = data
    return self
end

export type PageBuilder<T> = {
    data: T,
    --- Add a section to the page
    section: (self: PageBuilder<T>, id: string, title: string, description: string, cb: (sb: SectionBuilder<T>) -> ()) -> PageBuilder<T>,    
    display: (self: PageBuilder<T>, element: settings.DisplayElement) -> PageBuilder<T>,
    formset: (self: PageBuilder<T>, id: string, form: {settings.FormElement}, reorderable: boolean) -> PageBuilder<T>,
    addformdata: (self: PageBuilder<T>, id: string, fd: settings.FormData) -> PageBuilder<T>,

    --- Return the built page
    build: (self: PageBuilder<T>) -> settings.Page,
}

local function PageBuilder<T>(data: T): PageBuilder<T> 
    local components: {settings.Component} = {}
    local formdata: {[string]: {settings.FormData}} = {}
    local self = {}

    function self:section(id: string, title: string, description: string, cb: (sb: SectionBuilder<T>) -> ()): PageBuilder<T>
        local sb = SectionBuilder(self.data)
        cb(sb)
        local comps, fts = sb:extract()
        
        -- Extract the scoped components + form data
        table.insert(components, {
            type = "Section" :: "Section",
            id = id,
            title = title,
            description = description,
            entries = comps
        })
        for tid, elements in fts do 
            assert(not formdata[tid], `form data for '{tid}' already exists in page [add from section]`)
            formdata[tid] = elements
        end

        return self
    end

    function self:formset(id: string, form: {settings.FormElement}, reorderable: boolean): PageBuilder<T>
        table.insert(components, { type = "FormSet" :: "FormSet", id = id, form = form, reorderable = reorderable })
        return self
    end

    function self:addformdata(id: string, fd: settings.FormData): PageBuilder<T> 
        if not formdata[id] then formdata[id] = {fd} 
        else table.insert(formdata[id], fd) end
        return self
    end

    function self:display(element: settings.DisplayElement): PageBuilder<T>
        table.insert(components, { type = "DisplayElement" :: "DisplayElement", element = element })
        return self
    end

    function self:build()  
        return { components = components, formdata = formdata }
    end

    self.data = data
    return self :: PageBuilder<T>
end

return table.freeze{ FormBuilder = FormBuilder, PageBuilder = PageBuilder }