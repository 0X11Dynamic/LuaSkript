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
        ["OPCODE"] = "GETVAR",
        ["Variable"] = "var",
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
        ["OPCODE"] = "GETVAR",
        ["Variable"] = "var",
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
          ["OPCODE"] = "GETVAR",
          ["Variable"] = "doublevar",
        },
      },
      [5] = 8,
      [6] =
      {
        ["OPCODE"] = "GETVAR",
        ["Variable"] = "var",
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
            ["OPCODE"] = "GETVAR",
            ["Variable"] = "innerVar",
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
              ["OPCODE"] = "GETVAR",
              ["Variable"] = "doublevar",
            },
          },
          [5] = 8,
          [6] =
          {
            ["OPCODE"] = "GETVAR",
            ["Variable"] = "var",
          },
        },
        ["Variable"] = "tablevar2::*",
        ["OPCODE"] = "MAKETBL",
      },
      [4] =
      {
        ["Value"] = 42,
        ["Variable"] = "innerVar2",
        ["OPCODE"] = "SETVAR",
      },
      [5] =
      {
        ["Values"] =
        {
          [1] =
          {
            ["OPCODE"] = "GETVAR",
            ["Variable"] = "innerVar",
          },
          [2] = "+",
          [3] = 8,
        },
        ["Variable"] = "innerVar22",
        ["OPCODE"] = "SETEQUATION",
      },
      [6] =
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
              ["OPCODE"] = "GETVAR",
              ["Variable"] = "doublevar",
            },
          },
          [5] = 8,
          [6] =
          {
            ["OPCODE"] = "GETVAR",
            ["Variable"] = "var",
          },
        },
        ["Variable"] = "tablevar22::*",
        ["OPCODE"] = "MAKETBL",
      },
    },
    ["Variable"] = "testfunc",
    ["OPCODE"] = "SETFUNC",
    ["Args"] =
    {
      [1] =
      {
        ["OPCODE"] = "GETVAR",
        ["Variable"] = "a",
      },
      [2] =
      {
        ["OPCODE"] = "GETVAR",
        ["Variable"] = "b",
      },
      [3] =
      {
        ["OPCODE"] = "GETVAR",
        ["Variable"] = "c",
      },
    },
  },
  [7] =
  {
    ["Body"] =
    {
      [1] =
      {
        ["Value"] = 42,
        ["Variable"] = "innerVar2",
        ["OPCODE"] = "SETVAR",
      },
      [2] =
      {
        ["Values"] =
        {
          [1] =
          {
            ["OPCODE"] = "GETVAR",
            ["Variable"] = "innerVar",
          },
          [2] = "+",
          [3] = 8,
        },
        ["Variable"] = "innerVar22",
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
              ["OPCODE"] = "GETVAR",
              ["Variable"] = "doublevar",
            },
          },
          [5] = 8,
          [6] =
          {
            ["OPCODE"] = "GETVAR",
            ["Variable"] = "var",
          },
        },
        ["Variable"] = "tablevar22::*",
        ["OPCODE"] = "MAKETBL",
      },
    },
    ["Variable"] = "testfun2",
    ["OPCODE"] = "SETFUNC",
    ["Args"] =
    {
      [1] =
      {
        ["OPCODE"] = "GETVAR",
        ["Variable"] = "first",
      },
      [2] =
      {
        ["OPCODE"] = "GETVAR",
        ["Variable"] = "second",
      },
      [3] =
      {
        ["OPCODE"] = "GETVAR",
        ["Variable"] = "third",
      },
    },
  },
  [8] =
  {
    ["Value"] = 1,
    ["Variable"] = "a",
    ["OPCODE"] = "SETVAR",
  },
  [9] =
  {
    ["Value"] = 2,
    ["Variable"] = "b",
    ["OPCODE"] = "SETVAR",
  },
  [10] =
  {
    ["Value"] = 3,
    ["Variable"] = "c",
    ["OPCODE"] = "SETVAR",
  },
  [11] =
  {
    ["Value"] =
    {
      [1] = 1,
      [2] = 2,
      [3] = 3,
    },
    ["Variable"] = "testfunc",
    ["OPCODE"] = "CALL",
  },
  [12] =
  {
    ["Value"] = "a",
    ["Variable"] = "first",
    ["OPCODE"] = "SETVAR",
  },
  [13] =
  {
    ["Value"] = "b",
    ["Variable"] = "second",
    ["OPCODE"] = "SETVAR",
  },
  [14] =
  {
    ["Value"] =
    {
      ["OPCODE"] = GETVAR,
      ["Variable"] = "c",
    },
    ["Variable"] = "third",
    ["OPCODE"] = "SETVAR",
  },
  [15] =
  {
    ["Value"] =
    {
      [1] = "a",
      [2] = "b",
      [3] =
      {
        ["OPCODE"] = "GETVAR",
        ["Variable"] = "c",
      },
    },
    ["Variable"] = "testfun2",
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
    --print(instr)
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
      execute(funcs[instr.Variable].Body)
    end

    if ip == #ast then
      break
    end

    --ip = ip + 1
  end
end

execute(ast)
