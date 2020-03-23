#!/usr/bin/env lua5.3

local add_tone_marker = function(self, instring)
    local tone = tonumber(string.sub(instring,-1))
    local sb = string.sub(instring,1,-2) -- save syllable without tone number

    -- get tone number (including omitted unmarked tones)
    if tone then
        if tone >= 1 and tone <= 4 then -- returns nil if not a digit
            return string.format("%s\\textsuperscript{%d}", sb, tone)
        else
            return sb
        end
    else
        return instring
    end
end

local WadeGiles = Converter:new{
    name = "cmn.wadegiles",
    raw = require(transconv.path_of(...)..".raw"),
    sb_sep = "-",

    rep_strings = {
        {"v", "ü"},
        {"gi", "ji"}, {"ki", "qi"}, {"hi", "xi"},
        {"gü", "ju"}, {"kü", "qu"}, {"hü", "xu"},
        {"ju", "jü"}, {"qu", "qü"}, {"xu", "hsü"}, {"yu", "yü"},
        {"z", "ts"}, {"c", "ts\'"},
        {"tsi", "tz\\u{u}"}, {"ts\'i", "tz\'\\u{u}"}, {"si", "ssu"},
        {"ts\'h", "ch\'"}, {"tsh", "ch"}, -- repair retroflex affricates
        {"zxi", "chih"}, {"cxi", "ch\'ih"}, {"sxi", "shih"},
        {"j", "ch"}, {"q", "ch\'"}, {"x", "hs"},
        {"ri", "jih"}, {"r", "j"},
        {"p", "p\'"}, {"t", "t\'"}, {"k", "k\'"},
        {"t\'s", "ts"}, -- repair affricates
        {"b", "p"}, {"d", "t"}, {"g", "k"},
        {"nk", "ng"}, -- repair "ng"
        {"ong", "ung"}, {"ej", "erh"},
        {"uo", "o"},
        {"ko", "kuo"}, {"k\'o", "k\'uo"}, {"ho", "huo"},
        {"uou", "ou"}, -- repair cases such as zhou which would otherwise become chuou
        {"ke", "ko"}, {"k\'e", "k\'o"}, {"he", "ho"},
        {"e", "\\^{e}"},
        {"cho", "ch\\^{e}"}, {"ch\\^{e}u", "chou"},
        {"ü\\^{e}", "üeh"}, {"i\\^{e}", "ieh"},
        {"y\\^{e}", "yeh"}, {"yü\\^{e}", "yüeh"},
        {"ian", "ien"},
        {"kui", "kuei"}, {"k\'ui", "k\'uei"},
    },

    -- functions
    add_tone_marker = add_tone_marker,
}

return WadeGiles
