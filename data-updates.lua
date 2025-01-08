---------------------------------------------------------------------------------------------------
--  ┳┓┏┓┏┳┓┏┓  ┳┳┏┓┳┓┏┓┏┳┓┏┓┏┓
--  ┃┃┣┫ ┃ ┣┫━━┃┃┃┃┃┃┣┫ ┃ ┣ ┗┓
--  ┻┛┛┗ ┻ ┛┗  ┗┛┣┛┻┛┛┗ ┻ ┗┛┗┛
---------------------------------------------------------------------------------------------------

-- TECH UNLOCK --
local fluid_handling_tech = data.raw["technology"]["fluid-handling"]
if fluid_handling_tech ~= nil then
  local function add(RecipeName)
    table.insert(fluid_handling_tech.effects, {type = "unlock-recipe", recipe = RecipeName})
  end
  add("fluid-tank-1x1") add("fluid-tank-2x2") add("fluid-tank-3x4") add("fluid-tank-5x5")
end
---------------------------------------------------------------------------------------------------