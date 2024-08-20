local ast = {
    {
      type = "SETVAR",
      variable = { name = "StringVar" },
      value = "variable1",
    },
    {
      type = "SETVAR",
      variable = { name = "NUmVar" },
      value = 1,
    }
  }
  
  ip = 1
  local env = {}
  while true do
    local instr = ast[ip]
  
    --print(instr)
  
    if instr.type == "SETVAR" then
      env[instr.variable.name] = instr.value
    end
  
    if ip == #ast then
      break
    end
    ip = ip + 1
  end
  --printing output
  print(env.NUmVar)