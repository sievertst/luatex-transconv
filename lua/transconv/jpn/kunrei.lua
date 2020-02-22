#!/usr/bin/env lua5.3

local function to_target_scheme(self, instring)
    -- skip all the fancy stuff except string replacement
    return self.do_str_rep(self, instring, self.rep_strings)
end

local KunreiShiki = Converter:new{
    raw = require(transconv.path_of(...)..".raw"),

    rep_strings = {
        -- long vowels
        {"aa", "\\^{a}"}, {"uu", "\\^{u}"}, {"ee", "\\^{e}"}, {"oo", "\\^{o}"},
        {"ou", "\\^{o}"},
        -- vowels with ch\\^{o}onpu
        {"a=", "\\^{a}"}, {"i=", "\\^{\\i}"}, {"u=", "\\^{u}"}, {"e=", "\\^{e}"},
        {"o=", "\\^{o}"},
        -- delete separating hyphen between vowels that do not represent long
        -- vowels
        {"a%-a", "aa"}, {"e%-e", "ee"}, {"e%-i", "ei"}, {"u%-u", "uu"},
        {"o%-o", "oo"}, {"o%-u", "ou"},
        -- consonants
        {"di", "zi"}, {"du", "zu"},
        {"wi", "i"}, {"we", "e"},
        -- particles
        {"%-ha", "-wa"}, {"%-he", "-e"}, {"%-wo", "-o"},
    },

    to_target_scheme = to_target_scheme,
}

return KunreiShiki
