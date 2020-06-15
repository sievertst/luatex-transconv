#!/usr/bin/env lua5.3

local TLPA = Converter:new{
    name = "nan.tlpa",
    raw = require(transconv.path_of(...)..".raw"),
    sb_sep = "-",

    tone_markers = {},
    rep_strings = {
        {"%-%-", "{-}{-}"}, -- prevent dash ligature for neutral tone marker
        {"ts", "c"}
    },
    second_rep_strings = {
        {"[^{](%d)", "\\textsuperscript{%1}"},
    },
}

return TLPA
