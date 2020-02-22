#!/usr/bin/env lua5.3

local function to_target_scheme(self, instring)
    return self.do_str_rep(self, instring, self.rep_strings)
end

local Revised = Converter:new{
    raw = require(transconv.path_of(...)..".raw"),

    rep_strings = {
        -- level out unsupported vowel length and arae-a
        {"=", ""}, {"v", "a"},

        -- distinguish word-internal initial i-eung both from other consonants
        -- and from morpheme breaks with following consonant
        {"[\'-]a", "-a"}, {"[\'-]e", "-e"}, {"[\'-]i", "-i"},
        {"[\'-]o", "-o"}, {"[\'-]u", "-u"}, {"[\'-]y", "-y"},
        {"[\'-]w", "-w"},

        -- TODO: palatalisation of digeut and ti-eut
        {"d=i", "j=i"}, {"t=i", "ch=i"},

        -- use pronunciation of finals but preserve before vowels
        {"g$", "k"}, {"d\'", "t\'"}, {"b\'", "p\'"}, {"j\'", "t\'"},
        {"kk\'", "k\'"}, {"tt\'", "t\'"}, {"pp\'", "p\'"}, {"ss\'", "t\'"},
        {"r\'", "l\'"}, {"s\'", "t\'"}, {"jj\'", "t\'"}, {"ch\'", "t\'"},
        -- hi-eut
        {"h\'g", "k\'"}, {"h\'d", "t\'"}, {"h\'b", "p\'"}, {"h\'", "t\'"},

        -- double consonants
        {"gs\'", "k\'"}, {"rg\'", "k\'"}, {"lg\'", "k\'"},
        {"nj\'", "n\'"}, {"nh\'", "n\'"},
        {"lb\'", "l\'"}, {"ls\'", "l\'"}, {"lt\'", "l\'"}, {"lh\'", "l\'"},
        {"bs\'", "p\'"}, {"lp\'", "p\'"},
        {"lm\'", "m\'"},
        -- TODO: only preserve consonant before morpheme break if vowel follows

        -- delete deviding apostrophe
        {"\'", ""},

        -- assimilations
        {"kn", "ngn"}, {"kr", "ngn"}, {"km", "ngm"}, {"kh", "kh"},
        {"tn", "nn"}, {"tr", "nn"}, {"tm", "nm"}, {"th", "th"},
        {"pn", "mn"}, {"pr", "mn"}, {"pm", "mm"}, {"ph", "ph"},
        {"lr", "ll"}, {"ln", "ll"}, {"nl", "ll"},

    },

    -- functions
    -- do_str_rep = do_str_rep,
    to_target_scheme = to_target_scheme,
    convert = convert,
}

return Revised
