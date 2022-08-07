#!/usr/bin/env lua5.3

--[[
    Spell each syllable exactly as it is spelt in Hangeul with each jamo in
    its Revised Romanisation spelling (for consonant jamo use their initial
    position spelling, even for letters in the batchim. Separate syllable
    blocks with apostrophes or – between separate morphemes – a hyphen.
    Individual letters use the same spelling as in Revised Romanisation (for
    consonants always the syllable-initial spelling).

    Final ㄼ before a consonant reduces to ㄹ in some words but ㅂ in others
    (e.g. 짧다 → 짤따 but 밟다 → 밥따). To distinguish the two, ㄼ which reduces
    to ㅂ should be spelt as "lbb": jjalb'da vs balbb'da

    Arae-a can be spelt "v". Target schemes which don't support arae-a will
    treat it like "a".

    Long vowels can be marked with "=" after the vowel itself. Target schemes
    which don't support vowel length markers will simply ignore it.

    Example: Han'gug'eo, Mi'gug-e ga-da, saek'kkal, an'nyeong-ha-sip'ni'kka
--]]

local korraw = Raw:new{
}

return korraw
