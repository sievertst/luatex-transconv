#!/usr/bin/env lua5.3
local cutting_markers = {}

local function new(self, conv)
    -- TODO: ensure proper encapsulation
    conv = conv or {} -- create converter object if not specified
    setmetatable(conv, self)
    self.__index = self -- make this the prototype for new converters
    return conv
end

local function get_sb_and_tone(self, sb)
    --[[
        Determines the tone of the syllable passed into it. Returns the
        syllable without the tone digit and the tone as an int.
    --]]

    return sb, 0
end

local function is_valid_sb(self,sb)
    return true
end

local function split_sbs(self, instring)
    --[[
        Split input string into syllables.
    --]]
    local sbs = {}

    if next(self.cutting_markers) ~= nil then -- checks if table is empty
        -- TODO: make cut before each marker
    else
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
    end

    return sbs
end

local Raw = {
    cutting_markers = {}, -- used for splitting

    --functions
    new = new,
    get_sb_and_tone = get_sb_and_tone,
    is_valid_sb = is_valid_sb,
    -- reorder = reorder,
    split_sbs = split_sbs,
}

return Raw
