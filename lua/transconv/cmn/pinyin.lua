#!/usr/bin/env lua5.3

local function join_sbs(self, sbs)
    -- list of vowels before which an apostrophe needs to be inserted if they
    -- are not the first syllable in a word
    local vowels = {["a"]=true, ["e"]=true, ["o"]=true, ["\\={a}"]=true,
        ["\\={e}"]=true, ["\\={o}"]=true, ["\\\'{a}"]=true,
        ["\\\'{e}"]=true, ["\\\'{o}"]=true, ["\\v{a}"]=true,
        ["\\v{e}"]=true, ["\\v{o}"]=true, ["\\`{a}"]=true, ["\\`{e}"]=true,
        ["\\`{o}"]=true,
    }
    for i, sb in ipairs(sbs) do
        if i ~= 1 and vowels[sb:match("^%w")]
            or vowels[sb:match("^\\[v=\'`]{%w}")] then
            sbs[i] = "\'"..sb
        end
    end

    return table.concat(sbs, "")
end

local function place_tone_digit(self, sb, tone)
    -- For the digraph iu place digit behind the u (ui is caught by the vowel
    -- list later)
    if string.match(sb, "iu") then
        return sb:gsub("iu", string.format("iu%d", tone), 1)
    end

    -- check for letters in the order "a e o i u ng m" and place the digit
    -- behind the first one that is found
    local vowels = {
        "A", "a", "E", "e", "O", "o", "i", "u", "ü", "Ng", "NG", "M", "m",
    }
    for _, v in ipairs(vowels) do
        if string.match(sb, v) then
            -- put the number behind the first letter in the match
            local vhead = string.match(v, '^[aeioumnAEOMNü].*')
            local vtail = string.match(v, '^[aeioumnAEOMNü](.*)')
            local rep = string.format("%s%d%s", vhead, tone, vtail)
            return sb:gsub(v, rep, 1)
        end
    end

    -- return the result
    return sb
end

local Pinyin = Converter:new{
    name = "cmn.pinyin",
    raw = require(transconv.path_of(...)..".raw"),
    sb_sep = "",

    tone_markers = {
        -- unmarked tones should be set false
        [0] = false, [1] = "=", [2] = "\'", [3] = "v", [4] = "`", [5] = false,
    },
    rep_strings = {
        {"v", "ü"},
        {"gi", "ji"}, {"ki", "qi"}, {"hi", "xi"},
        {"gü", "ju"}, {"kü", "qu"}, {"hü", "xu"},
    },

    -- functions
    join_sbs = join_sbs,
    place_tone_digit = place_tone_digit,
}

return Pinyin
