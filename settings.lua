---------------------------------------------------------------------------------------------------
--  ┏┓┏┓┏┳┓┏┳┓┳┳┓┏┓┏┓
--  ┗┓┣  ┃  ┃ ┃┃┃┃┓┗┓  -- FIRST SETTINGS STAGE
--  ┗┛┗┛ ┻  ┻ ┻┛┗┗┛┗┛
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- STARTUP SETTINGS
---------------------------------------------------------------------------------------------------

local function create_startup_setting(Name, Value)
    data:extend({{
        type = "double-setting",
        name = Name,
        setting_type = "startup",
        minimum_value = 100,
        default_value = Value
    }})
end

local storage_tank_capacities = {
    ["zith-storage-tank-1x1"] =   3600,
    ["zith-storage-tank-2x2"] =  12000,
    ["zith-storage-tank-3x4"] =  96000,
    ["zith-storage-tank-5x5"] = 160000
}

for storage_tank, volume in pairs(storage_tank_capacities) do
    data:extend({create_startup_setting(storage_tank.."-volume", volume)})
end

---------------------------------------------------------------------------------------------------
-- END NOTES
---------------------------------------------------------------------------------------------------