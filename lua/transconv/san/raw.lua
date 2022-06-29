#!/usr/bin/env lua5.3

--[[
  Spell everything in Velthuis.

  Exceptions:
  - capital letters are not allowed as alternatives for special letters but
    are interpreted as capitalised versions of the lowercase letter
  - For di- or trigraphs, each letter has to be capitalised to get a capital
    output
  - use underscore for nuqta letters: _ka, _kha, _ga, _za, _zha, _ra, _rha,
    _pha, _va. The following shorthands are permitted but may not be supported
    by all schemes:
    - q instead of _k
    - z instead of _z
    - zh instead of _zh
    - f instead of _ph
    - w instead of _v
--]]

local function is_valid_sb(self, sb)
    return true
end

local function reorder(self, syllable)
    --[[
        Sanskrit doesn't have tones, so no reordering is necessary.
    --]]
    return syllable
end

local function split_sbs(self, instring)
    --[[
        Split input string into syllables.
    --]]
    local sbs = {instring}

    --[[
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
    --]]

    return sbs
end

local sanraw = Raw:new{
    cutting_markers = {}, -- used for splitting

    -- functions
    is_valid_sb = is_valid_sb,
    reorder = reorder,
    split_sbs = split_sbs,
}

return sanraw
