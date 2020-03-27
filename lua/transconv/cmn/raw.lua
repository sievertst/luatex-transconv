#!/usr/bin/env lua5.3

--[[
    Use Hanyu Pinyin but with the tone as a number after the syllable. Both 0
    and 5 are accepted as markers for the neutral tone. Optionally use v instead
    of ü if that is more convenient.

    Optionally differentiate original velars before i and ü by spelling them as
    such (e.g. "Nan2ging1") for compatability with historicising schemes. G, k,
    h will be changed to j, q, x for schemes which don't make this distinction.
    Ü has to be spelt as "ü" in such a case to distinguish it from "u", e.g.
    "güan3".
--]]

local function get_sb_and_tone(self, sb)
    local last = string.sub(sb,-1)

    -- get tone number (including omitted unmarked tones)
    if tonumber(last) then -- returns nil if not a digit
        tone = tonumber(last)
        sb = string.sub(sb,1,-2) -- save syllable without tone number
    else
        tone = 5
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

local function split_sbs(self, instring)
    local sbs = {}

    -- TODO: exact enough?
    for sb in instring:gmatch("%W*[a-zA-Zü]*%d?") do
        table.insert(sbs, sb)
    end

    return sbs
end

local cmnraw = Raw:new{
    get_sb_and_tone = get_sb_and_tone,
    is_valid_sb = is_valid_sb,
    split_sbs = split_sbs,
}

return cmnraw
