#!/usr/bin/env lua5.3

local function to_target_scheme(self, instring)
    -- insert ' at the end of the string, so the end of a string-final syllable
    -- doesn't have to be a separate case. The ' is deleted during replacements
    return self.do_str_rep(self, instring.."\'", self.rep_strings)
end

local Revised = Converter:new{
    name = "kor.revised",
    raw = require(transconv.path_of(...)..".raw"),

    rep_strings = {
        -- level out unsupported vowel length and arae-a
        {"=", ""}, {"v", "a"},

        -- insert ' at the end of word-final syllables for easier processing
        {" ", "\' "}, {"%.", "\'."}, {"%?", "\'?"}, {"!", "\'!"},
        {")", "\')"}, {"%-", "\'-"},

        -- always use r for initial rieul
        {"la", "ra"}, {"le", "re"}, {"li", "ri"}, {"lo", "ro"}, {"lu", "ru"},
        -- always use

        -- insert marker at the end of syllables which are followed by
        -- vowel-initial syllables
        {"\'a", "x\'a"}, {"\'e", "x\'e"}, {"\'i", "x\'i"},
        {"\'o", "x\'o"}, {"\'u", "x\'u"}, {"\'y", "x\'y"},
        {"\'w", "x\'w"},
        {"\'%-a", "x\'-a"}, {"\'%-e", "x\'-e"}, {"\'%-i", "x\'-i"},
        {"\'%-o", "x\'-o"}, {"\'%-u", "x\'-u"}, {"\'%-y", "x\'-y"},
        {"\'%-w", "x\'-w"},


        {"ng", "ŋ"}, -- for easier processing

        -- hieut-assimilations (including nh and lh)
        {"g\'h", "k\'h"}, {"h\'g", "\'k"}, {"h\'k", "\'k"},
        {"d\'h", "t\'h"}, {"h\'d", "\'t"}, {"h\'t", "\'t"},
        {"b\'h", "p\'h"}, {"h\'b", "\'p"}, {"h\'p", "\'p"},
        {"j\'h", "ch\'"}, {"h\'j", "\'ch"}, {"h\'ch", "\'ch"},
        {"g\'%-h", "k\'-h"}, {"h\'%-g", "\'-k"}, {"h\'%-k", "\'-k"},
        {"d\'%-h", "t\'-h"}, {"h\'%-d", "\'-t"}, {"h\'%-t", "\'-t"},
        {"b\'%-h", "p\'-h"}, {"h\'%-b", "\'-p"}, {"h\'%-p", "\'-p"},
        {"j\'%-h", "ch\'-"}, {"h\'%-j", "\'-ch"}, {"h\'%-ch", "\'-ch"},

        -- syllable-final (not before vowel)
        {"gg\'", "k\'"}, {"kk\'", "k\'"}, {"g\'", "k\'"},
        {"dd\'", "t\'"}, {"ss\'", "t\'"}, {"jj\'", "t\'"}, {"tt\'", "t\'"},
        {"d\'", "t\'"}, {"s\'", "t\'"}, {"j\'", "t\'"}, {"t\'", "t\'"},
        {"ch\'", "t\'"},
        {"r\'", "l\'"},
        {"bb\'", "p\'"}, {"pp\'", "p\'"}, {"b\'", "p\'"},
        {"h\'", "t\'"},
        -- double consonants
        {"gs\'", "k\'"}, {"rg\'", "k\'"}, {"lg\'", "k\'"},
        {"nj\'", "n\'"},
        {"lb\'", "l\'"}, {"ls\'", "l\'"}, {"lt\'", "l\'"},
        {"bs\'", "p\'"}, {"lp\'", "p\'"},
        {"lm\'", "m\'"},

        -- syllable-finals (before vowel)
        {"gsx", "ksx"}, {"rg", "lgx"}, {"nhx", "nx"},
        {"lhx", "rx"}, {"rhx", "rx"},
        {"cx", "chx"}, -- repair final ch before vowels

        -- TODO: palatalisation of digeut and ti-eut
        {"dx\'i", "jx\'i"}, {"dx\'%-i", "jx\'-i"},
        {"tx\'i", "chx\'i"}, {"tx\'%-i", "chx\'-i"},

        -- get rid of helping characters
        {"ŋ", "ng"},
        -- insert - before syllable-initial vowels (but pay attention not to
        -- produce any double hyphens -- or delete any that the user entered)
        {"x\'", "-x"}, {"%-x%-", "-"},
        {"x", ""}, {"\'", ""},

        -- assimilations
        {"kn", "ngn"}, {"kr", "ngn"}, {"km", "ngm"},
        {"tn", "nn"}, {"tr", "nn"}, {"tm", "nm"},
        {"pn", "mn"}, {"pr", "mn"}, {"pm", "mm"},
        {"lr", "ll"}, {"ln", "ll"}, {"nl", "ll"},
    },

    -- -- functions
    to_target_scheme = to_target_scheme,
    convert = convert,
}

return Revised
