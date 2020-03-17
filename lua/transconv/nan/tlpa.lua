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
    -- second_rep_strings = {
    --     {"(%d)", "\\textsuperscript{%1}"},
    -- },
    second_rep_strings = {
        {"1", "\\textsuperscript{1}"},{"2", "\\textsuperscript{2}"},{"3",
        "\\textsuperscript{3}"},{"4", "\\textsuperscript{4}"},{"5",
        "\\textsuperscript{5}"},{"6", "\\textsuperscript{6}"},{"7",
        "\\textsuperscript{7}"},{"8", "\\textsuperscript{8}"},{"9",
        "\\textsuperscript{9}"},{"0", "\\textsuperscript{0}"},
    },
}

return TLPA
