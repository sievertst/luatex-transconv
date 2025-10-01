#!/usr/bin/env lua5.3
local function place_tone_digit(self, sb, tone)
	-- for oa and oe, put the digit behind the o unless there is a third
	-- letter following (i.e. in oan and oai). In that case put the
	-- diacritic on the a.
	if string.match(sb, "[oO][ae]$") then
		return sb:gsub("([oO])([ae])", "%1" .. tostring(tone) .. "%2")
	end

	-- check for letters in the order "a e o u i ng m" and place the digit
	-- behind the first one that is found
	local vowels = {
		"A",
		"a",
		"E",
		"e",
		"O",
		"o",
		"U",
		"u",
		"I",
		"i",
		"Ng",
		"NG",
		"ng",
		"M",
		"m",
	}
	for _, v in ipairs(vowels) do
		if string.match(sb, v) then
			-- put the number behind the first letter in the match
			local vhead = string.sub(v, 1, 1)
			local vtail = string.sub(v, 2)
			local rep = string.format("%s%d%s", vhead, tone, vtail)
			return sb:gsub(v, rep, 1)
		end
	end

	-- return the result
	return sb
end

local POJ = Converter:new({
	name = "nan.poj",
	raw = require(transconv.path_of(...) .. ".raw"),
	sb_sep = "-",
	tone_markers = {
		-- unmarked tones should be set false
		[0] = false,
		[1] = false,
		[2] = "'",
		[3] = "`",
		[4] = false,
		[5] = "^",
		[6] = "v",
		[7] = "=",
		[8] = "textvbaraccent",
		[9] = "H",
	},
	rep_strings = {
		{ "%-%-", "{-}{-}" }, -- prevent dash ligature for neutral tone marker
		{ "ts", "ch" },
		{ "u([ae])", "o%1" },
		{ "oo", "o͘" },
		{ "ing", "eng" },
		{ "ik", "ek" },
		{ "nnh", "hnn" },
		{ "nn", "\\textsuperscriptn{}" },
	},

	second_rep_strings = {
		{ "{i}", "{\\i}" }, -- use dotless i with diacritics
	},

	-- functions
	place_tone_digit = place_tone_digit,
})

return POJ
