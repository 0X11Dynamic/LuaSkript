local ast = {
  [1] =
  {
    ["Value"] = 1,
    ["Variable"] = "var",
    ["OPCODE"] = "SETVAR",
  },
  [2] =
  {
    ["Value"] = "var two$&@;)382",
    ["Variable"] = "var2",
    ["OPCODE"] = "SETVAR",
  },
  [3] =
  {
    ["Values"] =
    {
      [1] = 1,
      [2] = "+",
      [3] = 2,
      [4] = "+",
      [5] =
      {
        ["Variable"] = "var",
        ["OPCODE"] = "GETVAR",
      },
    },
    ["Variable"] = "var",
    ["OPCODE"] = "SETEQUATION",
  },
  [4] =
  {
    ["Values"] =
    {
      [1] = 2,
      [2] = "*",
      [3] = 3,
      [4] = "-",
      [5] = 4,
      [6] = "/",
      [7] = 5,
      [8] = "+",
      [9] =
      {
        ["Variable"] = "var",
        ["OPCODE"] = "GETVAR",
      },
      [10] = "^",
      [11] = 2,
      [12] = "%",
      [13] = 7,
    },
    ["Variable"] = "2",
    ["OPCODE"] = "SETEQUATION",
  },
  [5] =
  {
    ["Value"] =
    {
      [1] = 1,
      [2] = 2,
      [3] = "3",
      [4] =
      {
        [1] = "m",
        [2] = "n",
        [3] =
        {
          ["Variable"] = "doublevar",
          ["OPCODE"] = "GETVAR",
        },
      },
      [5] = 8,
      [6] =
      {
        ["Variable"] = "var",
        ["OPCODE"] = "GETVAR",
      },
    },
    ["Variable"] = "tablevar::*",
    ["OPCODE"] = "MAKETBL",
  },
  [6] =
  {
    ["Body"] =
    {
      [1] =
      {
        ["Value"] = 42,
        ["Variable"] = "innerVar",
        ["OPCODE"] = "SETVAR",
      },
      [2] =
      {
        ["Values"] =
        {
          [1] =
          {
            ["Variable"] = "innerVar",
            ["OPCODE"] = "GETVAR",
          },
          [2] = "+",
          [3] = 8,
        },
        ["Variable"] = "innerVar2",
        ["OPCODE"] = "SETEQUATION",
      },
      [3] =
      {
        ["Value"] =
        {
          [1] = 1,
          [2] = 2,
          [3] = "3",
          [4] =
          {
            [1] = "m",
            [2] = "n",
            [3] =
            {
              ["Variable"] = "doublevar",
              ["OPCODE"] = "GETVAR",
            },
          },
          [5] = 8,
          [6] =
          {
            ["Variable"] = "var",
            ["OPCODE"] = "GETVAR",
          },
        },
        ["Variable"] = "tablevar2::*",
        ["OPCODE"] = "MAKETBL",
      },
    },
    ["Variable"] = "testfunc",
    ["Args"] =
    {
      [1] =
      {
        ["Variable"] = "a",
        ["OPCODE"] = "GETVAR",
      },
      [2] =
      {
        ["Variable"] = "b",
        ["OPCODE"] = "GETVAR",
      },
      [3] =
      {
        ["Variable"] = "c",
        ["OPCODE"] = "GETVAR",
      },
    },
    ["OPCODE"] = "SETFUNC",
  },
  [7] =
  {
    ["Value"] =
    {
    },
    ["Variable"] = "testfunc",
    ["OPCODE"] = "CALL",
  },
}

--ip = 1
local env = {}
local funcs = {}

function execute(tree)
  for i = 1, #tree do
  --while true do
    local instr = tree[i]
    print(instr)
    local stack;

    if instr.OPCODE == "SETVAR" then
      env[instr.Variable] = instr.Value
    elseif instr.OPCODE == "MAKETBL" then
      env[instr.Variable] = instr.Value
    elseif instr.OPCODE == "SETEQUATION" then
      local values = instr.Values
      stack = values[1] -- Initialize stack with the first value
      local pointer = 2 -- Start with the operator (second element)

      while pointer < #values do
        local operator = values[pointer]
        local next_value = values[pointer + 1]
        -- Check if next_value is a table and get the value from the environment if so
        if type(next_value) == "table" then
          next_value = env[next_value.Variable]
        end

        if type(stack) == "table" then
          stack = env[stack.Variable]
        end

        -- Perform the operation on the stack based on the operator
        if operator == "+" then
          stack = stack + next_value
        elseif operator == "-" then
          stack = stack - next_value
        elseif operator == "*" then
          stack = stack * next_value
        elseif operator == "/" then
          stack = stack / next_value
        elseif operator == "^" then
          stack = stack ^ next_value
        elseif operator == "%" then
          stack = stack % next_value
        end

        -- Move the pointer to the next operator and value pair
        pointer = pointer + 2
      end
      print("Result of equation (" .. instr.Variable .. "): " .. stack)
    elseif instr.OPCODE == "SETFUNC" then
      funcs[instr.Variable] = {
        Body = instr.Body,
        Args = instr.Args
      }
    elseif instr.OPCODE == "CALL" then
      execute(funcs[instr.Variable])
    end

    if ip == #ast then
      break
    end

    --ip = ip + 1
  end
end

execute(ast)
