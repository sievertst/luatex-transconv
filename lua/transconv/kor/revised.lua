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
        {")", "\')"},

        -- always use r for initial rieul
        {"l([aeiouyw])", "r%1"},

        -- insert marker at the end of syllables which are followed by
        -- vowel-initial syllables
        {"([^v])([-\'][aeiouyw])", "%1v%2"},

        -- temporarily replace ng so we don't have to worry about excluding it
        -- when we handle final g
        {"ng", "ŋ"},

        -- ensure distinguishing n-g from ng
        {"n\'g", "n\'-g"},

        -- hieut-assimilations (including nh and lh)
        {"b([\'%-])h", "p%1h"}, {"d([\'%-])h", "t%1h"}, {"g([\'%-])h", "g%1h"},
        {"j([\'%-])h", "ch%1"},
        {"([ptk])([\'%-])h", "%1%2"},
        {"h([\'%-])[gk]", "%1k"}, {"h([\'%-])[dt]", "%1t"}, {"h([\'%-])[bp]", "%1p"},

        -- double consonants
        {"gs([\'%-])", "k%1"}, {"[rl]g([\'%-])", "k%1"},
        {"nj([\'%-])", "n%1"},
        {"l[bst]([\'%-])", "l%1"},-- {"ls([\'%-])", "l%1"}, {"lt([\'%-])", "l%1"},
        {"bs([\'%-])", "p%1"}, {"l([pm])([\'%-])", "%1%2"},
        -- syllable-final (not before vowel)
        {"gg([\'%-])", "k%1"}, {"kk([\'%-])", "k%1"}, {"g([\'%-])", "k%1"},
        {"dd([\'%-])", "t%1"}, {"ss([\'%-])", "t%1"}, {"jj([\'%-])", "t%1"},
        {"tt([\'%-])", "t%1"},
        {"[dsjh]([\'%-])", "t%1"}, {"ch([\'%-])", "t%1"},
        {"r([\'%-])", "l%1"},
        {"bb([\'%-])", "p%1"}, {"pp\'", "p%1"}, {"b\'", "p%1"},

        -- syllable-finals (before vowel)
        {"gsv", "ksv"}, {"rg", "lgv"}, {"([nr])hv", "%1v"},
        {"lhv", "rv"},

        -- palatalisation of digeut and ti-eut
        {"dv([\'%-])i", "jv%1i"}, {"tv([\'%-])i", "chv%1i"},

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
        {"k[nr]", "ngn"}, {"km", "ngm"},
        {"t[nr]", "nn"}, {"tm", "nm"},
        {"p[nr]", "mn"}, {"pm", "mm"},
        {"l[nr]", "ll"}, {"nl", "ll"},
    },

    -- -- functions
    to_target_scheme = to_target_scheme,
    convert = convert,
}

return Revised
