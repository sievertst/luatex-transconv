#!/usr/bin/env lua5.3

--[[
    Use tailo but with the tone as a number after the syllable. Use 0 for
    neutral tone.
--]]

local function get_sb_and_tone(self, sb)
    local last = string.sub(sb,-1)

    -- get tone number (including omitted unmarked tones)
    local tone
    if tonumber(last) then -- returns nil if not a digit
        tone = tonumber(last)
        sb = string.sub(sb,1,-2) -- save syllable without tone number
    elseif self.plosive_codas[last] then -- returns nil on index error
        tone = 4
    else
        tone = 1
    end

    return sb, tone
end

local function is_valid_sb(self, sb)
    -- return invalid if it contains a digit in another position besides last
    local notail = string.sub(sb, 1,-2)
    if sb:gsub("%d", "") ~= sb and notail:gsub("%d", "") ~= notail then
        return false
    end

    -- if all checks were negative:
    return true
end

local nanraw = Raw:new{
    -- list used for checking for rusheng with fuzzy tones
    plosive_codas = {["p"] = true, ["t"] = true, ["k"] = true, ["h"] = true},

    -- state the syllable separator in the raw scheme so it can be deleted
    -- when the string is split up into syllables
    sb_sep = "-",

    -- functions
    get_sb_and_tone = get_sb_and_tone,
    is_valid_sb = is_valid_sb,
}

return nanraw
