#!/usr/bin/env lua5.3

-- This file determines your raw scheme (how the input for conversion should be
-- spelled).

--[[
    Describe the spelling rules of your raw scheme here.

    Be aware that your raw scheme must (be able to) unambiguously reflect every
    feature which is present in any one of the intended target schemes,
    otherwise the result might be incorrect. For example in Japanese, even
    though the Kana じ and ぢ are pronounced identically (ji), a minority of
    romanisation schemes distinguish the two, so the original Kana spelling can
    be reconstructed from the romanisation. Therefore, the raw scheme also has
    to make that distinction for correct conversion to such schemes.
--]]

local function is_valid_sb(self, sb)
    --[[
        Take a string as input (by default a single syllable) and checks
        whether it is valid in the raw scheme. Returns true if it is and false
        otherwise.
    --]]
    return true
end

local function split_sbs(self, instring)
    --[[
        Split input string into syllables and returns them as a list (for
        example needed for tonal languages where each syllable carries their own
        tone). The default definition below actually splits the string into
        words (based on spaces and special characters).
    --]]
    local sbs = {}

    -- TODO: how accurate is this pattern?
    for sb in instring:gmatch("%W*%w*") do

        -- Test if a) this raw scheme has a (sensible) syllable separator
        -- set, b) that separator is non-empty, and c) the current syllable
        -- starts with it. If so, remove it
        if type(self.sb_sep) == "string" and self.sb_sep:len() > 0 and
            sb:match("^"..self.sb_sep) then
                sb = sb:sub(self.sb_sep:len() + 1)
        end

        table.insert(sbs, sb)
    end

    return sbs
end

local jpnraw = Raw:new{
    cutting_markers = {}, -- list of characters which mark a syllable border

    -- functions
    -- (this section just associates the functions defined above with the raw
    -- scheme object)
    is_valid_sb = is_valid_sb,
    reorder = reorder,
    split_sbs = split_sbs,
}

return jpnraw
