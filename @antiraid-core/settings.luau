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
    --- A form (which contains a list of elements)
    type: "Form",
    id: string,
    title: string?, -- optional title
    ephemeral: boolean, -- an ephemeral form is cleared on close (useful for create form collapsibles etc.)
    form: {FormElement}
} | {
    --- A form reference (to be resolved during frontend preprocessing)
    ---
    --- #FormRefs are merely a network optimization and should be rendered the same way as a form would
    type: "#FormRef",
    id: string,
    tid: string, -- template id
    title: string?, -- optional title
    ephemeral: boolean, -- an ephemeral form is cleared on close (useful for create form collapsibles etc.)
    data: {[string]: any} -- data to inject into the cloned template form
} | {
    --- A collapsible set of blocks that open up to a set of inner components when clicked
    type: "Collapsible",
    collapsibles: {CollapsibleBlock},
    reorderable: boolean -- if set, a reorder event will be sent with the new list of ids
}

export type FormElement = {
    type: "TextBlock",
    style: "Header" | "Paragraph",
    text: string
} | {
    type: "Text",
    id: string,
    label: string,
    value: string
} | {
    type: "Number",
    id: string,
    label: string,
    value: number
} | {
    type: "Select.Text",
    id: string,
    label: string,
    choices: {string},
    value: string
} | {
    type: "Toggle.Checkbox",
    id: string,
    label: string,
    value: boolean
} | {
    type: "Toggle.Slider",
    id: string,
    label: string,
    value: boolean
} | {
    type: "Button.Action",
    id: string,
    text: string,
    style: "Primary" | "Secondary" | "Danger",
    send_form: boolean, -- if set to true, will send the entire form state 
}

export type Page = {
    components: {Component},
    form_templates: {[string]: {FormElement}}? -- any form templates to be reused
}

return {}