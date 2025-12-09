---------------------------------------------------------------------------------------------------
--  ┏┓┳┓┏┓┏┳┓┏┓┏┳┓┓┏┏┓┏┓┏┓
--  ┃┃┣┫┃┃ ┃ ┃┃ ┃ ┗┫┃┃┣ ┗┓
--  ┣┛┛┗┗┛ ┻ ┗┛ ┻ ┗┛┣┛┗┛┗┛
---------------------------------------------------------------------------------------------------
require "shared"
local spfunc = require "special-functions"
---------------------------------------------------------------------------------------------------
-- STORAGE TANK 1X1 --
---------------------------------------------------------------------------------------------------
local entity_name = STORAGE_TANK_NAME["1x1"]
---------------------------------------------------------------------------------------------------
    -- ENTITY PROTOTYPE
---------------------------------------------------------------------------------------------------
local entity_data = {
    MiningTime          = 0.125,
    Health              = 300,
    FastReplaceGroup    = "pipe",
    SelectionBox        = {{-0.5,-0.5},{ 0.5, 0.5}},
    CollisionOffset     = -0.1,
    --TileHeight        = nil
    DrawBoxVertExt      = 1.35,
    IconDrawSpec        = {scale = 0.75, shift = {0,-0.33}},
    PipeConnections     = {
        { direction = defines.direction.north, position = { 0, 0} },
        --
        { direction = defines.direction.east,  position = { 0, 0} },
        --
        { direction = defines.direction.south, position = { 0, 0} },
        --
        { direction = defines.direction.west,  position = { 0, 0} }
        --
    },
    WireConnections     = spfunc.create_four_identical_wire_connections(
         26, 7, -5, 2
        --
    ),
    EntitySprites       = spfunc.create_entity_graphics_and_shadow(entity_name, {
        Scale        = 0.5,
        Frames       = 1,
        EntityWidth  =  64,
        EntityHeight = 192,
        EntityShift  = {0, -1},
        ShadowWidth  = 160,
        ShadowHeight = 128,
        ShadowShift  = {0.75, 0},
    }),
    WindowIsTall        = false,
    WindowBox           = {{-0.1, (-1.5 + 30 / 64)}, {0.1, (0.5 - 46 / 64)}},
    WindowScale         = 0.8,
    FluidFlowLength     = 575,
    FluidFlowScale      = 1.0,
    SoundSizeCategory   = "small",
    SoundVolume         = 0.4,
    HeatingEnergy       = "25kW" -- On Aquilo
}

---------------------------------------------------------------------------------------------------
    -- OTHER PROTOTYPES (EXPLOSION, REMNANTS, ITEM, RECIPE)
---------------------------------------------------------------------------------------------------
local explosion_data = { -- used by entity
    SoundSizeCat    = "small",
    --SoundVolMin   = 1,
    --SoundVolMax   = 1,
    AnimSizeCat     = "small",
    AnimScale       = 1,
    AnimHeight      = 0,
    DebrisAmountX   = 0.5,
    DebrisSpeedX    = 0.825
}
local remnants_data = { -- used by entity
    Radius          = 0.5,
    Shift           = {9, 6}
}
local item_data = {
    SoundSizeCat    = "small",
    StackSize       =  50,
    Weight          =  10
}
local recipe_data = {
    EnergyNeed      = 1.0,
    IronPlates      =   5,
    SteelPlates     =   1
}

---------------------------------------------------------------------------------------------------
-- FINAL DATA WRITE --
---------------------------------------------------------------------------------------------------
data:extend({
    spfunc.create_explosion(entity_name, explosion_data),
    spfunc.create_remnants (entity_name, remnants_data ),
    spfunc.create_entity   (entity_name, entity_data   ),
    spfunc.create_item     (entity_name, item_data     ),
    spfunc.create_recipe   (entity_name, recipe_data   )
})

---------------------------------------------------------------------------------------------------
-- END NOTES
---------------------------------------------------------------------------------------------------