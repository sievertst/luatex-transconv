#!/usr/bin/env lua5.3

local main_dir = ...
if main_dir ~= "init" then
    main_dir = main_dir.."."
else
    main_dir = ""
end

local function path_of(path)
    --[[
        Returns the parent directory of a (dot-separated) path. E.g. "lib.foo"
        for the input "lib.foo.dir"
    --]]
    return path:match("^(.-)%.[^%.]+$")
end

local function new_converter(first, second, third)
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
        lang = main_dir..lang
    end

    local c = require(string.format("%s.%s", lang, scheme))

    return c:new(options)
end

-- function uselangs(str)
--     for l in str:gmatch("[^,]*") do
--         local fields = {}
--         l:gsub("(%w*)", function(a) table.insert(fields, a) end)
--         transconv[fields[2]] = transconv.new_converter(fields[1], fields[2])

--         tex.sprint("\\newcommand{\\"..fields[2].."convert}[1]{%")
--         tex.sprint("\\directlua{")
--         tex.sprint("transconv["..fields[2].."]:convert('#1'))}%")
--         tex.sprint("}")
--     end
-- end

transconv = {
    main_dir = main_dir,
    -- functions
    path_of = path_of,
    new_converter = new_converter,
    -- uselangs = uselangs,
}

return transconv
