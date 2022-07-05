#!/usr/bin/env lua5.3

-- TODO: groups don't seem to work properly in string substitution

-- factory function
local new = function(self, conv)
    -- TODO: ensure proper encapsulation
    conv = conv or {} -- create converter object if not specified
    setmetatable(conv, self)
    conv.cache = {} -- necessary to prevent converters from trying to share their cache
    self.__index = self -- make this the prototype for new converters
    return conv
end

local add_tone_marker = function(self, instring)
    --[[
        Receives a string and returns it with tone digits replaced with the
        correct diacritics.
    --]]
    local t = 0 -- use while because Lua for loops starts at index 1 and we want to include 0
    while true do
        local marker = self.tone_markers[t]
        -- break on reaching the first index error (ignore 0 because people
        -- might not use it for a given scheme)
        if t > 0 and marker == nil then break end

        -- try to match the tone digit after a letter in the input string
        local needle = string.format('[%%w]%d', t)
        local match = string.match(instring, needle)
        -- ü has to be matched separately because it being 2 bytes long
        -- confuses the matching function if used together with the others
        match = match or string.match(instring, "ü"..t)
        -- if matched and tone is not unmarked
        if match and marker then
            -- get the letter which will carry the tone marker
            local carrier = match:sub(1, -2)

            -- for i and j, use dotless version instead to make way for the
            -- diacritic
            if carrier == "i" then
                carrier = "\\i"
            elseif carrier == "j" then
                carrier = "\\j"
            end

            -- wrap the letter in the appropriate LaTeX macro
            local rep = string.format("\\%s{%s}", marker, carrier)

            return instring:gsub(match, rep)
        -- if matched and unmarked
        elseif match and not marker then
            -- just delete the tone number
            return instring:gsub(tostring(t), "")
        end

        -- increase control variable for next iteration
        t = t + 1
    end

    return instring
end

local is_title_case = function(self, str)
    --[[
        Receives a string, tests if it's title case and returns the result as a
        boolean.

        Title case means that the first (true = non-special character) letter is
        upper case and all following ones are lower case.
    --]]
    -- pattern matches any string consisting of
    --      - any number of non-letter characters (%A) followed by
    --      - a single uppercase character (%u) and
    --      - any number of characters which are not uppercase characters (%U)
    --  If the input string is title case, this pattern should match the entire
    --  string
    return str:match("%A*%u%U*") == str
end

local find_non_command = function(self, char, haystack)
    --[[
        Find the first occurrence of char within haystack (only works for single
        characters!) and returns its index. Returns 0 if char is not found.
    --]]
    local outindex = 0
    local within_command_name = false
    for i = 1, #haystack do
        local c = haystack:sub(i,i)
        if c:match("\\") then
            within_command_name = true
            goto continue -- go to tag named continue at the end of the loop
        end

        if within_command_name then
            if c:match("%A") ~= nil then
                within_command_name = false
            else
            end
        else
            if c:match(char) ~= nil then
                return i
            end
        end
        ::continue::
    end

    return i
end

local match_case = function(self, needle, replacement, match)
    --[[
        Determines an appropriate casing for the replacement for match and
        returns it. If the original needle contains at least one uppercase
        letter, the replacement is case-sensitive. Otherwise it is
        case-insensitive and the casing in haystack is preserved.
    --]]
    if needle ~= needle:lower() then
        return replacement
    else
        -- test for all lower case
        if match == match:lower() then
            -- replacement is already correct, so do nothing

        -- test for title case (first letter upper, rest lower)
        elseif self:is_title_case(match) then
            -- get the first lowercase character in the replacement but exclude
            -- command names from search
            local true_first_char_i = self:find_non_command("%w", replacement)

            local head = replacement:sub(0, true_first_char_i-1)
            local capitalised = replacement:sub(true_first_char_i, true_first_char_i):upper()
            local tail = replacement:sub(true_first_char_i+1)
            -- Since we already know replacement to be all lower case, there is
            -- no need to call lower() on the tail
            replacement = head..capitalised..tail

        -- test for all upper case *after* title case because otherwise
        -- a single uppercase input character going to multiple output
        -- characters would always return all uppercase. That is usually
        -- not what we want
        elseif match == match:upper() then
            -- turn to upper case but protect LaTeX command name
            replacement = self.__protected_upper_case(replacement)

        -- if none of these matched, assume we want all lower case
        else
            replacement = replacement:lower()
        end

        return replacement
    end
end

local find_case_insensitive = function(self, haystack, needle)
    return haystack:lower():find(needle:lower())
end

local escape_special_characters = function(self, input)
    -- local inp = "a%-b"
    local output = input:gsub("([%%%-.%^])", "%%%1")
    return output
end

