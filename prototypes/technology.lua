---------------------------------------------------------------------------------------------------
--  ┏┳┓┏┓┏┓┓┏┳┓┏┓┓ ┏┓┏┓┓┏
--   ┃ ┣ ┃ ┣┫┃┃┃┃┃ ┃┃┃┓┗┫
--   ┻ ┗┛┗┛┛┗┛┗┗┛┗┛┗┛┗┛┗┛
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TECHNOLOGY UNLOCK
---------------------------------------------------------------------------------------------------
-- Unlocks all storage tanks with Fluid Handling tech. If Krastorio 2 is installed, the larger ones
-- will instead be unlocked with the Steel Fluid Tanks tech.

local storage_tanks = {
    ["1x1"] = SETTING.VOLUME["1x1"] > 0 and true or false,
    ["2x2"] = SETTING.VOLUME["2x2"] > 0 and true or false,
    ["3x4"] = SETTING.VOLUME["3x4"] > 0 and true or false,
    ["5x5"] = SETTING.VOLUME["5x5"] > 0 and true or false
}

local fluid_handling_tech = data.raw["technology"]["fluid-handling"]
if fluid_handling_tech == nil then
    log("fluid-handling tech is missing!") return
end

-- Krastorio 2:
if KRASTORIO_2 then

    -- Adds the small storage tanks to Fluid Handling tech.
    for _, variant in pairs({"1x1", "2x2"}) do
        if not storage_tanks[variant] then goto continue end
        table.insert(
            fluid_handling_tech.effects,
            {type = "unlock-recipe", recipe = STORAGE_TANK_NAME[variant]}
        )
        ::continue::
    end
    -- Adds the large storage tanks to Steel Fluid Tanks tech.
    local steel_fluid_tank_tech = data.raw["technology"]["kr-steel-fluid-tanks"]
    if steel_fluid_tank_tech == nil then
        log("kr-steel-fluid-tanks tech missing!") return
    end
    for _, variant in pairs({"3x4", "5x5"}) do
        if not storage_tanks[variant] then goto continue end
        table.insert(
            steel_fluid_tank_tech.effects,
            {type = "unlock-recipe", recipe = STORAGE_TANK_NAME[variant]}
        )
        ::continue::
    end
-- Default:
else
    -- Adds all the storage tanks to Fluid Handling tech.
    for _, variant in pairs(storage_tanks) do
        if not storage_tanks[variant] then goto continue end
        table.insert(
            fluid_handling_tech.effects,
            {type = "unlock-recipe", recipe = STORAGE_TANK_NAME[variant]}
        )
        ::continue::
    end
end

---------------------------------------------------------------------------------------------------
-- END NOTES
---------------------------------------------------------------------------------------------------
