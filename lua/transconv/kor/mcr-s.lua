#!/usr/bin/env lua5.3

--[[
    The variant of McCune-Reischauer used as the official transcription system
    in South Korea between 1984 and 2000.
--]]

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

        -- temporarily replace ng so we don't have to worry about excluding it
        -- when we handle final g
        {"ng", "ŋ"},

        -- insert marker at the end of syllables which are followed by
        -- vowel-initial syllables
        {"\'a", "v\'a"}, {"\'e", "v\'e"}, {"\'i", "v\'i"},
        {"\'o", "v\'o"}, {"\'u", "v\'u"}, {"\'y", "v\'y"},
        {"\'w", "v\'w"},
        {"\'%-a", "v\'-a"}, {"\'%-e", "v\'-e"}, {"\'%-i", "v\'-i"},
        {"\'%-o", "v\'-o"}, {"\'%-u", "v\'-u"}, {"\'%-y", "v\'-y"},
        {"\'%-w", "v\'-w"},
        -- also insert the marker at the beginning of syllables if the previous
        -- one is open or ends in a sonorant
        {"a\'", "a\'v"}, {"e\'", "e\'v"}, {"e\'", "e\'v"},
        {"i\'", "i\'v"}, {"o\'", "o\'v"}, {"m\'", "m\'v"},
        {"n\'", "n\'v"}, {"ŋ\'", "ŋ\'v"}, {"l\'", "l\'v"},

        -- replace vowels
        {"eo", "\\u{o}"},
        {"eu", "\\u{u}"}, {"ui", "\\u{u}i"},

        -- temporarily replace ng so we don't have to worry about excluding it
        -- when we handle final g
        {"ng", "ŋ"},

        -- ensure distinguishing n'g from double ieung
        {"n\'vg", "n-vg"}, {"ŋv\'", "ŋv-"},

        -- insert marker after aspiratae (later we'll use ', but that is
        -- currently still used as a syllable separator)
        {"k", "kx"}, {"kxkx", "kk"},
        {"t", "tx"}, {"txtx", "tt"},
        {"p", "px"}, {"pxpx", "pp"},
        {"ch", "chx"},

        -- hieut-assimilations (including nh and lh)
        {"g\'h", "\'kx"}, {"h\'g", "\'k"}, {"h\'k", "\'k"},
        {"d\'h", "\'tx"}, {"h\'d", "\'t"}, {"h\'t", "\'t"},
        {"b\'h", "\'px"}, {"h\'b", "\'p"}, {"h\'p", "\'p"},
        {"j\'h", "\'chx"}, {"h\'j", "\'ch"}, {"h\'ch", "\'ch"},
        {"g\'%-h", "k\'-h"}, {"h\'%-g", "\'-k"}, {"h\'%-k", "\'-k"},
        {"d\'%-h", "t\'-h"}, {"h\'%-d", "\'-t"}, {"h\'%-t", "\'-t"},
        {"b\'%-h", "p\'-h"}, {"h\'%-b", "\'-p"}, {"h\'%-p", "\'-p"},
        {"j\'%-h", "ch\'-"}, {"h\'%-j", "\'-ch"}, {"h\'%-ch", "\'-ch"},

        -- write tenuis consonants as voiceless, except between sonorants
        {"g", "k"}, {"kv", "gv"}, {"vk", "vg"},
        {"d", "t"}, {"tv", "dv"}, {"vt", "vd"},
        {"b", "p"}, {"pv", "bv"}, {"vp", "vb"},
        {"j", "ch"}, {"chv", "jv"},  {"vch", "j"}, {"chch", "tch"},
        -- repair aspiratae
        {"gx", "kx"}, {"dx", "tx"}, {"bx", "px"}, {"jx", "chx"},

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
        -- but no hyphen for w, y or ng between vowels
        {"%-vw", "w"}, {"%-vy", "y"}, {"ng%-v", "ng"},
        {"%-v%-", "-"},
        {"v", ""}, {"\'", ""},
        {"x", "\'"},

        -- assimilations
        {"kn", "ngn"}, {"kr", "ngn"}, {"km", "ngm"},
        {"tn", "nn"}, {"tr", "nn"}, {"tm", "nm"},
        {"pn", "mn"}, {"pr", "mn"}, {"pm", "mm"},
        {"lr", "ll"}, {"ln", "ll"}, {"nl", "ll"},

        -- special
        {"si", "shi"},
    },

    -- -- functions
    to_target_scheme = to_target_scheme,
    convert = convert,
}

return Revised
