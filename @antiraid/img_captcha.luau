local Primitives = require "@antiraid-core/primitives" 
local promise = require "@antiraid/promise"

--- Represents the area which contains text in a CAPTCHA.
export type Geometry = {
    --- The minimum x coordinate of the area which contains text (inclusive).
    left: Primitives.u32,
    --- The maximum x coordinate of the area which contains text (inclusive).
    right: Primitives.u32,
    --- The minimum y coordinate of the area which contains text (inclusive).
    top: Primitives.u32,
    --- The maximum y coordinate of the area which contains text (inclusive).
    bottom: Primitives.u32,
}

--- Represents a color in RGB format.
export type SerdeColor = {
    --- The red component of the color.
    r: Primitives.u8,
    --- The green component of the color.
    g: Primitives.u8,
    --- The blue component of the color.
    b: Primitives.u8,
}

--- Filter that inverts the colors of an image.
export type ColorInvertFilter = {
    filter: "ColorInvert",
}

--- Filter that generates a CAPTCHA with a specified number of cows (circles/other curvical noise)
export type CowFilter = {
    filter: "Cow",
    --- The minimum radius of the cows
    min_radius: Primitives.u32,
    --- The maximum radius of the cows
    max_radius: Primitives.u32,
    --- The number of cows to generate
    n: Primitives.u32,
    --- Whether to allow duplicate cows
    allow_duplicates: boolean,
    --- The geometry of the area which contains text
    geometry: Geometry?,
}

--- Filter that creates a specified number of dots
export type DotFilter = {
    filter: "Dot",
    --- The number of dots to generate
    n: Primitives.u32,
    --- The minimum radius of the dots
    min_radius: Primitives.u32,
    --- The maximum radius of the dots
    max_radius: Primitives.u32,
}

--- Filter that creates a grid (horizontal/vertical lines with a specified gap in X and Y direction)
---
--- (think graph paper)
export type GridFilter = {
    filter: "Grid",
    --- The Y gap between the vertical lines
    y_gap: Primitives.u32,
    --- The X gap between the horizontal lines
    x_gap: Primitives.u32,
}

--- Draw lines/rectangles on the screen
export type LineFilter = {
    filter: "Line",
    --- Point 1, must be an array of two numbers
    p1: {Primitives.f32},
    --- Point 2, must be an array of two numbers
    p2: {Primitives.f32},
    --- The thickness of the line
    thickness: Primitives.f32,
    --- The color of the line
    color: SerdeColor,
}

--- Adds some random noise at a specified probability
export type NoiseFilter = {
    filter: "Noise",
    --- The probability of adding noise
    prob: Primitives.f32,
}

--- Creates a random line somewhere
export type RandomLineFilter = {
    filter: "RandomLine"
}

--- Creates a wave in a given direction (horizontal/vertical)
export type WaveFilter = {
    filter: "Wave",
    --- The frequency of the wave
    f: Primitives.f32,
    --- The amplitude of the wave
    amp: Primitives.f32,
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
    --- The number of characters the CAPTCHA should have.
    char_count: Primitives.u8,
    --- The list of filters
    filters: {Filter},
    --- The size of the viewbox to render the CAPTCHA in.
    --- (first element is width, second element is height)
    viewbox_size: {Primitives.u32},
    --- At what index of CAPTCHA generation should a viewbox be created at.
    set_viewbox_at_idx: Primitives.u8,
}

--- Creates a new CAPTCHA with the given configuration.
local function new(config: CaptchaConfig): promise.LuaPromise<{Primitives.u8}>
    error("Implemented internally in AntiRaid runtime!")
end

return {
    new = new
}