local do_str_rep = function(self, instring, rep_dict)
    --[[
        Do the appropriate string replacements according to the passed
        replacement dictionary. E.g. Tâi-lô "ts" becoming "ch" in POJ.

        TODO: Can this be optimised so it doesn't have to loop over the
        whole thing?
    --]]
    for _, rep_pair in pairs(rep_dict) do
        local orig = rep_pair[1]
        local rep = rep_pair[2]

        local check_from_index = 0
        local failsafe = 0 -- guard against infinite loops

        while instring:lower():find(orig:lower(), check_from_index) do
            local remaining_string = instring:sub(check_from_index)
            local st, en, groupi, groupii = self:find_case_insensitive(remaining_string, orig)
            -- put empty strings in capture groups if nothing was captured
            local groupi = groupi or ""
            local groupii = groupii or ""
            -- update start and end indexes according to lengths of the group
            st = st + groupi:len()
            en = en - groupii:len()

            local match = remaining_string:sub(st, en)
            -- escape special characters so string comparison and substitution
            -- works correctly
            local match_to_compare = self:escape_special_characters(match)

            local replacement = "" -- initialise empty because we need it later

            -- perform replacements only if either 1) the needle is all
            -- lower-case (signalling case-insensitive search), or 2) the needle
            -- matches the found string exactly, including cases
            local matching_case_insensitively = orig == orig:lower()
            local is_exact_match = orig == match_to_compare
            if matching_case_insensitively or is_exact_match then
                replacement = self:match_case(orig, rep, match)

                local needle = self:escape_special_characters(match)
                instring = instring:gsub(needle, replacement, 1)
            end

            -- update starting index for the check so the next search starts
            -- from the END of the previous one
            check_from_index = check_from_index + st + replacement:len()

            -- update failsafe loopguard
            failsafe = failsafe + 1
            if failsafe > 10 then
                break
            end
        end
    end

    return instring
end

local join_sbs = function(self, sbs)
    --[[
        Receives a list of syllables in target scheme and joins them together
        to a valid output string.
        TODO
    --]]

    --[[
        for each syllable do the following tests:
        a) Is it the first one?
        b) Does it start with a non-alphanumeric character ≠ the separator?
        If either of these is true, leave sb as it is. Otherwise add the
        separator to the front.
        Then add sb to the output table.
    --]]
    for i, sb in ipairs(sbs) do
        if not (i == 1
            or sb == "" -- LuaTeX for some reason sometimes adds "" at the end
            or sb:match("^%W")
            and sb:match("^%W") ~= self.sb_sep
            and sb:match("^%W") ~= "\\") then
                sbs[i] = self.sb_sep..sb
        end
    end

    return table.concat(sbs)
end

local place_tone_digit = function(self, sb, tone)
    --[[
        Receive a syllable with the tone number at the end and return it with
        the number moved behind the letter that is going to carry the
        diacritic.
    --]]
    return sb..tostring(tone)
end

local to_target_scheme = function(self, sb)
    --[[
        Takes a SINGLE SYLLABLE in raw scheme and converts it to target
        scheme of the converter.
    --]]

    -- separate tone and syllable proper
    sb, tone = self.raw:get_sb_and_tone(sb)

    sb = self.do_str_rep(self, sb, self.rep_strings)
    if tone ~= nil then
        sb = self.place_tone_digit(self, sb, tone)
    end
    -- secondary replacements that depend on the digit being in the
    -- right place already
    sb = self.do_str_rep(self, sb, self.second_rep_strings)

    -- convert numbers to diacritics if wanted, otherwise delete
    -- digits
    if not self.no_tones then
        sb = self.add_tone_marker(self, sb)
    end

    return sb
end

local convert = function(self, instring)
    --[[
        Use splitting function to split input strings into syllables.  For
        each syllable, check cache if it has been converted before. If not,
        delegate computation to actual conversion function. Either way, join
        the outputs back together and return.
    --]]

    -- split input into sbs
    local sbs = self.raw:split_sbs(instring)

    local outsbs = {}

    for _, sb in ipairs(sbs) do
        -- Do replacements only on syllables that are valid in raw scheme
        if self.raw:is_valid_sb(sb) then
            if self.cache[sb] == nil then
                self.cache[sb] = self.to_target_scheme(self, sb)
            end
            table.insert(outsbs, self.cache[sb])
        else
            table.insert(outsbs, sb)

        end

    end

    return self.join_sbs(self, outsbs)
end

local __tostring = function(self)
    return self.name
end

local __protected_upper_case = function(instr)
    -- find all command names in input and store them in an array (including the
    -- backslash)
    local command_names = {}
    for c in instr:gmatch("\\%S[%[{%s]") do
        table.insert(command_names, c)
    end

    local outstr = instr:upper()

    -- loop over array of stored commands and replace the uppercased names in
    -- the outstr
    for _, c in ipairs(command_names) do
        outstr = outstr:gsub(c:upper(), c)
    end
    return outstr
end

local Converter = {
    -- converter prototype object
    name = "",
    raw = Raw, -- associate prototype raw scheme as default
    cache = {}, -- cache conversion results for better performance
    no_tones = false, -- set true to omit tone markers from output
    rep_strings = {},
    second_rep_strings = {}, -- for secondary replacement after number movement
    sb_sep = "",
    tone_markers = {
         -- list all tones as integer keys with their appropriate latex macro
         -- name (without the backslash). Unmarked tones should be set false.
        },

    -- functions
    new = new,
    add_tone_marker = add_tone_marker,
    convert = convert,
    do_str_rep = do_str_rep,
    escape_special_characters = escape_special_characters,
    find_case_insensitive = find_case_insensitive,
    find_non_command = find_non_command,
    is_title_case = is_title_case,
    join_sbs = join_sbs,
    match_case = match_case,
    place_tone_digit = place_tone_digit,
    to_target_scheme = to_target_scheme,
    __tostring = __tostring,
    __protected_upper_case = __protected_upper_case,
}

return Converter
