#!/usr/bin/env lua5.3

--[[
  Use a slight variation on the ArabTex spelling. This transliteration is based
  on BS 4280 (below referred to as BS for brevity).

  Specifically:
  - all letters which have no diacritic in BS also don't have one here
  - BS dots below are marked with a preceding . (e.g. ".s" for ṣ)
  - BS underlines are marked with a preceding _ (e.g. "_t" for ṯ)
  - BS carons are marked with a preceding ^ (e.g. "^g" for ǧ)
  - ʻayn is transcribed as `
  - hamzah is written as ' before a vowel. Initial hamzah can be elided if
    desired but being explicit may help when encountering bugs
  - Alif maddah is indicated with 'aa
  - Shaddah is transcribed with a doubled consonant letter (e.g. "^saddaT"). This
    includes after the definite article, e.g. "al-_S_Siin"
  - alif maqṣūrah is indicated with _A; dagger alif with _a;
  - the article should always be spelt with an l -- either al- or 'l- depending
    on whether the vowel is elided. Schemes will take care of indicating
    assimilation before sun letters as appropriate
  - when there are prefixed definite articles, prepositions and conjunctions,
    the morpheme border should be explicitly indicated with a hyphen (e.g.
    "bi-'smi 'l-ll_ahi 'l-rra.hm_ani 'l-rra.hiimi")

  Deviations from the ArabTeX spelling:
  - use double vowel letters for long vowels instead of capitals (e.g. "aa"
    instead of "A"). This means you have control over capitalisation on the
    input side.
  - exception: tā' marbūṭah is transcribed T in construct state, when it's
    pronounced, otherwise H
  - always explicitly indicate waslah with an '
  - nunation is indicated with _n
--]]

local function is_valid_sb(self, sb)
    return true
end

local function reorder(self, syllable)
    --[[
        Arabic doesn't have tones, so no reordering is necessary.
    --]]
    return syllable
end

local function split_sbs(self, instring)
    --[[
        Split input string into syllables.
    --]]
    local sbs = {instring}

    return sbs
end

local sanraw = Raw:new{
    cutting_markers = {" "}, -- used for splitting

    -- functions
    is_valid_sb = is_valid_sb,
    reorder = reorder,
    split_sbs = split_sbs,
}

return sanraw
