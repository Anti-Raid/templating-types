--- Represents the area which contains text in a CAPTCHA.
export type Geometry = {
    --- The minimum x coordinate of the area which contains text (inclusive).
    ---
    --- Max size: u32
    left: number,

    --- The maximum x coordinate of the area which contains text (inclusive).
    ---
    --- Max size: u32
    right: number,

    --- The minimum y coordinate of the area which contains text (inclusive).
    ---
    --- Max size: u32
    top: number,

    --- The maximum y coordinate of the area which contains text (inclusive).
    --- 
    --- Max size: u32
    bottom: number,
}

--- Represents a color in RGB format.
export type SerdeColor = {
    --- The red component of the color (0-255)
    r: number,
    --- The green component of the color (0-255)
    g: number,
    --- The blue component of the color (0-255)
    b: number,
}

--- Filter that inverts the colors of an image.
export type ColorInvertFilter = {
    filter: "ColorInvert",
}

--- Filter that generates a CAPTCHA with a specified number of cows (circles/other curvical noise)
export type CowFilter = {
    filter: "Cow",
    --- The minimum radius of the cows
    ---
    --- Max size: u32
    min_radius: number,
    --- The maximum radius of the cows
    ---
    --- Max size: u32
    max_radius: number,
    --- The number of cows to generate
    ---
    --- Max size: u32
    n: number,
    --- Whether to allow duplicate cows
    allow_duplicates: boolean,
    --- The geometry of the area which contains text
    geometry: Geometry?,
}

--- Filter that creates a specified number of dots
export type DotFilter = {
    filter: "Dot",
    --- The number of dots to generate
    ---
    --- Max size: u32
    n: number,
    --- The minimum radius of the dots
    ---
    --- Max size: u32
    min_radius: number,
    --- The maximum radius of the dots
    ---
    --- Max size: u32
    max_radius: number,
}

--- Filter that creates a grid (horizontal/vertical lines with a specified gap in X and Y direction)
---
--- (think graph paper)
export type GridFilter = {
    filter: "Grid",
    --- The Y gap between the vertical lines
    ---
    --- Max size: u32
    y_gap: number,
    --- The X gap between the horizontal linesPrimitives.u32
    ---
    --- Max size: u32
    x_gap: number,
}

--- Draw lines/rectangles on the screen
export type LineFilter = {
    filter: "Line",
    --- Point 1, must be an array of two numbers
    ---
    --- Max size: f32
    p1: {number},
    --- Point 2, must be an array of two numbers
    ---
    --- Max size: f32
    p2: {number},
    --- The thickness of the line
    ---
    --- Max size: u32
    thickness: number,
    --- The color of the line
    color: SerdeColor,
}

--- Adds some random noise at a specified probability
export type NoiseFilter = {
    filter: "Noise",
    --- The probability of adding noise
    ---
    --- Max size: f32
    prob: number,
}

--- Creates a random line somewhere
export type RandomLineFilter = {
    filter: "RandomLine"
}

--- Creates a wave in a given direction (horizontal/vertical)
export type WaveFilter = {
    filter: "Wave",
    --- The frequency of the wave
    ---
    --- Max size: f32
    f: number,
    --- The amplitude of the wave
    ---
    --- Max size: f32
    amp: number,
    --- The direction of the wave
    d: "horizontal" | "vertical",
}

--- Represents a filter that can be applied to an image.
export type Filter = ColorInvertFilter 
    | CowFilter
    | DotFilter
    | GridFilter
    | LineFilter
    | NoiseFilter
    | RandomLineFilter
    | WaveFilter

--- Captcha configuration
export type CaptchaConfig = {
    --- The number of characters the CAPTCHA should have (0-255)
    char_count: number,
    --- The list of filters
    filters: {Filter},
    --- The size of the viewbox to render the CAPTCHA in.
    --- (first element is width, second element is height)
    ---
    --- Max size: u32
    viewbox_size: {number},
    --- At what index of CAPTCHA generation should a viewbox be created at.
    ---
    --- Max size: u32
    set_viewbox_at_idx: number,
}

export type Captcha = {
    --- The text of the CAPTCHA.
    text: string,
    --- The image of the CAPTCHA (Luau buffer).
    image: buffer
}

export type Plugin = {
    --- @yields
    ---
    --- Creates a new CAPTCHA with the given configuration.
    Create: (config: CaptchaConfig) -> Captcha,
}

return {}