#!/usr/bin/env lua5.3

-- local function convert(self, instring)
-- The core function of the converter which will be called by the macros,
-- so it always has to be present. Takes in an input string and returns
-- the conversion output string.
-- You can redefine it to override the whole default conversion process,
-- or you can override just part of it by redefining the helper functions
-- called by the default version of convert().

-- By default it will:
--   1) call the split_syllables function of the associated raw scheme to
--      split the input into syllables
--   2) let the raw scheme check each syllable if it's valid.
--   3) Invalid syllables are funneled directly into the output list (so
--      you can mix for example English words into the input text)
--   4) If the syllable is valid, it checks whether the syllable has been
--      converted before and stored in the cache
--   5) Syllables which weren't stored yet are redirected to the
--      to_target_scheme function for conversion. Then the result is
--      stored in the chache for the future
--   6) Either way, the conversion result is put into the output list
--   7) After all syllables have been processed, calls the join_sbs
--      function to join the output syllables back together to a string
--      and returns it.
-- end

-------------------------------------------------------------------------------
-- helper functions provided by the default converter which you can redefine --
-------------------------------------------------------------------------------

-- local function to_target_scheme(self, sb)
-- Takes in a single syllable in the raw scheme, converts it to the
-- target scheme and returns it.
--
-- By default:
--   1) calls the raw scheme's get_sb_and_tone function to separate the
--      syllable and the tone number from each other
--   2) Performs primary string replacements by calling do_str_rep using
--      the rep_strings attribute
--   3) Calls place_tone_digit to place the digit for the tone number
--      after the character which will carry the marker.
--   4) Calls do_str_rep again, this time using the second_rep_strings
--      attribute, in order to perform string replacements which rely on
--      the tone number already being in the right place (for example if
--      a tone is marked by doubling the vowel).
--   5) Calls add_tone_marker to replace the tone digit with the correct
--      tone marker (unless the no_tones attribute is set to true, in
--      which case the tone is simply discarded).
--   6) Returns the result
-- end

-- local function join_sbs(self, sbs)
-- takes in a list of syllables (sbs), joins them together to a
-- string and returns it.

-- By default puts the sb_sep character between each syllable, except
-- before whitespace or special characters.
-- end

-- local function do_str_rep(self, instring, rep_dict)
-- Takes in a string and a list of the format described for
-- rep_strings below. Loops over that list in order and replaces
-- each occurrence of the raw string within the input with the
-- corresponding replacement. Finally returns the result.
-- end

-- local function place_tone_digit(self, sb, tone)
-- Takes in a string containing a single syllable and a tone number.
-- Identifies the character which will take the tone diacritic and
-- inserts the tone digit after that character. Then returns the result.
--
-- By default simply appends the digit to the end of the string.
-- end

-- local function add_tone_marker(self, instring)
-- Takes in an input string and replaces each tone digit with the
-- corresponding tone marker on the preceding character. Then returns the
-- result.
--
-- By default it loops over the tone_markers dictionary and tries finding
-- each tone number in the string. If it does, it deletes that number and
-- wraps the preceding character in the pattern "\\marker{character}"
-- (with "marker" being the marker defined for this tone in the
-- tone_markers dictionary). When it's done looping over the dictionary,
-- that means all tones have been replaced, so the string is returned.
-- end

---------------------------------------------
-- Add your own functions here if you want --
---------------------------------------------

-- Make functions local and always pass self as the first argument. Remember to
-- associate your function with the converter object below by adding them to the
-- object like this:
--   my_function = my_function,

-- the following defines the converter object
local Jyutping = Converter:new({
	-- scheme name. Should be identical to the language folder name + the file
	-- name without the extension, separated with a dot (e.g. "cmn.pinyin" for
	-- Hanyu Pinyin)
	name = "yue.jyutping",
	-- import the raw scheme -- should normally not be changed
	raw = require(transconv.path_of(...) .. ".raw"),

	-- this character is placed between syllables by the default join_syllables
	-- function
	sb_sep = "",

	-- the macro names for each tone. Put in the correct place by the
	-- place_tone_diacritic function.
	-- Unmarked tones should be set false.
	-- tone_markers = {
	--     [1] = 1,
	--     [2] = 2,
	--     [3] = 3,
	--     [4] = 4,
	--     [5] = 5,
	--     [6] = 6,
	-- },

	-- should contain pairs of strings: The first is the string to be replaced,
	-- the second the replacement string
	rep_strings = {},

	-- functions
	-- remember to associate all functions you (re)defined above with your table
	-- like so:
	--   my_function = my_function,
})

return Jyutping
