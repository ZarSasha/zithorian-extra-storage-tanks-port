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
-- 5x5 STORAGE TANK --
---------------------------------------------------------------------------------------------------
local typeName   = "storage-tank"
local entityName = "fluid-tank-5x5"
local iconPath   = modName .. "/graphics/icons/" .. entityName .. ".png"

local centerX = 2.5
local centerY = 2.5

local graphicsPath   = modName .. "/graphics/entity/" .. entityName .. ".png"
local graphicsWidth  = 320
local graphicsHeight = 384
local graphicsShiftX = (centerX * 64 - graphicsWidth / 2) / 2
local graphicsShiftY = (centerY * 64 - graphicsHeight / 2) / 2

local shadowBelowBottomShiftY = 1.0

local shadowWidth  = 384
local shadowHeight = 352
local shadowShiftX = (shadowWidth / 2 - centerX * 64) / 2
local shadowShiftY = ((centerY + shadowBelowBottomShiftY) * 64 - shadowHeight / 2) / 2 - 16
local useShadow = true

local frames = 1

local boxLeft  = -2.5
local boxRight =  2.5
local boxDown  = -2.5
local boxUp    =  2.5

local collisionBoxOffset = 0.1
local box = { { boxLeft, boxDown }, { boxRight, boxUp } }
local collisionBox = {
    { boxLeft  + collisionBoxOffset, boxDown + collisionBoxOffset},
    { boxRight - collisionBoxOffset, boxUp   - collisionBoxOffset}
}

local remnantsRadius = 2.5 -- square, same center as entity.

local maxHealth   = 900
local fluidvolume = settings.startup["z-fluid-tank-volume-5x5"].value
local miningTime  = 1.0

local useFluidWindow   = true
local windowBox        =  {{-0.2, 0.5 + 24 / 64}, {0.2, 2.5 - 41 / 64}}
local fluidWindowScale = 0.8
local fluidScale       = 1.2

local pipe_connections =
{
  { direction = defines.direction.north, position = {-2, -2} },
  { direction = defines.direction.north, position = { 2, -2} },
  { direction = defines.direction.east,  position = { 2, -2} },
  { direction = defines.direction.east,  position = { 2,  2} },
  { direction = defines.direction.south, position = { 2,  2} },
  { direction = defines.direction.south, position = {-2,  2} },
  { direction = defines.direction.west,  position = {-2,  2} },
  { direction = defines.direction.west,  position = {-2, -2} }
}

local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

local Recipe = {
  type = "recipe",
  name = entityName,
  enabled = false,
  energy_required = 10,
  ingredients = {
    {type = "item", name = "iron-plate",  amount = 40},
    {type = "item", name = "steel-plate", amount = 20}
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
  stack_size = 10,
  weight = 100*kg
}

local wireDefinition = create_four_way_universal_wire(25, -61.5, 33.5, 12)

local Remnants = create_remnants(entityName, remnantsRadius, {43, 32})

local Explosion = create_scaled_explosion(entityName, 3, 1.1)
Explosion.height = 1
Explosion.animations = explosion_animations.big_explosion()

local Entity = {
  type = typeName,
  name = entityName,
  icon = iconPath,
  icon_size = 64, icon_mipmaps = 4,
  flags = {"placeable-player", "player-creation", "not-rotatable"},
  minable = {mining_time = miningTime, result = entityName},
  max_health = maxHealth,
  corpse = entityName .. "-remnants",
  dying_explosion = entityName .. "-explosion",
  collision_box = collisionBox,
  selection_box = box,
  icon_draw_specification = {scale = 2, shift = {0, -0.25}},
  damaged_trigger_effect = hit_effects.entity(),
  fluid_box =
  {
    volume = fluidvolume,
    pipe_covers = pipecoverspictures(),
    pipe_connections = pipe_connections,
    hide_connection_info = true
  },
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
    flow_sprite = create_fluid_flow_sprite(useFluidWindow, fluidScale*0.833), -- quick fix
    gas_flow = create_gas_flow_sprite(useFluidWindow, fluidScale)
  },
  flow_length_in_ticks = 690*0.833, -- should match the Storage Tank
  impact_category = "metal-large",
  open_sound = sounds.metal_large_open,
  close_sound = sounds.metal_large_close,
  working_sound =
  {
    sound =
    {
        filename = "__base__/sound/storage-tank.ogg",
        volume = 0.6
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
local heating_req = "300kW" -- vanilla: 100kW
SpaceAge.add_heating_requirement(entityName, heating_req)

---------------------------------------------------------------------------------------------------