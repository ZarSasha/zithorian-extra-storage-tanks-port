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
-- 1x1 STORAGE TANK --
---------------------------------------------------------------------------------------------------
local typeName   = "storage-tank"
local entityName = "fluid-tank-1x1"
local iconPath   = modName .. "/graphics/icons/" .. entityName .. ".png"

local centerX = 0.5
local centerY = 0.5

local graphicsPath   = modName .. "/graphics/entity/" .. entityName .. ".png"
local graphicsWidth  = 64
local graphicsHeight = 192
local graphicsShiftX = (centerX * 64 - graphicsWidth / 2) / 2
local graphicsShiftY = (centerY * 64 - graphicsHeight / 2) / 2

local shadowBelowBottomShiftY = 0.5

local shadowWidth  = 160
local shadowHeight = 128
local shadowShiftX = (shadowWidth / 2 - centerX * 64) / 2
local shadowShiftY = ((centerY + shadowBelowBottomShiftY) * 64 - shadowHeight / 2) / 2
local useShadow = true

local frames = 1

local boxLeft  = -0.5
local boxRight =  0.5
local boxDown  = -0.5
local boxUp    =  0.5

local collisionBoxOffset = 0.1
local box = { { boxLeft, boxDown }, { boxRight, boxUp } }
local collisionBox = {
    { boxLeft  + collisionBoxOffset, boxDown + collisionBoxOffset},
    { boxRight - collisionBoxOffset, boxUp   - collisionBoxOffset}
}

local remnantsRadius = 0.5 -- square, same center as entity.

local maxHealth   = 300
local fluidvolume = settings.startup["z-fluid-tank-volume-1x1"].value
local miningTime  = 0.125

local useFluidWindow   = true
local windowBox        =  {{-0.1, -1.5 + 30 / 64}, {0.1, 0.5 - 46 / 64}}
local fluidWindowScale = 0.8
local fluidScale       = 0.8

local pipe_connections =
{
  { direction = defines.direction.north, position = {0, 0} },
  { direction = defines.direction.east,  position = {0, 0} },
  { direction = defines.direction.south, position = {0, 0} },
  { direction = defines.direction.west,  position = {0, 0} }
}

local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

local Recipe = {
  type = "recipe",
  name = entityName,
  enabled = false,
  energy_required = 1.5,
  ingredients = {
    {type = "item", name = "iron-plate",  amount = 5},
    {type = "item", name = "steel-plate", amount = 1}
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
  inventory_move_sound = item_sounds.metal_small_inventory_move,
  pick_sound = item_sounds.metal_small_inventory_pickup,
  drop_sound = item_sounds.metal_small_inventory_move,
  place_result = entityName,
  stack_size = 50,
  weight = 10*kg
}

local wireDefinition = create_four_way_universal_wire(26, 7, -5, 2)

local Remnants = create_remnants(entityName, remnantsRadius, {9, 6})

local Explosion = create_scaled_explosion(entityName, 0.5, 0.825)
Explosion.animations = explosion_animations.small_explosion()
Explosion.sound = sounds.small_explosion

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
  drawing_box_vertical_extension = 1.35,
  icon_draw_specification = {scale = 0.75, shift = {0, -0.33}},
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
    flow_sprite = create_fluid_flow_sprite(useFluidWindow, (fluidScale*1.25)), -- quick fix
    gas_flow = create_gas_flow_sprite(useFluidWindow, fluidScale)
  },
  flow_length_in_ticks = 460*1.25, -- should match the Storage Tank
  fast_replaceable_group = "pipe",
  impact_category = "metal",
  open_sound = sounds.metal_small_open,
  close_sound = sounds.metal_small_close,
  working_sound =
  {
    sound =
    {
        filename = "__base__/sound/storage-tank.ogg",
        volume = 0.4
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
local heating_req = "25kW" -- vanilla: 100kW
SpaceAge.add_heating_requirement(entityName, heating_req)

---------------------------------------------------------------------------------------------------