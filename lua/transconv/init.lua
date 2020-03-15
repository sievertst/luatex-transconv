#!/usr/bin/env lua5.3
main_dir = ...
if main_dir ~= "init" then
    main_dir = main_dir.."."
else
    main_dir = ""
end

Raw = require(main_dir.."raw")

schemes = {}
default_schemes = {}

local function path_of(path)
    --[[
        Returns the parent directory of a (dot-separated) path. E.g. "lib.foo"
        for the input "lib.foo.dir"
    --]]
    return path:match("^(.-)%.[^%.]+$")
end

local function make_default_scheme(self, lang, scheme)
    --[[
        Moves scheme to the front of lang's list in default_languages. Returns
        integer code to reflect what was done:
            1: scheme moved to front
            0: scheme already default for lang (no changes done)
           -1: scheme currently does not exist for lang (error)
           -2: there is no scheme set up for lang at all (error)
    --]]

    local function move_element_to_front(list, old_i)
        if old_i <= 1 then
            return table
        end

        local l = {[1] = list[old_i]}

        for k,v in pairs(list) do
            if k ~= old_i then
                table.insert(l, v)
            end
        end

        return l
    end

    -- return error code if no scheme is set up for lang
    if self.default_schemes[lang] == nil then
        return -2
    end

    -- find scheme in default_schemes list for lang and get its index
    local index = 0
    for k,v in pairs(self.default_schemes[lang]) do
        if v == scheme then
            index = k
            break
        end
    end

    -- handle depending on if the scheme was found and at what index
    if index == 0 then
        -- index 0 means scheme was not found because Lua starts indexing at 1
        return -1
    elseif index == 1 then
        return 0
    else
        self.default_schemes[lang] = move_element_to_front(self.default_schemes[lang], index)
    end
end

local function new_converter(self, first, second, third)
    Converter = require(main_dir.."converter")
    Raw = require(main_dir.."raw")

    -- process options table if given (either in second or third argument)
    if type(second) == "table" then
        options = second
        second = nil
    else
        options = third or {}
    end

    -- if first input contains a dot surrounded by other characters, interpret
    -- it as a directory separator between language and scheme (second argument
    -- is discarded)
    local lang, scheme = first:match("^([^%.]-)%.(.-)$")

    -- if match failed, use first as directory and second as scheme names
    if not scheme then
        lang = first
        if type(second) == "string" then scheme = second else scheme = "" end
        options = third or {}
    end

    -- add main_directory information if invoked from outside
    if main_dir ~= "init" then
        lang_module = main_dir..lang
    else
        lang_module = lang
    end

    tex.sprint(string.format("Setting up converter: %s.%s", lang,scheme))

    local c = require(string.format("%s.%s", lang_module, scheme)):new(options)

    self.schemes[scheme] = c
    self.default_schemes[lang] = self.default_schemes[lang] or {}
    table.insert(self.default_schemes[lang], c)

    return c
end

transconv = {
    main_dir = main_dir,
    -- functions
    path_of = path_of,
    make_default_scheme = make_default_scheme,
    new_converter = new_converter,
    -- uselangs = uselangs,
    schemes = schemes,
    default_schemes = default_schemes,
}

return transconv
