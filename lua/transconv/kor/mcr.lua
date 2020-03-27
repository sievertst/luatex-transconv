#!/usr/bin/env lua5.3

--[[
    The original version of McCune-Reischauer.
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
        {")", "\')"},

        -- always use r for initial rieul
        {"l([aeiouyw])", "r%1"},

        -- insert marker at the end of syllables which are followed by
        -- vowel-initial syllables
        {"([^v])([\'%-][aeiouyw])", "%1v%2"},
        -- also insert the marker at the beginning of syllables if the previous
        -- one is open or ends in a sonorant
        {"([aeiou][\'%-])[^v]", "%1v"},

        -- write e as ë after a and o (to distinguish ae and oe from a-e and o-e)
        {"([ao])v\'e", "%1\'\\\"{e}"},

        -- replace vowels
        {"eo", "\\u{o}"}, {"wo", "w\\u{o}"},
        {"eu", "\\u{u}"}, {"ui", "\\u{u}i"},

        -- temporarily replace ng so we don't have to worry about excluding it
        -- when we handle final g
        {"ng", "ŋ"},

        -- ensure distinguishing n'g from ng (x will become ' later)
        {"n\'vg", "n\'xvg"}, {"ŋv\'", "ŋvx\'"},

        -- insert marker after aspiratae (later we'll use ', but that is
        -- currently still used as a syllable separator)
        {"([ptk])([^x])", "%1x%2"}, {"pxpx", "pp"}, {"txtx", "tt"}, {"kxkx", "kk"},
        {"ch([^x])", "chx%1"},

        -- write tenuis consonants as voiceless, except between sonorants
        {"g", "k"}, {"kv", "gv"}, {"vk", "vg"},
        {"d", "t"}, {"tv", "dv"}, {"vt", "vd"},
        {"b", "p"}, {"pv", "bv"}, {"vp", "vb"},
        {"j", "ch"}, {"chv", "jv"},  {"vch", "j"}, {"chch", "tch"},
        -- repair aspiratae
        {"gx", "kx"}, {"dx", "tx"}, {"bx", "px"}, {"jx", "chx"},

        -- hieut-assimilations (including nh and lh)
        {"g([\'%-])h", "k%1h"}, {"h([\'%-])[gk]", "%1k"},
        {"d([\'%-])h", "t%1h"}, {"h([\'%-])[dt]", "%1t"},
        {"b([\'%-])h", "p%1h"}, {"h([\'%-])[bp]", "%1p"},
        {"j([\'%-])h", "ch%1"}, {"h([\'%-])j", "%1ch"}, {"h([\'%-])ch", "%1ch"},
        {"cv", "chv"}, -- repair final ch before vowels

        -- syllable-final (not before vowel)
        {"gg([\'%-])", "k%1"}, {"kk([\'%-])", "k%1"}, {"g([\'%-])", "k%1"},
        {"dd([\'%-])", "t%1"}, {"ss([\'%-])", "t%1"}, {"jj([\'%-])", "t%1"}, {"tt([\'%-])", "t%1"},
        {"[dsjh]([\'%-])", "t%1"},
        {"ch([\'%-])", "t%1"},
        {"r([\'%-])", "l%1"},
        {"bb([\'%-])", "p%1"}, {"pp([\'%-])", "p%1"}, {"b([\'%-])", "p%1"},
        -- double consonants
        {"gs([\'%-])", "k%1"}, {"[lr]g([\'%-])", "k%1"},
        {"nj([\'%-])", "n%1"},
        {"l[bst]([\'%-])", "l%1"},
        {"bs([\'%-])", "p%1"}, {"l([pm])([\'%-])", "%1%2"},
        {"lm([\'%-])", "m%1"},

        {"l([\'%-])vh", "r%1h"},

        -- syllable-finals (before vowel)
        {"gsv", "ksv"}, {"rg", "lgv"}, {"nhv", "nv"},
        {"[lr]hv", "rv"},

        -- palatalisation of digeut and ti-eut
        {"dv([\'%-])i", "jv\'i"}, {"txv([\'%-])i", "chv\'i"},

        -- get rid of helping characters
        {"ŋ", "ng"},
        -- insert - before syllable-initial vowels (but pay attention not to
        -- produce any double hyphens (if there already was a dividing hyphen)
        -- or to accidentally delete any that the user entered
        {"v\'", "-v"},
        -- but no hyphen for w, y or ng between vowels
        {"%-vw", "w"}, {"%-vy", "y"}, {"ng%-v", "ng"},
        {"%-v%-", "-"},
        {"v", ""}, {"\'", ""}, {"x", "\'"},

        -- assimilations
        {"k[nr]", "ngn"}, {"t[nr]", "nn"}, {"p[nr]", "mn"},
        {"km", "ngm"}, {"tm", "nm"}, {"pm", "mm"},
        {"l[nr]", "ll"}, {"nl", "ll"},

        -- special
        {"swi", "shwi"},
    },

    -- -- functions
    to_target_scheme = to_target_scheme,
    convert = convert,
}

return Revised
