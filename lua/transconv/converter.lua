#!/usr/bin/env lua5.3

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

local do_str_rep = function(self, instring, rep_dict)
    --[[
        Do the appropriate string replacements according to the passed
        replacement dictionary. E.g. Tâi-lô "ts" becoming "ch" in POJ.

        TODO: Can this be optimised so it doesn't have to loop over the
        whole thing?
    --]]

    for _, rep_pair in pairs(rep_dict) do
        local lower_input = instring:lower()

        local orig = rep_pair[1]:lower()
        local rep = rep_pair[2]:lower()

        -- find starting index of match if there is one
        -- also capture groups (look behind and look ahead) if returned
        local failsafe = 0 -- guard against infinite loops
        local checked_to_index = 0
        while lower_input:find(orig, checked_to_index) do

            local st, en, groupi, groupii = lower_input:find(orig, checked_to_index)
            -- put empty strings if nothing was captured
            local groupi = groupi or ""
            local groupii = groupii or ""

            -- update start and end indexes according to lengths of the groups
            st = st + groupi:len()
            en = en - groupii:len()

            local match = instring:sub(st, en)
            texio.write_nl("Replacing: "..match.." with "..rep.." in "..instring.."\n")

            -- match case if the replacement string is all lower case
            if not rep == rep:lower() then
                -- test for all lower case
                if match == match:lower() then
                    rep = rep:lower()
                -- test for title case (first letter upper, rest lower)
                elseif match == match:sub(1,1):upper()..match:sub(2):lower() then
                    rep = rep:sub(1,1):upper()..rep:sub(2)
                -- test for all upper case *after* title case because otherwise
                -- a single uppercase input character going to multiple output
                -- characters would always return all uppercase. That is usually
                -- not what we want
                elseif match == match:upper() then
                    -- turn to upper case but protect LaTeX command name
                    rep = self.__protected_upper_case(rep)
                -- if none of these matched, assume we want all lower case
                else
                    rep = rep:lower()
                end
            end

            -- escape special characters in match string before substitution
            local match = instring:sub(st, en):gsub("([^%w])", "%%%1")
            local old_instring = instring
            instring = instring:gsub(match, rep)
            texio.write_nl("Result: "..instring.."\n")

            -- need to update both of these for the loop check
            lower_input = instring:lower()
            checked_to_index = st+rep:len()

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
    sb = self.place_tone_digit(self, sb, tone)
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
        print(c)
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
    join_sbs = join_sbs,
    place_tone_digit = place_tone_digit,
    to_target_scheme = to_target_scheme,
    __tostring = __tostring,
    __protected_upper_case = __protected_upper_case,
}

return Converter
