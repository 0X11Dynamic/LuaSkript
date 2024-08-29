-- Function to read the content of a file
local function readFile(filename)
    local file, err = io.open(filename, "r")
    if not file then
        print("Error: Could not open file " .. filename .. " - " .. err)
        return nil
    end
    local content = file:read("*a")  -- Read the entire file content
    file:close()
    return content
end

-- Function to write data to a file
local function writeFile(filename, data)
    local file, err = io.open(filename, "w")  -- Open file in write mode
    if not file then
        print("Error: Could not open file " .. filename .. " - " .. err)
        return
    end
    file:write(data)  -- Write data to the file
    file:close()  -- Close the file
end

-- Function to convert JSON-like text to Lua table text
local function convertToLuaTable(jsonText)
    -- Replace JSON syntax with Lua table syntax
    jsonText = jsonText:gsub('%[', '{')
    jsonText = jsonText:gsub(']', '}')
    jsonText = jsonText:gsub('\"([^\"]+)\":', '["%1"] =')  -- Wrap keys in brackets and replace colon with equal sign
    jsonText = jsonText:gsub('\"', "'")  -- Convert double quotes to single quotes for Lua strings
    jsonText = jsonText:gsub('null', 'nil')  -- Replace JSON null with Lua nil

    -- Add "return" to make it a valid Lua file
    local luaTable = "ast = " .. jsonText

    return luaTable
end

-- Main script
local jsonFile = "output.json"
local fileContent = readFile(jsonFile)

if fileContent then
    local luaContent = convertToLuaTable(fileContent)
    writeFile("Output_Formatted.lua", luaContent)
    print("Formatted content written to Output_Formatted.lua")
else
    print("No content read from file.")
end
