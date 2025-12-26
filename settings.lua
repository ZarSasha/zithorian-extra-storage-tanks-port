---------------------------------------------------------------------------------------------------
--  ┏┓┏┓┏┳┓┏┳┓┳┳┓┏┓┏┓
--  ┗┓┣  ┃  ┃ ┃┃┃┃┓┗┓  -- FIRST SETTINGS STAGE
--  ┗┛┗┛ ┻  ┻ ┻┛┗┗┛┗┛
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- STARTUP SETTINGS
---------------------------------------------------------------------------------------------------

-- Create settings to adjust capacity for each of the storage tanks.
local startup_settings = {}

for variant, volume in pairs({
    ["zith-storage-tank-1x1"] =   3000,
    ["zith-storage-tank-2x2"] =  12000,
    ["zith-storage-tank-3x4"] =  72000,
    ["zith-storage-tank-5x5"] = 150000
}) do
    table.insert(startup_settings, {
        type = "double-setting",
        name = variant.."-volume-setting",
        setting_type = "startup",
        default_value = volume,
        minimum_value = 100
    })
end

data:extend(startup_settings)

---------------------------------------------------------------------------------------------------
-- END NOTES
---------------------------------------------------------------------------------------------------

-- Expected format in locale: zith-storage-tank-1x1-volume-setting