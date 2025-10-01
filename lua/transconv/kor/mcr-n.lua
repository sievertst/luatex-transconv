#!/usr/bin/env lua5.3

--[[
  The variant of McCune-Reischauer used as the official transcription system
  in North Korea.
]]

local function to_target_scheme(self, instring)
	-- insert ' at the end of the string, so the end of a string-final syllable
	-- doesn't have to be a separate case. The ' is deleted during replacements
	return self.do_str_rep(self, instring .. "'", self.rep_strings)
end

local MCRN = Converter:new({
	name = "kor.mcr-n",
	raw = require(transconv.path_of(...) .. ".raw"),

	rep_strings = {
		-- level out unsupported features: vowel length, arae-a and following
		-- consonant strengthening
		{ "=", "" },
		{ "v", "a" },
		{ "q", "" },

		-- use the North Korean form of consonants which have weakened in Seoul
		{ "xln", "r" },
		{ "xrn", "r" },
		{ "xl", "r" },
		{ "xr", "r" },
		{ "xn", "n" },

		-- insert ' at the end of word-final syllables for easier processing
		{ "([^'])([%.!%?])", "%1'%2" },

		-- always use r for initial rieul
		{ "l([aeiouw])", "r%1" },

		-- insert marker at the end of syllables which are followed by
		-- vowel-initial syllables
		{ "([^v])(['%-][aeiouyw])", "%1v%2" },
		-- also insert the marker at the beginning of syllables if the previous
		-- one is open or ends in a sonorant
		{ "([aeiou]['%-])([^v])", "%1v%2" },

		-- write e as ë after a and o (to distinguish ae and oe from a-e and o-e)
		{ "av'e", "a'\\\"{e}" },
		{ "ov'e", "o'\\\"{e}" },

		-- replace vowels
		{ "eo", "\\u{o}" },
		{ "wo", "w\\u{o}" },
		{ "eu", "\\u{u}" },
		{ "ui", "\\u{u}i" },

		-- temporarily replace ng so we don't have to worry about excluding it
		-- when we handle final g
		{ "ng", "ŋ" },

		-- ensure distinguishing n'g from double ieung
		{ "n'vg", "n-vg" },
		{ "ŋv'", "ŋv-" },
		{ "ŋv%-y", "ŋv'y" },
		{ "ŋv%-w", "ŋv'w" },

		-- hieut-assimilations (including nh and lh)
		{ "g'h", "kh'h" },
		{ "h'[gk]", "'kh" },
		{ "d'h", "th'h" },
		{ "h'[dt]", "'th" },
		{ "b'h", "ph'h" },
		{ "h'[bp]", "'ph" },
		{ "j'h", "tsh'h" },
		{ "h'j", "'tsh" },
		{ "h'ch", "'tsh" },
		{ "g%-h", "kh-h" },
		{ "h%-[gk]", "-kh" },
		{ "d%-h", "th-h" },
		{ "h%-[dt]", "-th" },
		{ "b%-h", "ph-h" },
		{ "h%-[bp]", "-ph" },
		{ "j%-h", "tsh-" },
		{ "h%-j", "-tsh" },
		{ "h%-ch", "-tsh" },

		-- insert marker after aspiratae (later we'll use h, but that is
		-- currently still used as a syllable separator)
		{ "([ptk])([^h])", "%1h%2" },
		{ "phph", "pp" },
		{ "thth", "tt" },
		{ "khkh", "kk" },

		-- write tenuis consonants as voiceless, except between sonorants
		{ "g", "k" },
		{ "d", "t" },
		{ "b", "p" },

		-- j → ts
		{ "jj", "tss" },
		{ "j", "ts" },
		{ "ch", "tsh" },

		-- double consonants
		{ "ks(['%-])", "k%1" },
		{ "[lr]g(['%-])", "k%1" },
		{ "nts(['%-])", "n%1" },
		{ "l[ps](['%-])", "l%1" },
		{ "lth(['%-])", "l%1" },
		{ "ps(['%-])", "p%1" },
		{ "lm(['%-])", "m%2" },
		{ "lph(['%-])", "p%2" },
		-- syllable-final (not before vowel)
		{ "gg?(['%-])", "k%1" },
		{ "kk(['%-])", "k%1" },
		{ "dd(['%-])", "t%1" },
		{ "ss(['%-])", "t%1" },
		{ "jj(['%-])", "t%1" },
		{ "tt(['%-])", "t%1" },
		{ "[dsjh](['%-])", "t%1" },
		{ "ch(['%-])", "t%1" },
		{ "r(['%-])", "l%1" },
		{ "bb?(['%-])", "p%1" },
		{ "pp(['%-])", "p%1" },

		-- syllable-finals (before vowel)
		{ "ksv", "ksv" },
		{ "rk", "lkv" },
		{ "nhv", "nv" },
		{ "[lr]hv", "rv" },

		-- palatalisation of digeut and ti-eut
		{ "tv(['%-])i", "tsv'i" },
		{ "thv(['%-])i", "tshv'i" },

		-- get rid of helping characters
		{ "ŋ", "ng" },
		-- insert - before syllable-initial vowels (but pay attention not to
		-- produce any double hyphens (if there already was a dividing hyphen)
		-- or to accidentally delete any that the user entered
		{ "v'", "-v" },
		-- but no hyphen for w, y or ng between vowels
		{ "%-v([wy])", "%1" },
		{ "ng%-v", "ng" },
		{ "%-v%-", "-" },
		{ "v", "" },
		{ "'", "" },
		{ "x", "h" },

		-- assimilations
		{ "k'?[nr]", "ngn" },
		{ "t'?[nr]", "nn" },
		{ "p'?[nr]", "mn" },
		{ "k'?m", "ngm" },
		{ "t'?m", "nm" },
		{ "p'?m", "mm" },
		{ "l[nr]", "ll" },
		{ "nl", "ll" },

		-- special
		{ "swi", "shwi" },
	},

	sb_sep = " ",

	-- -- functions
	to_target_scheme = to_target_scheme,
	convert = convert,
})

return MCRN
