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
- The template id each page was sent in must also be tracked and will hereby be called page-template-id.

## Frontend

To start, a fetch_page Event must be sent which will return a DispatchResult<Page>[], the frontend can then parse+render the comps however it wants 
(see willow in template-worker devutils/willow) [TODO: improve this section, also add note that initial frontend-formdata should include all fields w/o branch
evaluation]. Note that every FormElement that is not a DisplayElement must have a unique id to all other form elements (including form elements in branches)

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
- If the element is a Branch, then compute the branch using Anima w/ disableLambda+disableDefine and if it evaluates to a truthy value, then recursively 
loop over the FormElements of the branch and follow the same rules listed here on those elements using the same in-creation form_data.
- Otherwise, form_data[FormElement.id] = FormElement.value

Set __tloop_template_id to page-template-id
Set action_button_id to the id of the action button the user pressed
Set formset_id to the id of the formset containing the form the action button was contained in
Set form_id to the id of the form the action button was contained in

The result of a form_action Event is either a any response (todo: improve this) or a error (seen as a msyscall error) as tloop will perform selective dispatch
due to special logic included for the __tloop_template_id key and will directly call into the desired template w/o any DispatchResult intermediaries etc.

## Anima

Anima is the language used by form branches and validation in settings v2. It is designed based of s-expressions to be fairly minimal

### Grammar

Anima uses a (simplified) Scheme-like grammar based on 's-expressions'

```
<program>   ::= <expr>* 
<expr>      ::= <primitive> | <list> | <quoted>
<primitive> ::= <null> | <boolean> | <number> | <string> | <symbol>
<null>    ::= null
<boolean> ::= true | false
<number>  ::= [0-9]+ ("." [0-9]+)? 
<string>  ::= "[json/lisp escaped string]"
<special> ::= ( | ) | [ | ] | ; | " | '
<symbol>  ::= [character (excluding <special> and whitespace)]+
<list>    ::= (<expr>*) | [<expr>*]
<quoted>  ::= '<expr>
```

Comments begin with ; and continue to the end of the line.

### Execution

- Strings like "hello" must not be evaluated as a symbol (one way to achieve this is to wrap the string in a quote like: (quote "hello"))
- A quoted expression like '<expr> should have the same effect as (quote <expr>). 
- Multiple top-level expressions should be evaluated sequentially with the result being the result of the last expression (one way
to achieve this is to parse multiple top-level expressions expr1 expr2... in a do block like (do expr1 expr2 ...))

### Other Rules

1. Like Scheme, Anima makes use of lexical scoping. Nested scopes inherit parent variables and can 'shadow' parent variables of the same name.
`define` strictly mutates or initializes within the local execution scope and never the parent scope and variables in the outermost scope 
cannot be reassigned or mutated whatsoever for sandboxing purposes.

2. Truthiness: false and null are falsey. All other values are truthy.

3. Tail-Call Optimization (TCO): The runtime MUST execute the final expression in do, if, and, or, and custom procedure calls without allocating a new frame on the host call stack.

4. Anima does not support macros/custom syntax extensions. Compliant implementations of Anima must not support these features.

5. It is not allowed for user-code to override a builtin using define. Compliant implementations of Anima should error if an attempt to do so is detected

6. Compliant implementations of Anima should support the following options:
- disableLambda (disables creation of closures using lambda)
- disableDefine (disables setting values to scope to define)
- maxSteps (the maximum number of steps that anima code is allowed to use up. Each vm loop should use 1 step and future functions defined in the spec may
be defined to take up additional steps in addition to the fixed 1 step cost)

### Supported Features/Builtins

Implementations must enforce strict arity and type checking, throwing errors on mismatch.

#### Special Forms
- define (varname: symbol, value: expr): Evaluates value and binds it to varname in the current scope. Arity: 2.
- get (varname: symbol): Dynamically looks up a variable. Arity: 1.
- do (expr...): Evaluates arguments sequentially. Returns the result of the last expression. Arity: >= 1.
- lambda ([params...], body: expr): Returns a closure capturing the current lexical scope. Arity: 2.
- if (cond, true_expr, false_expr): Evaluates cond. If truthy, evaluates and returns true_expr, else false_expr. Arity: 3.
- cond (clauses...): Each clause must be a list of exactly two elements: [condition, expr]. Each condition must be executed in 
order. Upon encountering the first truthy clause condition (or the exact symbol 'else'), expr is evaluated and returned. If no 
conditions match, returns null. Throws an error if zero clauses are provided or if any clause is malformed. Arity: >= 1.
- quote (expr): Returns the expression without evaluating it. Arity: 1.

#### List Operations
- list (expr...): Evaluates arguments and returns them as a native array. Arity: >= 0.
- car (list): Returns the first element of the list. Throws if the list is empty. Arity: 1.
- cdr (list): Returns a new list excluding the first element. Throws if the list is empty. Arity: 1.
- last (list): Returns the final element of the list. Throws if the list is empty. Arity: 1.
- length (list | string): Returns the integer length. Returns 0 if the argument is neither a list nor string. Arity: 1.
- contains (list, item): Returns a boolean indicating strict inclusion of item within list. Arity: 2.

#### Logic & Type Checking
- and (expr...): Short-circuits on the first falsey evaluation. Returns true if 0 arguments.
- or (expr...): Short-circuits on the first truthy evaluation. Returns false if 0 arguments.
- =: Checks if two number expressions are equal. Errors if either expression is not a number
- eq? + eqv?: Similar to Scheme's eqv?. If number/string, checks equality of num/string even if in different memory locations, 
otheriwse checks pointer equality
- equal? + equals?: Similar to Scheme's equal? but does a deep recursive comparison for lists
- not: Returns true if the expression is falsy, otherwise returns false
- <, >, <=, >= (expr1, expr2): Strict comparison. Arity: 2.
- type? (expr): Returns one of the following strings: "null", "string", "number", "boolean", "procedure", "list", or "unknown". Arity: 1.

#### Mathematics
- +, -, *, / (expr...): Evaluates sequentially from left to right. Arity: >= 2.
- modulo (expr1, expr2): Returns the mathematical remainder. Arity: 2.

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
} | {
    type: "Branch",
    cond: string, -- anima s-expression
    elems: {FormElement} -- if Branch is true
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