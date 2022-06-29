#!/usr/bin/env lua5.3

local function to_target_scheme(self, instring)
    -- skip all the fancy stuff except string replacement
    return self.do_str_rep(self, instring, self.rep_strings)
end

local Iast = Converter:new{
    name = "san.iast",
    raw = require(transconv.path_of(...)..".raw"),

    rep_strings = {
        -- consonants
        {"\"n", "\\.{n}"}, {"~n", "\\~{n}"},
        -- retroflex
        {"%.t", "\\d{t}"}, {"%.d", "\\d{d}"}, {"%.n", "\\d{n}"},
        -- sibilants
        {"\"s", "\\'{s}"}, {"%.s", "\\d{s}"},
        -- nuqta letters (_r is ambiguous with .r, _v => w is non-standard)
        {"_kh", "x"}, {"_k", "q"}, {"_g", "\\.{q}"}, {"_z", "z"},
        {"_r", "\\d{r}"}, {"_ph", "f"}, {"_v", "w"},
        -- long vowels (long e and o only in Dravidian)
        {"aa", "\\={a}"}, {"uu", "\\={u}"}, {"ii", "\\={i}"}, {"ee", "\\={e}"}, {"uu", "\\={o}"},
        -- long syllabic r and l
        {"%.ll", "\\d{\\={l}}"}, {"%.rr", "\\d{\\={r}}"},
        -- short syllabic r and l
        {"%.l", "\\d{l}"}, {"%.r", "\\d{r}"},
        -- anusvara, chandrabindu, visarga
        {"%.m", "\\d{m}"}, {"/", "\\.{\\u{m}}"}, {"%.h", "\\d{h}"},
        -- virama, avagraha
        {"&", ""}, {"%.a", "'"},

    },

    -- functions
    to_target_scheme = to_target_scheme,
}

return Iast
