--[[
# Settings (v2) protocol:

## Base Types not listed in this file

export type DispatchResult<T> = {
    type: "ok" | "err",
    id: string, -- template's id
    value: T, -- value within it
} 

## Format

All settings v2 payloads are events sent via msyscall's Bot->DispatchEvent op with the following base properties:

- `name`: WebSettings
- `author`: Author of the user invoking the setting (msyscall will auto-fill this in when using DispatchEvent)
- `data`: Data of type `Event` as shown on this page. Like all DispatchEvent requests, all data must follow the KhronosValue format

# Basic architecture

There are a few things any settings v2 client must architecturally support:

- The frontend must keep track of which forms are in a formset as well as the order of forms within a formset
- The frontend must have some way to keep track of the formdata (``{[string]: {FormData}}``) hereby called frontend-formdata
- The frontend must have some way to apply a formdata patchset from the server (hereby called formdata-patchset) to the frontend-formdata
-  The template id each page was sent in must also be tracked and will hereby be called page-template-id.

## Frontend

To start, a fetch_page Event must be sent which will return a DispatchResult<Page>[], the frontend can then parse+render the comps however it wants 
(see willow in template-worker devutils/willow) [TODO: improve this section]

### Choices

A Text and/or Array.Text input may contain an optional `choices` property that may act as a *hint* to the frontend on how to render the Text/Array.Text input.

For example, a Text with a choices of type=Fixed may be rendered as a select box. Similarly, a Array.Text with a choices of type=Fixed may be rendered with a 
custom MultiSelect component or a HTML select multiple.

Note: it is perfectly allowed for a frontend to *downgrade* choices it does not support (or cannot render) to the default rendering for Text/Array.Text. 
For example, a type=Channel/type=Role in a frontend without fetched guild info etc may be rendered as a raw text box. The choice=nil option is
the bare minimum required when rendering Text/Array.Text.

Some other specifications for individual types:

- type=Channel: Should cover all *non-category* channels

### Form Actions

If a user clicks an action button (FormAction with type Button.Event), follow the below steps to create the form_action Event to send:

If send_form is true on the action button, create the form_data object with the following rules:
- All elements (FormElement) within the currently open form must be looped through. 
- If the element is a DisplayElements, ignore,
- Otherwise, form_data[FormElement.id] = FormElement.value

Set __tloop_template_id to page-template-id
Set action_button_id to the id of the action button the user pressed
Set formset_id to the id of the formset containing the form the action button was contained in
Set form_id to the id of the form the action button was contained in

The result of a form_action Event is either a any response (todo: improve this) or a error (seen as a msyscall error) as tloop will perform selective dispatch
due to special logic included for the __tloop_template_id key and will directly call into the desired template w/o any DispatchResult intermediaries etc.
]]

--- Settings v2 events
export type Event = {
    --- reordering of a formset
    type: "formset_reorder", 
    __tloop_template_id: string, -- the template id to dispatch to, used by tloop to selectively dispatch
    --- id of the formset
    id: string,
    --- new ordering of the formset block
    list: {string}
} | {
    --- form action
    type: "form_action",
    __tloop_template_id: string, -- the template id to dispatch to, used by tloop to selectively dispatch
    action_button_id: string, -- the clicked action button
    formset_id: string, -- id of the form set containing the form
    form_id: string, -- the id of the form containing the action button
    form_data: {[string]: any}? -- where key is the element id, value is the inputted data
} | {
    --- fetch the settings page
    type: "fetch_page",
}

export type EventResponse = {
    --- action does not need any client side state change, keep whatever user input the user currently has
    type: "noop"
} | {
    --- update form data
    type: "patch_formdata",
    new_formdata: {[string]: {FormData}}
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
    actions: {FormAction},
    reorderable: boolean -- if set, a reorder event will be sent with the new list of ids
}

--- Form actions
export type FormAction = {
    type: "Button.Event",
    id: string,
    text: string,
    style: "Primary" | "Secondary" | "Danger",
    send_form: boolean, -- if set to true, will send the entire form state 
}

export type Choices = {
    type: "Fixed",
    choices: {{label: string, value: string}}
} | {
    type: "Channel" -- all non-category channels
} | {
    type: "Role"
} | {
    type: "Member"
}

--- Form elements
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
    choices: Choices?
} | {
    -- list of strings
    type: "Array.Text",
    id: string,
    label: string,
    description: string?,
    disabled: boolean?,
    placeholder: string?,
    choices: Choices?
} | {
    type: "Number",
    id: string,
    label: string,
    description: string?,
    placeholder: string?,
    disabled: boolean?,
} | {
    type: "Boolean",
    id: string,
    label: string,
    description: string?,
    disabled: boolean?,
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