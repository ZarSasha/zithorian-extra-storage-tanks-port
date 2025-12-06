---------------------------------------------------------------------------------------------------
--  ┏┓┳┓┏┓┏┳┓┏┓┏┳┓┓┏┏┓┏┓┏┓
--  ┃┃┣┫┃┃ ┃ ┃┃ ┃ ┗┫┃┃┣ ┗┓  -- INCOMPLETE!!
--  ┣┛┛┗┗┛ ┻ ┗┛ ┻ ┗┛┣┛┗┛┗┛
---------------------------------------------------------------------------------------------------
require "shared"
local ent_func = require "prototypes.entities.entity-functions"
---------------------------------------------------------------------------------------------------
-- FLUID STORAGE TANK 3X4 --
---------------------------------------------------------------------------------------------------
local entity_name = STORAGE_TANK_NAME["3x4"]
---------------------------------------------------------------------------------------------------
    -- ENTITY PROTOTYPE
---------------------------------------------------------------------------------------------------
local entity_data = {
    MiningTime          = 0.75,
    Health              = 700,
    --FastReplaceGroup  = nil,
    SelectionBox        = {{-1.5,-2.5},{ 1.5, 1.5}}, -- rotation axis 0.5 below visual center.
    CollisionOffset     = -0.1,
    DrawBoxVertExt      = 2.15,
    IconDrawSpec        = {scale = 1.5, shift = {0, -0.75}},
    PipeConnections     = {
        { direction = defines.direction.north, position = {-1,-2} },
        { direction = defines.direction.north, position = { 1,-2} }
        --
        --
        --
        --
        --
        --
    },
    WireConnections     = ent_func.create_four_different_wire_connections(
        {25, -27.5, -3.5, 0}, { 2, 64.5,-39.5, 12},
        { 0,  28.5, 48.5, 0}, { 6,-64.5, 13.5,  0}
    ),
    EntitySprites       = ent_func.create_entity_graphics_and_shadow(entity_name, {
        Scale        = 0.5,
        Frames       = 4,
        EntityWidth  = 640,
        EntityHeight = 640,
        EntityShift  = {0, 0},
        ShadowWidth  = 640,
        ShadowHeight = 640,
        ShadowShift  = {0, 0}
    }),
    WindowIsTall        = true,
    WindowBox           = {{-0.2, (-1.5 + 12 / 64)}, {0.2, (0.5 + 14 / 64)}},
    WindowScale         = 0.5,
    FluidFlowLength     = 1175,
    FluidFlowScale      = 1.2,
    SoundSizeCategory   = "large",
    SoundVolume         = 0.6,
    HeatingEnergy       = "210kW" -- On Aquilo
}

---------------------------------------------------------------------------------------------------
    -- OTHER PROTOTYPES (EXPLOSION, REMNANTS, ITEM, RECIPE)
---------------------------------------------------------------------------------------------------
local explosion_data = {
    SoundSizeCat    = "large",
    SoundVolMin     = 0.5,
    SoundVolMax     = 0.7,
    --AnimSizeCat   = "medium",
    --AnimScale     = 1,
    --AnimHeight    = 0,
    DebrisAmountX   = 1.8,
    DebrisSpeedX    = 1.05
}
local remnants_data = {
    Radius          = 2.5,
    Shift           = {43, 32}
}
local item_data = {
    SoundSizeCat    = "large",
    StackSize       =  20,
    Weight          =  50
}
local recipe_data = {
    EnergyNeed      = 7.5,
    IronPlates      =  24,
    SteelPlates     =  12
}

---------------------------------------------------------------------------------------------------
-- FINAL DATA WRITE --
---------------------------------------------------------------------------------------------------
data:extend({
    -- Entity
    ent_func.create_explosion(entity_name, explosion_data),
    ent_func.create_remnants (entity_name, remnants_data ),
    ent_func.create_entity   (entity_name, entity_data   ),
    -- Other
    ent_func.create_item     (entity_name, item_data     ),
    ent_func.create_recipe   (entity_name, recipe_data   )
})

---------------------------------------------------------------------------------------------------
-- END NOTES
---------------------------------------------------------------------------------------------------