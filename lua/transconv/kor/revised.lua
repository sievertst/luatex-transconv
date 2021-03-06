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

        -- insert marker at the end of syllables which are followed by
        -- vowel-initial syllables
        {"\'a", "v\'a"}, {"\'e", "v\'e"}, {"\'i", "v\'i"},
        {"\'o", "v\'o"}, {"\'u", "v\'u"}, {"\'y", "v\'y"},
        {"\'w", "v\'w"},
        {"\'%-a", "v\'-a"}, {"\'%-e", "v\'-e"}, {"\'%-i", "v\'-i"},
        {"\'%-o", "v\'-o"}, {"\'%-u", "v\'-u"}, {"\'%-y", "v\'-y"},
        {"\'%-w", "v\'-w"},

        -- temporarily replace ng so we don't have to worry about excluding it
        -- when we handle final g
        {"ng", "ŋ"},

        -- ensure distinguishing n-g from ng
        {"n\'g", "n\'-g"},

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
        {"gsv", "ksv"}, {"rg", "lgv"}, {"nhv", "nv"},
        {"lhv", "rv"}, {"rhv", "rv"},
        {"cv", "chv"}, -- repair final ch before vowels

        -- palatalisation of digeut and ti-eut
        {"dv\'i", "jv\'i"}, {"dv\'%-i", "jv\'-i"},
        {"tv\'i", "chv\'i"}, {"tv\'%-i", "chv\'-i"},

        -- get rid of helping characters
        {"ŋ", "ng"},
        -- insert - before syllable-initial vowels (but pay attention not to
        -- produce any double hyphens (if there already was a dividing hyphen)
        -- or to accidentally delete any that the user entered
        {"v\'", "-v"},
        {"%-vw", "w"}, {"%-vy", "y"}, -- but no hyphen for w or y between vowels
        {"%-v%-", "-"},
        {"v", ""}, {"\'", ""},

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
