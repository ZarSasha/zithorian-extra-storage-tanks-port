---------------------------------------------------------------------------------------------------
--  ┏┓┳┓┏┓┏┳┓┏┓┏┳┓┓┏┏┓┏┓┏┓
--  ┃┃┣┫┃┃ ┃ ┃┃ ┃ ┗┫┃┃┣ ┗┓
--  ┣┛┛┗┗┛ ┻ ┗┛ ┻ ┗┛┣┛┗┛┗┛
---------------------------------------------------------------------------------------------------
require "shared"
local spfunc = require "special-functions"
---------------------------------------------------------------------------------------------------
-- STORAGE TANK 2X2 --
---------------------------------------------------------------------------------------------------
local entity_name = STORAGE_TANK_NAME["2x2"]
---------------------------------------------------------------------------------------------------
    -- ENTITY PROTOTYPE
---------------------------------------------------------------------------------------------------
local entity_data = {
    MiningTime          = 0.25,
    Health              = 400,
    --FastReplaceGroup  = nil,
    SelectionBox        = {{-1,-1},{ 1, 1}},
    CollisionOffset     = -0.1,
    --TileHeight        = nil
    DrawBoxVertExt      = 0.15,
    IconDrawSpec        = {scale = 1, shift = {0,-0.25}},
    PipeConnections     = {
        { direction = defines.direction.north, position = { 0.5,-0.5} },

        { direction = defines.direction.east,  position = { 0.5,-0.5} },
        --
        --
        --
        { direction = defines.direction.west,  position = {-0.5,-0.5} }
        --
    },
    WireConnections     = spfunc.create_four_different_wire_connections(
        {25, -20,  0,  0}, {25, -20,  0,  0},
        {27,  20,  0,  0}, {27,  20,  0,  0}
    ),
    EntitySprites       = spfunc.create_entity_graphics_and_shadow(entity_name, {
        Scale        = 0.5,
        Frames       = 4,
        EntityWidth  = 128,
        EntityHeight = 160,
        EntityShift  = {0, -0.25},
        ShadowWidth  = 160,
        ShadowHeight = 128,
        ShadowShift  = {0.25, 0.5},
    }),
    WindowIsTall        = false,
    WindowBox           = {{-0.2, (11 / 64)}, {0.2, (1.0 - 16 / 64)}},
    WindowScale         = 0.5,
    FluidFlowLength     = 405,
    FluidFlowScale      = 1.0,
    SoundSizeCategory   = "large",
    SoundVolume         = 0.5,
    HeatingEnergy       = "55kW" -- On Aquilo
}

---------------------------------------------------------------------------------------------------
    -- OTHER PROTOTYPES (EXPLOSION, REMNANTS, ITEM, RECIPE)
---------------------------------------------------------------------------------------------------
local explosion_data = {
    SoundSizeCat    = "medium",
    --SoundVolMin   = 1,
    --SoundVolMax   = 1,
    AnimSizeCat     = "medium",
    AnimScale       = 0.75,
    AnimHeight      = 0,
    DebrisAmountX   = 0.8,
    DebrisSpeedX    = 0.9
}
local remnants_data = {
    Radius          = 1,
    Shift           = {17, 12}
}
local item_data = {
    SoundSizeCat    = "large",
    StackSize       =  50,
    Weight          =  20
}
local recipe_data = {
    EnergyNeed      = 2.0,
    IronPlates      =  15,
    SteelPlates     =   2
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