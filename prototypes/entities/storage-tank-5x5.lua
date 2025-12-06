---------------------------------------------------------------------------------------------------
--  ┏┓┳┓┏┓┏┳┓┏┓┏┳┓┓┏┏┓┏┓┏┓
--  ┃┃┣┫┃┃ ┃ ┃┃ ┃ ┗┫┃┃┣ ┗┓
--  ┣┛┛┗┗┛ ┻ ┗┛ ┻ ┗┛┣┛┗┛┗┛
---------------------------------------------------------------------------------------------------
require "shared"
local ent_func = require "prototypes.entities.entity-functions"
---------------------------------------------------------------------------------------------------
-- FLUID STORAGE TANK 5X5 --
---------------------------------------------------------------------------------------------------
local entity_name = STORAGE_TANK_NAME["5x5"]
---------------------------------------------------------------------------------------------------
    -- ENTITY PROTOTYPE
---------------------------------------------------------------------------------------------------
local entity_data = {
    MiningTime          = 1.0,
    Health              = 900,
    --FastReplaceGroup  = nil,
    SelectionBox        = {{-2.5,-2.5},{ 2.5, 2.5}},
    CollisionOffset     = -0.1,
    --DrawBoxVertExt    = nil,
    IconDrawSpec        = {scale = 2, shift = {0,-0.25}},
    PipeConnections     = {
        { direction = defines.direction.north, position = {-2,-2} },
        { direction = defines.direction.north, position = { 2,-2} },
        { direction = defines.direction.east,  position = { 2,-2} },
        { direction = defines.direction.east,  position = { 2, 2} },
        { direction = defines.direction.south, position = { 2, 2} },
        { direction = defines.direction.south, position = {-2, 2} },
        { direction = defines.direction.west,  position = {-2, 2} },
        { direction = defines.direction.west,  position = {-2,-2} }
    },
    WireConnections     = ent_func.create_four_identical_wire_connections(
        {25, -61.5, 33.5, 12}
        --
    ),
    SpriteSheet         = ent_func.create_entity_graphics_and_shadow_sheet(entity_name, {
        Scale        = 0.5,
        Frames       = 1,
        EntityWidth  = 320,
        EntityHeight = 384,
        EntityShift  = {0, -0.5},
        ShadowWidth  = 384,
        ShadowHeight = 352,
        ShadowShift  = {0.5, 0.25},
    }),
    WindowIsTall        = false,
    WindowBox           = {{-0.2, (0.5 + 24 / 64)}, {0.2, (2.5 - 41 / 64)}},
    WindowScale         = 0.8,
    FluidFlowLength     = 575,
    FluidFlowScale      = 1.2,
    SoundSizeCategory   = "large",
    SoundVolume         = 0.6,
    HeatingEnergy       = "320kW" -- On Aquilo
}

---------------------------------------------------------------------------------------------------
    -- OTHER PROTOTYPES (EXPLOSION, REMNANTS, ITEM, RECIPE)
---------------------------------------------------------------------------------------------------
local explosion_data = {
    SoundSizeCat    = "large",
    --SoundVolMin   = 1,
    --SoundVolMax   = 1,
    AnimSizeCat     = "large",
    --AnimScale     = 1,
    AnimHeight      = 1,
    DebrisAmountX   = 3,
    DebrisSpeedX    = 1.1
}
local remnants_data = {
    Radius          = 2.5,
    Shift           = {43, 32}
}
local item_data = {
    SoundSizeCat    = "large",
    StackSize       =  10,
    Weight          =  100
}
local recipe_data = {
    EnergyNeed      =  10,
    IronPlates      =  40,
    SteelPlates     =  20
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