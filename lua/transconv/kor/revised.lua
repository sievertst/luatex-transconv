#!/usr/bin/env lua5.3

local function to_target_scheme(self, instring)
    return self.do_str_rep(self, instring, self.rep_strings)
end

local Revised = Converter:new{
    name = "kor.revised",
    raw = require(transconv.path_of(...)..".raw"),

    rep_strings = {
        -- level out unsupported vowel length and arae-a
        {"=", ""}, {"v", "a"},

        -- distinguish word-internal initial i-eung both from other consonants
        -- and from morpheme breaks with following consonant
        {"[\'-]a", "-a"}, {"[\'-]e", "-e"}, {"[\'-]i", "-i"},
        {"[\'-]o", "-o"}, {"[\'-]u", "-u"}, {"[\'-]y", "-y"},
        {"[\'-]w", "-w"},

        {"ng", "ŋ"}, -- for easier processing

        -- g
        {"g\'g", "kg"}, {"[ŋgk]\'[nlr]", "ngn"}, {"g\'d", "kd"},
        {"[gk]\'m", "ngm"}, {"g\'b", "kb"}, {"g\'s", "ks"}, {"g\'j", "kj"}, {"g\'c", "kc"},
        {"g\'k", "k-k"}, {"g\'t", "kt"}, {"g\'p", "kp"}, {"g\'h", "kh"},
        -- n
        {"n\'g", "n-g"}, {"n\'[lr]", "ll"},
        -- d
        {"[dsj]\'g", "tg"}, {"[dtsjh]\'[nlr]", "nn"}, {"[dsj]\'d", "td"},
        {"[dtsj]\'m", "nm"}, {"[dsj]\'b", "tb"}, {"[dsj]\'s", "ts"},
        {"[dsj]\'j", "tj"}, {"[dsjh]\'c", "tc"},
        {"[dsjh]\'k", "tk"}, {"[dsj]\'t", "t-t"}, {"[dsjh]\'p", "tp"}, {"[dsj]\'h", "th"},
        -- r/l
        {"r\'g", "lg"}, {"[lr]\'[nlr]", "ll"}, {"r\'d", "ld"},
        {"r\'m", "lm"}, {"r\'b", "lb"}, {"r\'s", "ls"}, {"r\'j", "lj"}, {"r\'c", "lc"},
        {"r\'k", "lk"}, {"r\'t", "lt"}, {"r\'p", "lp"}, {"r\'h", "lh"},
        -- m
        {"[bpm]\'[nlr]", "mn"},
        -- b
        {"b\'g", "pg"}, {"b\'d", "td"},
        {"[bp]\'m", "mm"}, {"b\'b", "pb"}, {"b\'s", "ps"}, {"b\'j", "pj"}, {"b\'c", "pc"},
        {"b\'k", "pk"}, {"b\'t", "pt"}, {"b\'p", "p-p"}, {"b\'h", "ph"},
        -- h
        {"h\'g", "k"}, {"h\'d", "t"}, {"h\'b", "p"}, {"h\'h", "t"},

        -- TODO: palatalisation of digeut and ti-eut

        -- use pronunciation of finals but preserve before vowels
        -- {"g\'", "k"}, {"d\'", "t\'"}, {"b\'", "p\'"}, {"j\'", "t\'"},

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
