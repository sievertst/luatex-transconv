#!/usr/bin/env lua5.3

local function join_sbs(self, sbs)
    local vowels = {["a"]=true, ["e"]=true, ["o"]=true, ["\\={a}"]=true,
        ["\\={e}"]=true, ["\\={o}"]=true, ["\\\'{a}"]=true,
        ["\\\'{e}"]=true, ["\\\'{o}"]=true, ["\\v{a}"]=true,
        ["\\v{e}"]=true, ["\\v{o}"]=true, ["\\`{a}"]=true, ["\\`{e}"]=true,
        ["\\`{o}"]=true, ["\\^{a}"]=true, ["\\^{e}"]=true, ["\\^{o}"]=true,
        ["\\H{a}"]=true, ["\\H{e}"]=true, ["\\H{o}"]=true, ["n"] = true,
    }
    for i, sb in ipairs(sbs) do
        if i > 1 and (vowels[sb:match("^%w")]
            or vowels[sb:match("^\\[v=\'`H%^]{%w}")]) then
            sbs[i] = "\'"..sb
        end
    end

    return table.concat(sbs, self.sb_sep)
end

local function place_tone_digit(self, sb, tone)
    local diphthongs = { "ui", "Ui", "iu", "Iu", "oo", "Oo",}
    for _, d in ipairs(diphthongs) do
        if string.match(sb, d) then
            return sb:gsub(d, string.format("%s%d", d, tone), 1)
        end
    end

    -- check for letters in the order "a e o i u ng m" and place the digit
    -- behind the first one that is found
    local vowels = {
        "A", "a", "E", "e", "O", "o", "I", "i", "U", "u", "Ng", "NG",
        "ng", "M", "m",
    }
    for _, v in ipairs(vowels) do
        if string.match(sb, v) then
            -- put the number behind the first letter in the match
            local vhead = string.sub(v,1,1)
            local vtail = string.sub(v,2)
            local rep = string.format("%s%d%s", vhead, tone, vtail)
            return sb:gsub(v, rep, 1)
        end
    end

    -- return the result
    return sb
end

local BP = Converter:new{
    name = "nan.bp",
    raw = require(transconv.path_of(...)..".raw"),

    sb_sep = "",

    tone_markers = {
        -- unmarked tones should be set false
        [0] = false, [1] = "=", [2] = "v", [3] = "`", [4] = "=",
        [5] = "\'", [6] = false, [7] = "^", [8] = "\'", [9] = "H",
    },

    rep_strings = {
        {"%-%-", "{-}{-}"}, -- prevent dash ligature for neutral tone marker
        {"[^b]b([^b])", "bb%1"}, {"^b([^b])", "bb%1"}, {"g([^g])", "gg%1"},
        {"ngg", "ng"}, -- repair "ng"
        {"([^aeiouln])n([^g])", "%1ln%2"}, {"m([^$])", "bbn%1"}, {"ng([^$])", "ggn%1"},
        {"^n([^g])", "ln%1"},
        -- vowels
        {"([aeiou][aeiou]?[aeiou]?)nn", "n%1"}, {"au", "ao"}, {"no(h?)$", "noo%1"},
        -- consonants
        {"tsh", "c"}, {"ts", "z"}, {"j", "zz"},
        {"p", "b"}, {"t", "d"}, {"k", "g"},
        {"b$", "p"}, {"d$", "t"}, {"([^n])g$", "%1k"}, -- repair final plosives
        {"bh", "p"}, {"dh", "t"}, {"gh", "k"},
        -- initial u --> w, i --> y
        {"^[^a-z]*i([aou])", "y%1"}, {"^[^a-z]*u([aei])", "w%1"},
        {"^[^a-z]*i([^aou]?)", "yi%1"}, {"^[^a-z]*u([^aei]?)", "wu%1"},
        {"^[^a-z]*ni([aou])", "yn%1"}, {"^[^a-z]*nu([aei])", "wn%1"},
        {"^[^a-z]*ni([^aou]?)", "yni%1"}, {"^[^a-z]*nu([^aei]?)", "wnu%1"},
    },
    second_rep_strings = {
        {"{i}", "{\\i}"}, -- use dotless i with diacritics
    },

    -- functions
    join_sbs = join_sbs,
    place_tone_digit = place_tone_digit,
}

return BP
