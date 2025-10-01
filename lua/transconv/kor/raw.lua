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

  A syllable-final "q" can be used to indicate that the syllable causes
  strengthening of following syllable initial which is not indicated in
  Hangeul spelling (only within the same word): geulq'ja, joq'geon

  Long vowels can be marked with "=" after the vowel itself. Target schemes
  which don't support vowel length markers will simply ignore it.

  Use "xl/xr" and "xn" to indicate a ㄹ or ㄴ which has weakened in the Seoul
  dialect but is still present in other dialects (including the North Korean
  standard). Write this indicator either before "n" or directly before the
  vowel to indicate an ㄴ or ㅇ in the modern Seoul dialect respectively:

  - xlno'dong/xrno'dong: Seoul 노동, Pyeongyang 로동 (work)
  - xlyeong'do/xryeong'do: Seoul 영도, Pyeongyang 령도 (leadership)
  - xnyeong'byeon: Seoul 영변, Pyeongyang 녕변 (city in North Korea)

  Schemes which are specifically North Korean will automatically use the
  correct form and ignore the other, while schemes which allow for it will
  indicate the weakened consonant in Seoul.

  Arae-a can be spelt "v". Target schemes which don't support arae-a will
  treat it like "a".

  Examples: Han'gug'eo, Mi'gug-e ga-da, saeg'kkal, an'nyeong-ha-sip'ni'kka
]]

local korraw = Raw:new({
	cutting_markers = { " " },
})

return korraw
