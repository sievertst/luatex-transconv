#!/usr/bin/env lua5.3

local function to_target_scheme(self, instring)
    -- skip all the fancy stuff except string replacement
    return self.do_str_rep(self, instring, self.rep_strings)
end

local Hepburn = Converter:new{
    name = "jpn.hepburn",
    raw = require(transconv.path_of(...)..".raw"),

    rep_strings = {
        -- consonants
        {"ti", "chi"}, {"[dz]i", "ji"}, {"si", "shi"},
        {"tu", "tsu"}, {"du", "zu"},
        {"ty", "ch"}, {"[dz]y", "j"}, {"sy", "sh"},
        -- long vowels
        {"aa", "\\={a}"}, {"uu", "\\={u}"}, {"ee", "\\={e}"}, {"oo", "\\={o}"},
        {"ou", "\\={o}"},
        -- vowels with ch\\={o}onpu
        {"([aeou])=", "\\={%1}"},
        {"i=", "\\={\\i}"}, -- use dotless i as a basis for diacritics
        -- delete separating hyphen between vowels that do not represent long
        -- vowels
        {"a%-a", "aa"}, {"e%-e", "ee"}, {"e%-i", "ei"}, {"u%-u", "uu"},
        {"o%-o", "oo"}, {"o%-u", "ou"},
        -- particles
        {"%-ha", "-wa"}, {"%-he", "-e"}, {"%-wo", "-o"},
    },

    -- functions
    to_target_scheme = to_target_scheme,
}

return Hepburn
