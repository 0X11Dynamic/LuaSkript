-- ast generator.lua
local str = [[
set {var} to 1
set {var2} to "var two$&@;)382"
set {var3} to 1 + 2 + var 
set {var4} to 2 * 3 - 4 / 5 + var ^ 2 % 7
set {tablevar::*} to {1,2,"3",{"m", "n", doublevar},8, var}

set function "testfunc" with args (a,b,c) to run {
    set {innerVar} to 42
    set {innerVar2} to innerVar + 8
    set {tablevar2::*} to {1,2,"3",{"m", "n", doublevar},8, var}
    set {FUNCVAR} to {a}
}

call "testfunc" with args ()


]]

local varnames = {}


-- dump table function
-- Output logging
local function dumpTable(t, indent)
    indent = indent or 0
    local indentation = string.rep("  ", indent)
    if type(t) ~= "table" then
        print(indentation .. tostring(t))
        return
    end

    print(indentation .. "{")
    for key, value in pairs(t) do
        local formattedKey = type(key) == "string" and "[\"" .. tostring(key) .. "\"]" or "[" .. tostring(key) .. "]"
        if type(value) == "table" then
            print(indentation .. "  " .. formattedKey .. " = ")
            dumpTable(value, indent + 1)
        else
            print(indentation .. "  " .. formattedKey .. " = " .. tostring(value) .. ",")
        end
    end
    print(indentation .. "},")
end

-- table.find implementation
-- Add a custom find function to the global table library
function table.find(tbl, value)
    for index, v in ipairs(tbl) do
        if v == value then
            return index
        end
    end
    return nil -- Return nil if the value is not found
end

