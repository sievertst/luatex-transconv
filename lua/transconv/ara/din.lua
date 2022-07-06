#!/usr/bin/env lua5.3

local function to_target_scheme(self, instring)
    -- skip all the fancy stuff except string replacement
    return self.do_str_rep(self, instring, self.rep_strings)
end

local DIN = Converter:new{
    name = "san.din",
    raw = require(transconv.path_of(...)..".raw"),

    rep_strings = {
        -- consonants
        -- -- al- + sun letters (capitalised)
        {"l%-Tt", "t-T"}, {"l%-Dd", "d-D"}, {"l%-Nn", "n-N"},
        {"l%-Rr", "r-R"}, {"l%-Ll", "l-L"}, {"l%-Ss", "s-S"},
        {"l%-_T_t", "_t-_T"}, {"l%-_D_d", "_d-_D"},
        {"l%-%.T%.t", ".t-.T"}, {"l%-%.D%.d", ".d-.D"},
        {"l%-%.S%.s", ".s-.S"}, {"l%-%.Z%.z", ".z-.Z"},
        {"l%-%^S%^s", "^s-^S"},
        {"l%-TT", "t-T"}, {"l%-DD", "d-D"}, {"l%-NN", "n-N"},
        {"l%-RR", "r-R"}, {"l%-LL", "l-L"}, {"l%-SS", "s-S"},
        {"l%-_T_T", "_t-_T"}, {"l%-_D_D", "_d-_D"},
        {"l%-%.T%.T", ".t-.T"}, {"l%-%.D%.D", ".d-.D"},
        {"l%-%.S%.S", ".s-.S"}, {"l%-%.Z%.Z", ".z-.Z"},
        {"l%-%^S%^S", "^s-^S"},
        -- al- + sun letters
        {"l%-tt", "t-t"}, {"l%-dd", "d-d"}, {"l%-nn", "n-n"},
        {"l%-rr", "r-r"}, {"l%-ll", "l-l"}, {"l%-ss", "s-s"},
        {"l%-_t_t", "_t-_t"}, {"l%-_d_d", "_d-_d"},
        {"l%-%.t%.t", ".t-.t"}, {"l%-%.d%.d", ".d-.d"},
        {"l%-%.s%.s", ".s-.s"}, {"l%-%.z%.z", ".z-.z"},
        {"l%-%^s%^s", "^s-^s"},
        -- emphatic consonants
        {"%.t", "\\d{t}"}, {"%.d", "\\d{d}"}, {"%.s", "\\d{s}"}, {"%.z", "\\d{z}"},
        -- other dotted
        {"%.h", "\\d{h}"}, {"%.d", "\\d{d}"}, {"%.g", "\\.{g}"},
        -- epiglottal
        {"`", "ʿ"}, {"_h", "ḫ"},
        -- other underlined
        {"_t", "\\b{t}"}, {"_d", "\\b{d}"},
        -- shiin and jiim
        {"%^s", "\\v{s}"}, {"%^g", "\\v{g}"},
        -- alif maqsurah and dagger alif
        {"_A", "aa"}, {"_a", "aa"},
        -- handle alif maddah first to preserve the hamzah sound
        {"\'aa", "ʾaa"},
        -- long vowels
        {"aa", "\\={a}"}, {"uu", "\\={u}"}, {"ii", "\\={i}"},
        -- delete initial hamzah and waslah
        {"([^a-zA-z}])\'([a-zA-z])", ""},
        -- hamzah
        {"\'", "ʾ"},
        -- tā' marbūṭah
        {"([a-zA-z])H", "h"}, {"([a-zA-z])T", "t"},
        -- nunation
        {"N([$%w])", "n"},
    },

    second_rep_strings = {
        {"{i}", "{\\i}"}, -- use dotless i with diacritics
    },

    -- functions
    to_target_scheme = to_target_scheme,
}

return DIN
