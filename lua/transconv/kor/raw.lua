#!/usr/bin/env lua5.3

--[[
    Spell each syllable exactly as it is spelt in Hangeul, separating syllable
    blocks with apostrophes or – between separate morphemes – a hyphen.
    Individual letters use the same spelling as in Revised Romanisation (for
    consonants always the syllable-initial spelling).

    Arae-a can be spelt "v". Target schemes which don't support arae-a will
    treat it like "a".

    Long vowels can be marked with "=" after the vowel itself. Target schemes
    which don't support vowel length markers will simply ignore it.

    Example: Han'gug'eo, Mi'gug-e ga-da, saek'kkal, an'nyeong-ha-sip'ni'kka
--]]

function split_sbs(self, instring)
    return {instring}
end

local korraw = Raw:new{
    split_sbs = split_sbs,
}

return korraw