-- Function to parse table values
local function parseTable(varvalue)
    local values = {}
    while #varvalue > 0 do
        if varvalue:sub(1, 1) == "{" then
            local brace_count = 1
            local i = 2
            while brace_count > 0 and i <= #varvalue do
                if varvalue:sub(i, i) == "{" then
                    brace_count = brace_count + 1
                elseif varvalue:sub(i, i) == "}" then
                    brace_count = brace_count - 1
                end
                i = i + 1
            end
            local nested_table_str = varvalue:sub(2, i - 2)
            table.insert(values, parseTable(nested_table_str))
            varvalue = varvalue:sub(i + 1):match("^%s*(.-)%s*$")
        else
            local next_comma = varvalue:find(",") or (#varvalue + 1)
            local i = varvalue:sub(1, next_comma - 1):match("^%s*(.-)%s*$")
            if tonumber(i) then
                table.insert(values, tonumber(i))
            elseif (i:sub(1, 1) == '"' and i:sub(-1) == '"') or (i:sub(1, 1) == "'" and i:sub(-1) == "'") then
                table.insert(values, i)
            else
                table.insert(values, {
                    ["OPCODE"] = "\"GETVAR\"",
                    ["Variable"] = "\"" .. i .. "\""
                })
            end
            varvalue = varvalue:sub(next_comma + 1):match("^%s*(.-)%s*$")
        end
    end
    return values
end

-- Function to parse math equations
local function parseEquation(equation)
    local elements = {}
    local pattern = "[^%s%+%-%*/%^%%]+"
    
    for token in equation:gmatch(pattern) do
        if tonumber(token) then
            table.insert(elements, tonumber(token))
        elseif token:match("^[a-zA-Z_][a-zA-Z0-9_]*$") then
            table.insert(elements, {
                ["OPCODE"] = "\"GETVAR\"",
                ["Variable"] = "\"" .. token .. "\""
            })
        else
            table.insert(elements, "\"" .. token .. "\"")
        end
    end

    local operators = {}
    for op in equation:gmatch("[%+%-%*/%^%%]") do
        table.insert(operators, "\"" .. op .. "\"")
    end

    local result = {}
    for i = 1, #elements do
        table.insert(result, elements[i])
        if operators[i] then
            table.insert(result, operators[i])
        end
    end

    return result
end

-- parse functions
function parseCode(code)
    local nodes = {}

    for line in code:gmatch("[^\r\n]+") do
        if line:gsub(" ", ""):sub(1, 3) == "set" then
            if line:find("[ \b\t]+set function") then
                local funcname = line:match("function [\"'][0-9\"'a-zA-Z {},-/:;()$&@.?!\\%[%]#%%%^%*%+=_~|<>%.,?!%*]+[\"']")
                    funcname = funcname:sub(11, #funcname-1)
                    local funcargs = line:match("with args *%((.-)%)")
                    for match in funcargs:gmatch("([^,]+)") do
                        table.insert(varnames, match)
                    end
                    local body = str:match("set function ['\"]" .. funcname .. "['\"] with args %([^)]*%) to run {(.*)}")
                    body = parseCode(body)
        
                    table.insert(nodes, {
                        ["OPCODE"] = "\"SETFUNC\"",
                        ["Variable"] = ("\"" .. funcname .. "\""):gsub(" ", ""),
                        ["Args"] = parseTable(funcargs),
                        ["Body"] = body
                    })
            else
                local varname
                line:gsub("set {[a-zA-Z_0-9:%*]+}", function(arg)
                    varname = arg:gsub("set {", ""):gsub("}", "")
                    return arg
                end)

                local startpos, endpos = string.find(line, "to [0-9\"'a-zA-Z {},-/:;()$&@.?!\\%[%]#%%%^%*%+=_~|<>%.,?!%*]+")
                local varvalue = line:sub(startpos + 3, endpos)

                if varvalue:sub(1,1) == "{" then
                    --print("TABLE!")
                    --local MaybeVarName = varvalue:sub(2,#varvalue)
                    --MaybeVarName = MaybeVarName:sub(1, #MaybeVarName-1)

                    varvalue = varvalue:sub(2, -2)
                    local values = parseTable(varvalue)

                    --if table.find(varnames, MaybeVarName) then
                    --    table.insert(nodes, {
                    --        ["OPCODE"] = "\"GETVAR\"",
                    --        ["Variable"] = "\"" .. MaybeVarName .. "\""
                    --    })
                    --else
                        table.insert(nodes, {
                            ["OPCODE"] = "\"MAKETBL\"",
                            ["Variable"] = ("\"" .. varname .. "\""):gsub(" ", ""),
                            ["Value"] = values
                        })
                    --end
                    
                elseif varvalue:find("[%+%-%*/%^%%]") then
                    local values = parseEquation(varvalue)
                    table.insert(nodes, {
                        ["OPCODE"] = "\"SETEQUATION\"",
                        ["Variable"] = ("\"" .. varname .. "\""):gsub(" ", ""),
                        ["Values"] = values
                    })
                else
                    if varvalue:sub(1, 1) == "\"" or varvalue:sub(1, 1) == "'" or tonumber(varvalue) then
                        table.insert(nodes, {
                            ["OPCODE"] = "\"SETVAR\"",
                            ["Variable"] = ("\"" .. varname .. "\""):gsub(" ", ""),
                            ["Value"] = varvalue
                        })
                    end
                end    
            end
        elseif line:find("[ \b\t]+call ") then
            local funcname = line:match("call ['\"][a-zA-Z0-9_]+['\"]")
            funcname = funcname:sub(7, #funcname-1)
            local args = line:match("with args %([0-9\"'a-zA-Z {},-/:;()$&@.?!\\%[%]#%%%^%*%+=_~|<>%.,?!%*]+")
            args = args:sub(12, #args-1)
            args = parseTable(args)

            table.insert(nodes, {
                ["OPCODE"] = "\"CALL\"",
                ["Variable"] = ("\"" .. funcname .. "\""):gsub(" ", ""),
                ["Value"] = args
            })
        end
    end
    return nodes
end

-- main code parser

    local tree = {}
    for line in str:gmatch("[^\r\n]+") do
        -- set variables, tables
        if line:sub(1, 3) == "set" then
            if line:sub(1, 12) == "set function" then
                local funcname = line:match("function [\"'][0-9\"'a-zA-Z {},-/:;()$&@.?!\\%[%]#%%%^%*%+=_~|<>%.,?!%*]+[\"']")
                funcname = funcname:sub(11, #funcname-1)
                local funcargs = line:match("with args *%((.-)%)")
                for match in funcargs:gmatch("([^,]+)") do
                    table.insert(varnames, match)
                end

                local body = str:match("set function ['\"]" .. funcname .. "['\"] with args %([^)]*%) to run {(.*)}")
                body = parseCode(body)

                table.insert(tree, {
                    ["OPCODE"] = "\"SETFUNC\"",
                    ["Variable"] = ("\"" .. funcname .. "\""):gsub(" ", ""),
                    ["Args"] = parseTable(funcargs),
                    ["Body"] = body
                })
            else
                local varname
                line:gsub(" [a-zA-Z0-9_{}:%*]+ ", function(arg)
                    varname = arg:gsub("{", ""):gsub("}", "")
                    return arg
                end)

                local startpos, endpos = string.find(line, "to [0-9\"'a-zA-Z {},-/:;()$&@.?!\\%[%]#%%%^%*%+=_~|<>%.,?!%*]+")
                local varvalue = line:sub(startpos + 3, endpos)

                table.insert(varnames, varname)
                
                if varvalue:sub(1, 1) == "{" then
                    print("TABLE!")
                    varvalue = varvalue:sub(2, -2)
                    local values = parseTable(varvalue)
                    table.insert(tree, {
                        ["OPCODE"] = "\"MAKETBL\"",
                        ["Variable"] = ("\"" .. varname .. "\""):gsub(" ", ""),
                        ["Value"] = values
                    })
                elseif varvalue:find("[%+%-%*/%^%%]") then
                    local values = parseEquation(varvalue)
                    table.insert(tree, {
                        ["OPCODE"] = "\"SETEQUATION\"",
                        ["Variable"] = ("\"" .. varname .. "\""):gsub(" ", ""),
                        ["Values"] = values
                    })
                else
                    if varvalue:sub(1, 1) == "\"" or varvalue:sub(1, 1) == "'" or tonumber(varvalue) then
                        table.insert(tree, {
                            ["OPCODE"] = "\"SETVAR\"",
                            ["Variable"] = ("\"" .. varname .. "\""):gsub(" ", ""),
                            ["Value"] = varvalue
                        })
                    end
                end
            end
        elseif line:sub(1, 4) == "call" then
            local funcname = line:match("call ['\"][a-zA-Z0-9_]+['\"]")
            funcname = funcname:sub(7, #funcname-1)
            local args = line:match("with args %([0-9\"'a-zA-Z {},-/:;()$&@.?!\\%[%]#%%%^%*%+=_~|<>%.,?!%*]+")
            args = args:sub(12, #args-1)
            args = parseTable(args)

            table.insert(tree, {
                ["OPCODE"] = "\"CALL\"",
                ["Variable"] = ("\"" .. funcname .. "\""):gsub(" ", ""),
                ["Value"] = args
            })
        end
    end

-- Call the parseCode function on the top-level code

print("---OUTPUT:---")
dumpTable(tree)
