---------------------------------------------------------------------------------------------------
--  ┏┓┳┓┏┳┓┳┏┳┓┓┏
--  ┣ ┃┃ ┃ ┃ ┃ ┗┫
--  ┗┛┛┗ ┻ ┻ ┻ ┗┛
---------------------------------------------------------------------------------------------------
require("util") require("functions")
local item_sounds = require("__base__.prototypes.item_sounds")
local sounds = require("__base__.prototypes.entity.sounds")
---------------------------------------------------------------------------------------------------
-- 3x4 STORAGE TANK --
---------------------------------------------------------------------------------------------------
local typeName   = "storage-tank"
local entityName = "fluid-tank-3x4"
local iconPath   = modName .. "/graphics/icons/" .. entityName .. ".png"


local centerX = 1.5
local centerY = 2

local graphicsPath   = modName .. "/graphics/entity/" .. entityName .. ".png"
local graphicsWidth  = 320
local graphicsHeight = 448

local shadowWidth  = 896 / 2
local shadowHeight = 64 * 5

local useShadow = true

local scale = 0.5

local boxLeft  = -1.5
local boxRight =  1.5
local boxDown  = -2.5
local boxUp    =  1.5

local collisionBoxOffset = 0.1
local box = { { boxLeft, boxDown }, { boxRight, boxUp } }
local collisionBox = {
    { boxLeft  + collisionBoxOffset, boxDown + collisionBoxOffset},
    { boxRight - collisionBoxOffset, boxUp   - collisionBoxOffset}
}

local remnantsRadius = 1.5 -- square, same center as entity.

local maxHealth   = 700
local fluidvolume = settings.startup["z-fluid-tank-volume-3x4"].value
local miningTime  = 0.75

local useFluidWindow   = true
local windowBox        = {{-0.2, -1.5 + 12 / 64}, {0.2, 0.5 + 14 / 64}}
local fluidWindowScale = 0.5
local fluidScale       = 1.2

local pipe_connections =
{
  {direction = defines.direction.north, position = {-1,-2}},
  {direction = defines.direction.north, position = { 1,-2}}
}

local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

local function create_dir_graphics(DirData)
  local shiftX = (DirData.GWidth / 2 - DirData.DirCenterX * 64) / 2
  local shiftY = (DirData.DirCenterY * 64 - DirData.GHeight / 2) / 2
  return {
    filename = graphicsPath,
    priority = "extra-high",
    x = DirData.GX,
    width = DirData.GWidth,
    height = DirData.GHeight,
    scale = scale,
    shift = util.by_pixel(shiftX, shiftY)
  }
end

local function create_dir_shadow(DirData)
  local shiftX = (DirData.SWidth / 2 - DirData.DirCenterX * 64) / 2
  local shiftY = ((DirData.DirCenterY + DirData.shadowBelowBottomShiftY) * 64 - DirData.SHeight / 2) / 2
  return {
  filename = graphicsPath,
  priority = "extra-high",
  x = DirData.SX,
  y = graphicsHeight,
  width = DirData.SWidth,
  height = DirData.SHeight,
  scale = scale,
  draw_as_shadow = true,
  shift = util.by_pixel(shiftX, shiftY)
}
end

local southData = { DirCenterX = 1.5, DirCenterY = 2.5, 
  GX = 0, 
  GWidth = graphicsWidth - 128,
  GHeight = graphicsHeight, 
  SX = 0, 
  SWidth = shadowWidth - 64 * 2, 
  SHeight = shadowHeight,
  shadowBelowBottomShiftY = 0.5}

local westData = { DirCenterX = 2.5, DirCenterY = 1.5, 
  GX = southData.GWidth, 
  GWidth = graphicsWidth - 64, 
  GHeight = graphicsHeight - 64, 
  SX = southData.SWidth, 
  SWidth = shadowWidth - 64, 
  SHeight = shadowHeight,
  shadowBelowBottomShiftY = 1.5}

local northData = {DirCenterX = 1.5, DirCenterY = 1.5, 
  GX = westData.GX + westData.GWidth,
  GWidth = graphicsWidth - 128, 
  GHeight = graphicsHeight - 64, 
  SX = westData.SX + westData.SWidth, 
  SWidth = shadowWidth - 64 * 2, 
  SHeight = shadowHeight,
  shadowBelowBottomShiftY = 1.5}

local eastData = { DirCenterX = 1.5, DirCenterY = 1.5, 
  GX = northData.GX + northData.GWidth, 
  GWidth = graphicsWidth - 64, 
  GHeight = graphicsHeight - 64, 
  SX = northData.SX + northData.SWidth, 
  SWidth = shadowWidth - 64, 
  SHeight = shadowHeight,
  shadowBelowBottomShiftY = 1.5}

local Recipe = {
  type = "recipe",
  name = entityName,
  enabled = false,
  energy_required = 7.5,
  ingredients = {
    {type = "item", name = "iron-plate",  amount = 24},
    {type = "item", name = "steel-plate", amount = 12}
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
  stack_size = 20,
  weight = 50*kg
}

local function GetDirectionFromData(DirData)
  if(useShadow) then
  return { layers = { create_dir_graphics(DirData), create_dir_shadow(DirData) } }
  end
  return { layers = { create_dir_graphics(DirData) } }
end

local wireDefinition = circuit_connector_definitions.create_vector
(universal_connector_template,
  {
    create_wire(25, -27.5,  -3.5,  0),
    create_wire( 2,  64.5, -39.5, 12),
    create_wire( 0,  28.5,  48.5,  0),
    create_wire( 6, -64.5,  13.5,  0)
  }
)

local Remnants = create_remnants(entityName, remnantsRadius, {27, 21})

local Explosion = create_scaled_explosion(entityName, 1.8, 1.05)

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
  drawing_box_vertical_extension = 2.15,
  icon_draw_specification = {scale = 1.5, shift = {0, -0.75}},
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
  tile_width = 3,
  tile_height = 3,
  pictures =
  {
    picture = {
      south = GetDirectionFromData(southData),
      west  = GetDirectionFromData(westData ),
      north = GetDirectionFromData(northData),
      east  = GetDirectionFromData(eastData )
    },
    window_background = create_tall_window_background(useFluidWindow, fluidWindowScale),
    fluid_background  = create_fluid(useFluidWindow, fluidScale),
    flow_sprite = create_tall_fluid_flow_sprite(useFluidWindow, fluidScale*0.833),
    gas_flow = create_gas_flow_sprite(useFluidWindow, fluidScale)
  },
  flow_length_in_ticks = 1410*0.833, -- should match the Storage Tank
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
local heating_req = "180kW" -- vanilla: 100kW
SpaceAge.add_heating_requirement(entityName, heating_req)

---------------------------------------------------------------------------------------------------