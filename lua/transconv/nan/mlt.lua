#!/usr/bin/env lua5.3

local function convert(self, instring)
    --[[
        Use splitting function to split input strings into syllables.  For
        each syllable, check cache if it has been converted before. If not,
        delegate computation to actual conversion function. Either way, join
        the outputs back together and return.
    --]]

    -- split input into sbs
    local sbs = self.raw:split_sbs(instring)

    local outsbs = {}

    for _, sb in ipairs(sbs) do
        -- Do replacements only on syllables that are valid in raw scheme
        if self.raw:is_valid_sb(sb) then
            if self.cache[sb] == nil then
                self.cache[sb] = self.to_target_scheme(self, sb)
            end
            table.insert(outsbs, self.cache[sb])
        else
            table.insert(outsbs, sb)

        end

    end

    return self.join_sbs(self, outsbs)
end

local function place_tone_digit(self, sb, tone)
    -- return the result
    return sb
end

local Tailo = Converter:new{
    name = "nan.mlt",
    raw = require(transconv.path_of(...)..".raw"),
    sb_sep = "",

    rep_strings = {
        {"ts(h?)i", "c%1i"}, {"ts", "z"},
    },

    second_rep_strings = {
        {"if", "y"}, {"uf", "w"},
        {"air", "ae"}, {"aur", "ao"}, {"ir", "ie"}, {"ur", "uo"}, {"er", "ea"},
    },

    -- functions
    convert = convert,
    place_tone_digit = place_tone_digit,
}

return Tailo
