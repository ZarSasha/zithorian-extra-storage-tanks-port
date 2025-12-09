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
    for _, variant in pairs({"1x1","2x2","3x4","5x5"}) do add(STORAGE_TANK_NAME[variant]) end
end

---------------------------------------------------------------------------------------------------
-- END NOTES
---------------------------------------------------------------------------------------------------

-- Return to data-updates.lua?