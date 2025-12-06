---------------------------------------------------------------------------------------------------
--  ┏┓┏┓┏┳┓┏┳┓┳┳┓┏┓┏┓
--  ┗┓┣  ┃  ┃ ┃┃┃┃┓┗┓  -- FIRST SETTINGS STAGE
--  ┗┛┗┛ ┻  ┻ ┻┛┗┗┛┗┛
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- STARTUP SETTINGS
---------------------------------------------------------------------------------------------------

-- Create settings to adjust capacity for each of the storage tanks.
for variant, volume in pairs({
    ["1x1"] =   3000,
    ["2x2"] =  12000,
    ["3x4"] =  72000,
    ["5x5"] = 150000
}) do
    local startup_settings = {}
    table.insert(startup_settings, {
        type = "double-setting",
        name = "zith-startup-storage-tank-"..variant.."-volume",
        setting_type = "startup",
        default_value = volume,
        minimum_value = 100
    })
    data:extend({startup_settings})
end

---------------------------------------------------------------------------------------------------
-- END NOTES
---------------------------------------------------------------------------------------------------

-- Expected format in locale: "zith-startup-storage_tank-1x1-volume"