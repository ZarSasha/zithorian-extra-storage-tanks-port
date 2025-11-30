---------------------------------------------------------------------------------------------------
--  ┏┓┳┓┏┳┓┳┏┳┓┓┏
--  ┣ ┃┃ ┃ ┃ ┃ ┗┫
--  ┗┛┛┗ ┻ ┻ ┻ ┗┛
---------------------------------------------------------------------------------------------------
require("util") require("functions")
local item_sounds = require("__base__.prototypes.item_sounds")
local sounds = require("__base__.prototypes.entity.sounds")
local explosion_animations = require "__base__.prototypes.entity.explosion-animations"
---------------------------------------------------------------------------------------------------
-- 2x2 STORAGE TANK --
---------------------------------------------------------------------------------------------------
local typeName   = "storage-tank"
local entityName = "fluid-tank-2x2"
local iconPath   = modName .. "/graphics/icons/" .. entityName .. ".png"


local centerX = 1
local centerY = 1

local graphicsPath   = modName .. "/graphics/entity/" .. entityName .. ".png"
local graphicsWidth  = 128
local graphicsHeight = 160
local graphicsShiftX = (centerX * 64 - graphicsWidth / 2) / 2
local graphicsShiftY = (centerY * 64 - graphicsHeight / 2) / 2

local shadowBelowBottomShiftY = 0.5

local shadowWidth  = 160
local shadowHeight = 128
local shadowShiftX = (shadowWidth / 2 - centerX * 64) / 2
local shadowShiftY = ((centerY + shadowBelowBottomShiftY) * 64 - shadowHeight / 2) / 2
local useShadow = true

local frames = 4

local boxLeft  = -1.0
local boxRight =  1.0
local boxDown  = -1.0
local boxUp    =  1.0

local collisionBoxOffset = 0.1
local box = { { boxLeft, boxDown }, { boxRight, boxUp } }
local collisionBox = {
    { boxLeft  + collisionBoxOffset, boxDown + collisionBoxOffset},
    { boxRight - collisionBoxOffset, boxUp   - collisionBoxOffset}
}

local remnantsRadius = 1 -- square, same center as entity.

local maxHealth   = 400
local fluidvolume = settings.startup["z-fluid-tank-volume-2x2"].value
local miningTime  = 0.25

local useFluidWindow   = true
local windowBox        = {{-0.2, 11 / 64}, {0.2, 1.0 - 16 / 64}}
local fluidWindowScale = 0.5
local fluidScale       = 1.0

local pipe_connections =
{
  { direction = defines.direction.north, position = { 0.5, -0.5} },
  { direction = defines.direction.east,  position = { 0.5, -0.5} },
  { direction = defines.direction.west,  position = {-0.5, -0.5} }
}

local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

local Recipe = {
  type = "recipe",
  name = entityName,
  enabled = false,
  energy_required = 2.5,
  ingredients = {
    {type = "item", name = "iron-plate",  amount = 15},
    {type = "item", name = "steel-plate", amount =  2}
},
  results = {
    {type = "item", name = entityName, amount = 1}
  }
}

local Item = {
  type = "item",
  name = entityName,
  icon = iconPath,
  icon_size = 64, icon_mipmaps = 4,
  subgroup = "storage",
  order = "bc",
  inventory_move_sound = item_sounds.metal_large_inventory_move,
  pick_sound = item_sounds.metal_large_inventory_pickup,
  drop_sound = item_sounds.metal_large_inventory_move,
  place_result = entityName,
  stack_size = 50,
  weight = 20*kg
}

local wireDefinition = circuit_connector_definitions.create_vector
( universal_connector_template,
  {
    create_wire(25, -20, 0, 0),
    create_wire(25, -20, 0, 0),
    create_wire(27,  20, 0, 0),
    create_wire(27,  20, 0, 0)
  }
)

local Remnants = create_remnants(entityName, remnantsRadius, {17, 12})

local Explosion = create_scaled_explosion(entityName, 0.8, 0.9)
Explosion.animations = explosion_animations.medium_explosion(0.75)
Explosion.sound = sounds.medium_explosion

local Entity = {
  type = typeName,
  name = entityName,
  icon = iconPath,
  icon_size = 64, icon_mipmaps = 4,
  flags = {"placeable-player", "player-creation"},
  minable = {mining_time = miningTime, result = entityName},
  max_health = maxHealth,
  corpse = entityName .. "-remnants",
  dying_explosion = entityName .. "-explosion",
  collision_box = collisionBox,
  selection_box = box,
  drawing_box_vertical_extension = 0.15,
  icon_draw_specification = {scale = 1, shift = {0, -0.25}},
  damaged_trigger_effect = hit_effects.entity(),
  fluid_box =
  {
    volume = fluidvolume,
    pipe_covers = pipecoverspictures(),
    pipe_connections = pipe_connections,
    hide_connection_info = true
  },
  two_direction_only = false,
  window_bounding_box = windowBox,
  pictures =
  {
    picture =
    {
      sheets = create_graphics_and_shadow_sheet(
        graphicsPath, frames, graphicsWidth, graphicsHeight, util.by_pixel(graphicsShiftX, graphicsShiftY),
        shadowWidth, shadowHeight, util.by_pixel(shadowShiftX, shadowShiftY), useShadow)
    },
    window_background = create_window_background(useFluidWindow, fluidWindowScale),
    fluid_background = create_fluid(useFluidWindow, fluidScale),
    flow_sprite = create_fluid_flow_sprite(useFluidWindow, fluidScale),
    gas_flow = create_gas_flow_sprite(useFluidWindow, fluidScale)
  },
  flow_length_in_ticks = 405, -- should match the Storage Tank
  impact_category = "metal-large",
  open_sound = sounds.metal_large_open,
  close_sound = sounds.metal_large_close,
  working_sound =
  {
    sound =
    {
        filename = "__base__/sound/storage-tank.ogg",
        volume = 0.5
    },
    match_volume_to_activity = true,
    audible_distance_modifier = 0.5,
    max_sounds_per_type = 3
  },
  circuit_connector = wireDefinition,
  circuit_wire_max_distance = default_circuit_wire_max_distance,
}
---------------------------------------------------------------------------------------------------
data:extend{Entity, Recipe, Item, Remnants, Explosion}
---------------------------------------------------------------------------------------------------

-- COMPATIBILITY: Space Age DLC --
local heating_req = "55kW" -- vanilla: 100kW
SpaceAge.add_heating_requirement(entityName, heating_req)

---------------------------------------------------------------------------------------------------