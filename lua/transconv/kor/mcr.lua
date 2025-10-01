#!/usr/bin/env lua5.3

--[[
  The original version of McCune-Reischauer.
]]

local function to_target_scheme(self, instring)
	-- insert ' at the end of the string, so the end of a string-final syllable
	-- doesn't have to be a separate case. The ' is deleted during replacements
	return self.do_str_rep(self, instring .. "'", self.rep_strings)
end

local MCR = Converter:new({
	name = "kor.mcr",
	raw = require(transconv.path_of(...) .. ".raw"),

	rep_strings = {
		-- level out unsupported features: vowel length, arae-a, following
		-- consonant strengthening and indication of assimilated ㄹ/ㄴ
		{ "=", "" },
		{ "v", "a" },
		{ "q", "" },
		{ "x[lrn]", "" },

		-- insert ' at the end of word-final syllables for easier processing
		{ "([^'])([%.!%?])", "%1'%2" },

		-- always use r for initial rieul
		{ "l([aeiouyw])", "r%1" },

		-- insert marker at the end of syllables which are followed by
		-- vowel-initial syllables
		{ "([^v])(['%-][aeiouyw])", "%1v%2" },
		-- also insert the marker at the beginning of syllables if the previous
		-- one is open or ends in a sonorant
		{ "([aeioulmn]['%-])([^v])", "%1v%2" },

		-- write e as ë after a and o (to distinguish ae and oe from a-e and o-e)
		{ "([ao])v'e", "%1'\\\"{e}" },

		-- replace vowels
		{ "eo", "\\u{o}" },
		{ "wo", "w\\u{o}" },
		{ "eu", "\\u{u}" },
		{ "ui", "\\u{u}i" },

		-- temporarily replace ng so we don't have to worry about excluding it
		-- when we handle final g
		{ "ng", "ŋ" },

		-- ensure distinguishing n'g from ng (x will become ' later)
		{ "n'vg", "n'xvg" },
		{ "ŋv'", "ŋvx'" },

		-- insert marker after aspiratae (later we'll use ', but that is
		-- currently still used as a syllable separator)
		{ "([ptk])([^x])", "%1x%2" },
		{ "pxpx", "pp" },
		{ "txtx", "tt" },
		{ "kxkx", "kk" },
		{ "ch([^x])", "chx%1" },

		-- hieut-assimilations (including nh and lh)
		{ "g'h", "k'h" },
		{ "h'[gk]", "'k" },
		{ "d'h", "t'h" },
		{ "h'[dt]", "'t" },
		{ "b'h", "p'h" },
		{ "h'[bp]", "'p" },
		{ "j'h", "ch'h" },
		{ "h'j", "'ch" },
		{ "h'ch", "'ch" },
		{ "g%-h", "k-h" },
		{ "h%-[gk]", "-k" },
		{ "d%-h", "t-h" },
		{ "h%-[dt]", "-t" },
		{ "b%-h", "p-h" },
		{ "h%-[bp]", "-p" },
		{ "j%-h", "ch-" },
		{ "h%-j", "-ch" },
		{ "h%-ch", "-ch" },

		-- double consonants
		{ "gs(['%-])", "k%1" },
		{ "[lr]g(['%-])", "k%1" },
		{ "nj(['%-])", "n%1" },
		{ "l[bst](['%-])", "l%1" },
		{ "lp(['%-])", "p%1" },
		{ "lm(['%-])", "m%1" },
		{ "bs(['%-])", "p%1" },
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

		{ "l(['%-])vh", "r%1h" },

		-- syllable-finals (before vowel)
		{ "gsv", "ksv" },
		{ "rg", "lgv" },
		{ "nhv", "nv" },
		{ "[lr]hv", "rv" },

		-- palatalisation of digeut and ti-eut
		{ "dv(['%-])i", "jv'i" },
		{ "txv(['%-])i", "chv'i" },

		-- write tenuis consonants as voiceless, except between sonorants
		{ "g", "k" },
		{ "kv", "gv" },
		{ "vk", "vg" },
		{ "d", "t" },
		{ "tv", "dv" },
		{ "vt", "vd" },
		{ "b", "p" },
		{ "pv", "bv" },
		{ "vp", "vb" },
		{ "j", "ch" },
		{ "chv", "jv" },
		{ "vch", "j" },
		{ "chch", "tch" },
		-- repair aspiratae
		{ "gx", "kx" },
		{ "dx", "tx" },
		{ "bx", "px" },
		{ "jx", "chx" },

		-- get rid of helping characters
		{ "ŋ", "ng" },
		{ "v", "" },
		{ "'", "" },
		{ "x", "'" },

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

return MCR
