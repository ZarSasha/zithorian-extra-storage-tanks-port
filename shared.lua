---------------------------------------------------------------------------------------------------
--  ┏┓┓┏┏┓┳┓┏┓┳┓
--  ┗┓┣┫┣┫┣┫┣ ┃┃  -- FOR USE IN PROTOTYPE STAGES
--  ┗┛┛┗┛┗┛┗┗┛┻┛
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- MOD NAME
---------------------------------------------------------------------------------------------------
MOD_NAME      = "__zithorian-extra-storage-tanks-port__"
---------------------------------------------------------------------------------------------------
-- ASSET PATHS
---------------------------------------------------------------------------------------------------
ICON_PATH     = MOD_NAME .. "/graphics/icons/"
GRAPHICS_PATH = MOD_NAME .. "/graphics/entities/"
---------------------------------------------------------------------------------------------------
-- ENTITY NAMES
---------------------------------------------------------------------------------------------------
STORAGE_TANK_NAME = {
    ["1x1"] = "zith-storage-tank-1x1",
    ["2x2"] = "zith-storage-tank-2x2",
    ["3x4"] = "zith-storage-tank-3x4",
    ["5x5"] = "zith-storage-tank-5x5"
}
---------------------------------------------------------------------------------------------------
-- STARTUP SETTINGS
---------------------------------------------------------------------------------------------------
SETTING = {}

SETTING.VOLUME = {
    ["1x1"] = settings.startup["zith-storage-tank-1x1-volume-setting"].value,
    ["2x2"] = settings.startup["zith-storage-tank-2x2-volume-setting"].value,
    ["3x4"] = settings.startup["zith-storage-tank-3x4-volume-setting"].value,
    ["5x5"] = settings.startup["zith-storage-tank-5x5-volume-setting"].value,
}

SETTING.ENABLED = {
    ["1x1"] = SETTING.VOLUME["1x1"] > 0 and true or false,
    ["2x2"] = SETTING.VOLUME["2x2"] > 0 and true or false,
    ["3x4"] = SETTING.VOLUME["3x4"] > 0 and true or false,
    ["5x5"] = SETTING.VOLUME["5x5"] > 0 and true or false
}

---------------------------------------------------------------------------------------------------
-- MOD PRESENCE
---------------------------------------------------------------------------------------------------
SPACE_AGE         = false; if mods["space-age"]         then SPACE_AGE         = true end
KRASTORIO_2       = false; if mods["Krastorio2"]        then KRASTORIO_2       = true end
SPACE_EXPLORATION = false; if mods["space-exploration"] then SPACE_EXPLORATION = true end

---------------------------------------------------------------------------------------------------
-- END NOTES
---------------------------------------------------------------------------------------------------
