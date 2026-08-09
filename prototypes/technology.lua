---------------------------------------------------------------------------------------------------
--  ┏┳┓┏┓┏┓┓┏┳┓┏┓┓ ┏┓┏┓┓┏
--   ┃ ┣ ┃ ┣┫┃┃┃┃┃ ┃┃┃┓┗┫
--   ┻ ┗┛┗┛┛┗┛┗┗┛┗┛┗┛┗┛┗┛
---------------------------------------------------------------------------------------------------
require "shared"
---------------------------------------------------------------------------------------------------
-- TECHNOLOGY UNLOCK
---------------------------------------------------------------------------------------------------
-- Unlocks the smaller storage tanks with Fluid Handling tech, the larger ones with their own,
-- separate tech. If Krastorio 2 is installed, the later will instead be unlocked with the Steel
-- Fluid Tanks tech.

local fluid_handling_tech = data.raw["technology"]["fluid-handling"]
if fluid_handling_tech == nil then
    log("fluid-handling tech is missing!") return
end

-- Adds just the small storage tanks to Fluid Handling tech.
for _, variant in pairs({"1x1", "2x2"}) do
    table.insert(
        fluid_handling_tech.effects,
        {type = "unlock-recipe", recipe = STORAGE_TANK_NAME[variant]}
    )
end

-- Krastorio 2:
if KRASTORIO_2.IsPresent then
    -- Adds the large storage tanks to Steel Fluid Tanks tech.
    local steel_fluid_tank_tech = data.raw["technology"]["kr-steel-fluid-tanks"]
    if steel_fluid_tank_tech == nil then
        log("kr-steel-fluid-tanks tech missing!") return
    end
    for _, variant in pairs({"3x4","5x5"}) do
        table.insert(
            steel_fluid_tank_tech.effects,
            {type = "unlock-recipe", recipe = STORAGE_TANK_NAME[variant]}
        )
    end
-- Default:
else
    -- Adds the large storage tanks to their own separate tech.
    local storageTankTech = {
        type = "technology",
        name = "zith-storage-tanks",
        icon = TECH_PATH .. "zith-storage-tanks.png",
        icon_size = 256,
        prerequisites = {"fluid-handling"},
        effects = {
            { type = "unlock-recipe", recipe = STORAGE_TANK_NAME["3x4"] },
            { type = "unlock-recipe", recipe = STORAGE_TANK_NAME["5x5"] },
        },
        unit = {
            count = 25,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1}
            },
            time = 15
        }
    }
    data:extend({storageTankTech})
end

---------------------------------------------------------------------------------------------------
-- END NOTES
---------------------------------------------------------------------------------------------------