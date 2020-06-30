#!/usr/bin/env lua5.3

local function convert(self, instring)
    return instring
end

local function place_tone_digit(self, sb, tone)
    -- return the result
    return sb
end

local Tailo = Converter:new{
    name = "nan.mlt",
    raw = require(transconv.path_of(...)..".raw"),
    sb_sep = "",

    rep_strings = { },

    second_rep_strings = { },

    -- functions
    convert = convert,
    place_tone_digit = place_tone_digit,
}

return Tailo
