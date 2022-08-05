#!/usr/bin/env lua5.3

local function to_target_scheme(self, instring)
    -- skip all the fancy stuff except string replacement
    return self.do_str_rep(self, instring, self.rep_strings)
end

local KunreiShiki = Converter:new{
    name = "jpn.kunrei",
    raw = require(transconv.path_of(...)..".raw"),

    rep_strings = {
        -- long vowels
        {"aa", "\\^{a}"}, {"uu", "\\^{u}"}, {"ee", "\\^{e}"}, {"oo", "\\^{o}"},
        {"ou", "\\^{o}"},
        -- vowels with chōonpu
        {"([aeou])=", "\\^{%1}"},
        {"i=", "\\^{\\i}"}, -- use dotless i as a basis for diacritics
        -- delete separating hyphen between vowels that do not represent long
        -- vowels
        {"a%-a", "aa"}, {"e%-e", "ee"}, {"e%-i", "ei"}, {"u%-u", "uu"},
        {"o%-o", "oo"}, {"o%-u", "ou"},
        -- consonants
        {"d([iu])", "z%1"}, {"w([ei])", "%1"},
        -- particles
        {"%-ha", "-wa"}, {"%-he", "-e"}, {"%-wo", "-o"},
    },

    second_rep_strings = {
        {"{i}", "{\\i}"}, -- use dotless i with diacritics
    },

    to_target_scheme = to_target_scheme,
}

return KunreiShiki
