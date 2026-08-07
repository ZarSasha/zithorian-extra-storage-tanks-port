---------------------------------------------------------------------------------------------------
--  ┏┳┓┏┓┏┓┓┏┳┓┏┓┓ ┏┓┏┓┓┏
--   ┃ ┣ ┃ ┣┫┃┃┃┃┃ ┃┃┃┓┗┫
--   ┻ ┗┛┗┛┛┗┛┗┗┛┗┛┗┛┗┛┗┛
---------------------------------------------------------------------------------------------------
require "shared"
---------------------------------------------------------------------------------------------------
-- TECHNOLOGY UNLOCK
---------------------------------------------------------------------------------------------------
-- Unlocks all storage tanks from this mod with Fluid Handling tech. If Krastorio 2 is
-- installed, the bigger ones will be moved to Steel Fluid Tanks.

local fluid_handling_tech = data.raw["technology"]["fluid-handling"]
if fluid_handling_tech == nil then log("fluid-handling tech missing!") return end

local function add_at_start(TechName, RecipeName)
    table.insert(TechName.effects, 1, {type = "unlock-recipe", recipe = RecipeName})
end

local function add_at_end(TechName, RecipeName)
    table.insert(TechName.effects, {type = "unlock-recipe", recipe = RecipeName})
end

-- Yes, I made two functions because Lua is just really inflexible with its table.insert function!

-- Krastorio 2:
if mods["Krastorio2"] then
    local steel_fluid_tank_tech = data.raw["technology"]["kr-steel-fluid-tanks"]
    if steel_fluid_tank_tech == nil then log("kr-steel-fluid-tanks tech missing!") return end
    for _, variant in pairs({"2x2","1x1"}) do
        add_at_start(fluid_handling_tech, 1, STORAGE_TANK_NAME[variant])
    end
    for _, variant in pairs({"3x4","5x5"}) do
        add_at_end(steel_fluid_tank_tech, STORAGE_TANK_NAME[variant])
    end
-- Default:
else
    for _, variant in pairs({"1x1","2x2","3x4","5x5"}) do
        add_at_end(fluid_handling_tech, STORAGE_TANK_NAME[variant])
    end
end

---------------------------------------------------------------------------------------------------
-- END NOTES
---------------------------------------------------------------------------------------------------