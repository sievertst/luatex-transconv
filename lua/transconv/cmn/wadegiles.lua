#!/usr/bin/env lua5.3

local WadeGiles = Converter:new{
    name = "cmn.wadegiles",
    raw = require(transconv.path_of(...)..".raw"),
    sb_sep = "-",

    rep_strings = {
        {"v", "ü"},
        {"g([iü])", "j%1"}, {"k([iü])", "q%1"}, {"([^csz])h([iü])", "x%1"},
        {"([jqxy])u", "%1ü"},
        {"zi", "tz\\u{u}"}, {"ci", "tz\'\\u{u}"}, {"si", "ssu"},
        {"z([^h])", "ts%1"}, {"c([^h])", "ts\'%1"},
        {"([csz]h)i$", "%1ih"},
        {"ch([^\'])", "ch\'%1"}, {"zh([^\'])", "ch%1"},
        {"j", "ch"}, {"q", "ch\'"}, {"x", "hs"},
        {"p([^\'])", "p\'%1"}, {"t([^\'s])", "t\'%1"}, {"k([^\'])", "k\'%1"},
        {"b", "p"}, {"d", "t"}, {"g", "k"},
        {"nk", "ng"}, -- repair "ng"
        {"ong", "ung"}, {"ej", "erh"},
        {"uo", "o"},
        {"k(\'?)o([^u])", "k%1uo%2"}, {"ho([^u])", "huo%1"},
        {"ke", "ko"}, {"k\'e", "k\'o"}, {"he", "ho"},
        {"([^{iyü])e", "%1\\^{e}"},
        {"cho([^u])", "ch\\^{e}"},
        {"([iyü])e$", "%1eh"},
        {"ian", "ien"},
        {"k(\'?)ui", "k%1uei"},
    },

    second_rep_strings = {
        {"([^{])([1-4])", "%1\\textsuperscript{%2}"}, {"(%w)[05]", "%1"},
    },

    -- functions
    add_tone_marker = add_tone_marker,
}

return WadeGiles
