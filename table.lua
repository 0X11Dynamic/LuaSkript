local ast = {
  [1] =
  {
    ["Value"] = 1,
    ["OPCODE"] = "SETVAR",
    ["Variable"] = "var",
  },
  [2] =
  {
    ["Value"] = "var two$&@;)382",
    ["OPCODE"] = "SETVAR",
    ["Variable"] = "var2",
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
    ["OPCODE"] = "SETEQUATION",
    ["Variable"] = "var",
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
    ["OPCODE"] = "SETEQUATION",
    ["Variable"] = "2",
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
    ["OPCODE"] = "MAKETBL",
    ["Variable"] = "tablevar::*",
  }
}