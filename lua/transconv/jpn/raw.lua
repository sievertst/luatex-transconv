#!/usr/bin/env lua5.3

--[[
  Spell everything exactly as in Kana:
  - spell particles the way they are written: -は as "-ha", -へ as "-he"
  - spell ち as "ti", つ as "tu", じ as "zi", ぢ "di" etc
  - long vowels separate

  But:
  - write chōonpu as "="
  - if you need to indicate a syllable boundary (either after ん or between two
    vowels which should not be contracted), separate them with an apostrophe.
    E.g. 湖(みずうみ): mizu'umi
  - separate affixes with hyphens: 日本(にほん)は: nihon-ha
--]]

local function is_valid_sb(self, sb)
    return true
end

local function reorder(self, syllable)
    --[[
        Takes a syllable with the tone number somewhere in the middle and
        moves it to the correct place.
    --]]
    return syllable
end

local function split_sbs(self, instring)
    --[[
        Split input string into syllables.
    --]]
    local sbs = {}

    -- TODO: how accurate is this pattern?
    for sb in instring:gmatch("%W*[%w=%-]*") do

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
    cutting_markers = {" "}, -- used for splitting

    -- functions
    is_valid_sb = is_valid_sb,
    reorder = reorder,
    split_sbs = split_sbs,
}

return jpnraw
