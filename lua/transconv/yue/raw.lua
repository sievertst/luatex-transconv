#!/usr/bin/env lua5.3

--[[
    Use Jyutping.
--]]

local function get_sb_and_tone(self, sb)
    local last = string.sub(sb,-1)

    -- get tone number (including omitted unmarked tones)
    if tonumber(last) then -- returns nil if not a digit
        tone = tonumber(last)
        sb = string.sub(sb,1,-2) -- save syllable without tone number
    else
        tone = 0
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
    for sb in instring:gmatch("%W*%a*%d?") do
        table.insert(sbs, sb)
    end

    return sbs
end

local yueraw = Raw:new{
    get_sb_and_tone = get_sb_and_tone,
    is_valid_sb = is_valid_sb,
    split_sbs = split_sbs,
}

return yueraw
