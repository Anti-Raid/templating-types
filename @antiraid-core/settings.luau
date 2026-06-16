--- Settings v2 events
export type Event = {
    --- reordering of a formset
    type: "formset_reorder", 
    --- id of the formset
    id: string,
    --- new ordering of the formset block
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

export type DisplayElement = {
    --- a header
    type: "Header",
    text: string
} | {
    --- a paragraph
    type: "Paragraph",
    text: string
} | {
    --- an error
    type: "Error",
    error: string
}

--- A base component
export type Component = {
    --- a display element
    type: "DisplayElement",
    element: DisplayElement
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
}

export type FormElement = {
    --- a display element
    type: "DisplayElement",
    element: DisplayElement
} | {
    -- text input
    type: "Text",
    id: string,
    label: string,
    description: string?,
    placeholder: string?,
    disabled: boolean?,
} | {
    -- list of strings
    type: "Array.Text",
    id: string,
    label: string,
    description: string?,
    disabled: boolean?,
} | {
    -- list of strings with a set of available choices
    type: "Array.Select.Text",
    id: string,
    label: string,
    description: string?,
    disabled: boolean?,
    choices: {{label: string, value: string}},
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
    placeholder: string?,
    choices: {{label: string, value: string}},
} | {
    type: "Boolean",
    id: string,
    label: string,
    description: string?,
    disabled: boolean?,
} | {
    type: "Button.Action", -- TODO: move this to sep actions prop under the form to separate actions from state/data
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