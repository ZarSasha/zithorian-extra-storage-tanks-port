---------------------------------------------------------------------------------------------------
--  ┏┳┓┏┓┏┓┓┏┳┓┏┓┓ ┏┓┏┓┓┏
--   ┃ ┣ ┃ ┣┫┃┃┃┃┃ ┃┃┃┓┗┫
--   ┻ ┗┛┗┛┛┗┛┗┗┛┗┛┗┛┗┛┗┛
---------------------------------------------------------------------------------------------------
require "shared"
---------------------------------------------------------------------------------------------------
-- TECHNOLOGY UNLOCK
---------------------------------------------------------------------------------------------------

-- Unlocks all storage tanks from this mod with Fluid Handling Technology.
local fluid_handling_tech = data.raw["technology"]["fluid-handling"]
if fluid_handling_tech ~= nil then
    local function add(RecipeName)
        table.insert(fluid_handling_tech.effects, {type = "unlock-recipe", recipe = RecipeName})
    end
    add(STORAGE_TANK_NAME["1x1"]) add(STORAGE_TANK_NAME["2x2"])
    add(STORAGE_TANK_NAME["3x4"]) add(STORAGE_TANK_NAME["5x5"])
end

---------------------------------------------------------------------------------------------------
-- END NOTES
---------------------------------------------------------------------------------------------------

-- Return to data-updates.lua?