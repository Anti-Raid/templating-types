--- Settings v2 events
export type Event = {
    --- reordering of a collapsible
    type: "collapsible_reorder", 
    --- id of the collapsible
    id: string,
    --- new ordering of the collapsible block
    list: {string}
} | {
    --- form action
    type: "form_action",
    action_button_id: string, -- the clicked action button
    formset_id: string, -- id of the form set containing the form
    form_id: string, -- the id of the form containing the action button
    form_data: {[string]: any}? -- where key is the element id, value is the inputted data
} | {
    --- fetch the settings page
    type: "fetch_page",
}

--- A collapsible block that opens up to a list of components when clicked
export type CollapsibleBlock = {
    id: string,
    label: string,
    entries: {Component} -- the components that form the collapsible block
}

--- A base component
export type Component = {
    --- a raw text block
    type: "TextBlock",
    style: "Header" | "Paragraph",
    text: string
} | {
    --- a section block
    type: "Section",
    id: string,
    title: string,
    description: string,
    entries: {Component}
} | {
    --- A form reference
    type: "FormSet",
    id: string,
    form: {FormElement},
    reorderable: boolean -- if set, a reorder event will be sent with the new list of ids
} | {
    --- A collapsible set of blocks that open up to a set of inner components when clicked
    type: "Collapsible",
    collapsibles: {CollapsibleBlock},
}

export type FormElement = {
    type: "TextBlock",
    style: "Header" | "Paragraph",
    text: string
} | {
    -- text input
    type: "Text",
    id: string,
    label: string,
    description: string?,
    placeholder: string?,
    disabled: boolean?,
} | {
    -- user input
    type: "Text.User",
    id: string,
    label: string,
    description: string?,
    placeholder: string?,
    disabled: boolean?,
} | {
    -- list of strings
    type: "Array.Text",
    style: "Normal" | "Kittycat",
    id: string,
    label: string,
    description: string?,
    disabled: boolean?,
} | {
    type: "Number",
    id: string,
    label: string,
    description: string?,
    placeholder: string?,
    disabled: boolean?,
} | {
    type: "Select.Text",
    id: string,
    label: string,
    description: string?,
    disabled: boolean?,
    choices: {{label: string, value: string}},
} | {
    type: "Toggle.Checkbox",
    id: string,
    label: string,
    description: string?,
    disabled: boolean?,
} | {
    type: "Toggle.Slider",
    id: string,
    label: string,
    description: string?,
    disabled: boolean?,
} | {
    type: "Button.Action",
    id: string,
    text: string,
    style: "Primary" | "Secondary" | "Danger",
    send_form: boolean, -- if set to true, will send the entire form state 
}

export type FormData = {
    --- form id
    id: string,
    --- form title
    title: string,
    --- form data
    data: {[string]: any},
}

export type Page = {
    components: {Component},
    --- form datas to expand every FormSet into
    ---
    --- for every FormSet, the frontend will expand the given data into the FormSet internally
    ---
    formdata: {[string]: {FormData}},
}

return {}