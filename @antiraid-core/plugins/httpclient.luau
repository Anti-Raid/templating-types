local dt = require("@antiraid/datetime")

export type Url = {
    host: string, -- The host of the URL
    port: number, -- The port of the URL
    scheme: string, -- The scheme of the URL (e.g., "http", "https")
    path: string, -- The path of the URL
    query: string?, -- The query string of the URL
    fragment: string?, -- The fragment of the URL
}

export type Headers = {
    get: (key: string) -> string?, -- Get a header by key
    set: (key: string, value: string) -> (), -- Set a header
    remove: (key: string) -> (), -- Remove a header by key
    headers_bytes: () -> {[string]: {number}}, -- Get all headers as a table of strings to bytes
    headers_str: () -> {[string]: string}, -- Get all headers as a table of strings to strings
}

export type Request = {
    --- The HTTP method (e.g., "GET", "POST")
    method: string, 
    --- The URL of the request
    ---
    --- The returned object will be a copy of the URL so mutating this object without explicit assignment
    --- will not affect the original URL.
    url: Url,
    --- The headers of the request
    --
    --- The returned object will be a copy of the headers so mutating this object without explicit assignment
    --- will not affect the original headers. 
    headers: Headers,
    --- The body of the request, can be a string, table, or buffer. When set, it will be serialized to bytes.
    ---
    --- When reading, the body will be a buffer
    body_bytes: any,
    --- The timeout for the request, can be a number (in seconds) or a `timedelta` object
    ---
    --- Max value: 5 seconds
    timeout: dt.TimeDelta,
    --- The HTTP version of the request, defaults to "HTTP/1.1"
    version: "HTTP/0.9" | "HTTP/1.0" | "HTTP/1.1" | "HTTP/2.0" | "HTTP/3.0",
    --- @yields
    ---
    --- Sends the request and returns a response object
    send: () -> Response,
}

export type Response = {
    --- URL of the response
    url: Url,
    --- The status code of the response
    status: number,
    --- The content length of the response
    content_length: number?,
    --- The headers of the response
    headers: Headers,
    --- @yields
    ---
    --- Reads the response as text (but does not have to be UTF-8 encoded) 
    ---
    --- Note that this will destroy the Response object and cause all calls to it to fail after this.
    text: () -> string,
    --- @yields
    ---
    --- Reads the response as JSON, will return a Lua table
    ---
    --- Note that this will destroy the Response object and cause all calls to it to fail after this.
    json: () -> any,
    --- @yields
    ---
    --- Reads the response as bytes, will return a buffer
    ---
    --- Note that this will destroy the Response object and cause all calls to it to fail after this.
    bytes: () -> buffer
}

export type Plugin = {
    --- Creates a new request
    new_request: (method: string, url: string) -> Request,
    --- Creates a new empty headers object
    new_headers: () -> Headers,
    --- Parses a URL string into a Url object
    new_url: (url: string) -> Url,
}

return {}