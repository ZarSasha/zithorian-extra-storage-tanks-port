---------------------------------------------------------------------------------------------------
--  ┏┓┳┳┳┓┏┓┏┳┓┳┏┓┳┓┏┓
--  ┣ ┃┃┃┃┃  ┃ ┃┃┃┃┃┗┓
--  ┻ ┗┛┛┗┗┛ ┻ ┻┗┛┛┗┗┛
---------------------------------------------------------------------------------------------------
require("util") require("mod-data")
local sounds               = require "__base__.prototypes.entity.sounds"
local explosion_animations = require "__base__.prototypes.entity.explosion-animations"

-- |STANDARD FUNCTIONS| ---------------------------------------------------------------------------

-- Rounds a number with the desired level of precision.
function round_value(num, decimals)
    decimals = 10 ^ (decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num / decimals
end

-- |SPECIAL FUNCTIONS| ----------------------------------------------------------------------------

function create_graphics_sprite(Filepath, Width, Height, Frames, Shift)
  return {
    filename = Filepath,
    priority = "extra-high",
    width = Width,
    height = Height,
    scale = 0.5,
    frames = Frames,
    shift = Shift
  }
end

function create_shadow_sprite(Filepath, Width, Height, Frames, Shift, ShadowSpriteY)
  return {
    filename = Filepath,
    priority = "extra-high",
    y = ShadowSpriteY,
    width = Width,
    height = Height,
    scale = 0.5,
    frames = Frames,
    shift = Shift,
    draw_as_shadow = true
  }
end

function create_graphics_and_shadow_sheet(
  Filepath, Frames, GraphicsWidth, GraphicsHeight, GraphicsShift,
  ShadowWidth, ShadowHeight, ShadowShift, useShadow
  )
  if useShadow then
    return {
      create_graphics_sprite(Filepath, GraphicsWidth, GraphicsHeight, Frames, GraphicsShift),
      create_shadow_sprite(Filepath, ShadowWidth, ShadowHeight, Frames, ShadowShift, GraphicsHeight)
    }
  end
  return {create_graphics_sprite(Filepath, GraphicsWidth, GraphicsHeight, Frames, GraphicsShift) }
end

function create_window_background(useFluidWindow, scale)
  if(useFluidWindow) then
  return {
    filename = modName .. "/graphics/entity/" .. "window-background" .. ".png",
    priority = "extra-high",
    width = 20,
    height = 41,
    scale = scale,
    shift = util.by_pixel(0, -0.5)
  }
end 
  return util.empty_sprite()
end

function create_tall_window_background(useFluidWindow, scale)
  if(useFluidWindow) then
    return {
      filename = modName .. "/graphics/entity/" .. "tall-window-background" .. ".png",
      priority = "extra-high",
      width = 32,
      height = 132,
      scale = scale,
      shift = util.by_pixel(0, 0.5)
    }
  end 
  return util.empty_sprite()
end

function create_fluid(useFluidWindow, scale)
  if(useFluidWindow) then
    return {
      filename = "__base__/graphics/entity/storage-tank/fluid-background.png",
      priority = "extra-high",
      width = 32,
      height = 15,
      scale = scale
    }
  end 
  return util.empty_sprite()
end

function create_fluid_flow_sprite(useFluidWindow, scale)
  if(useFluidWindow) then
    return {
      filename = "__base__/graphics/entity/pipe/fluid-flow-low-temperature.png",
      priority = "extra-high",
      width = 160,
      height = 20,
      scale = scale
    }
  end 
  return util.empty_sprite()
end

function create_tall_fluid_flow_sprite(useFluidWindow, scale)
  if(useFluidWindow) then
    return {
      filename = modName .. "/graphics/entity/" .. "fluid-flow-low-temperature-extended.png",
      priority = "extra-high",
      width = 160,
      height = 20,
      scale = scale
    }
  end 
  return util.empty_sprite()
end

function create_gas_flow_sprite(useFluidWindow, scale)
  if(useFluidWindow) then
    return {
      filename = "__base__/graphics/entity/pipe/steam.png",
      priority = "extra-high",
      line_length = 10,
      width = 48,
      height = 30,
      frame_count = 60,
      axially_symmetrical = false,
      animation_speed = 0.25,
      direction_count = 1,
      scale = 0.5 * scale
    }
  end 
  return util.empty_sprite()
end

function create_wire(WireVariation, PixelX, PixelY, ShadowOffsetY)
  return {
    variation = WireVariation, main_offset = util.by_pixel(PixelX, PixelY),
    shadow_offset = util.by_pixel(PixelX, PixelY + ShadowOffsetY), show_shadow = false
  }
end

function create_four_way_universal_wire(wireVariation, PixelX, PixelY, ShadowPixelYOffset)
  local wireOffset = util.by_pixel(PixelX, PixelY)
  local wireShadowOffset = util.by_pixel(PixelX, PixelY + ShadowPixelYOffset)
  return circuit_connector_definitions.create_vector(universal_connector_template, {
    { variation = wireVariation, main_offset = wireOffset,
      shadow_offset = wireShadowOffset, show_shadow = false },
    { variation = wireVariation, main_offset = wireOffset,
      shadow_offset = wireShadowOffset, show_shadow = false },
    { variation = wireVariation, main_offset = wireOffset,
      shadow_offset = wireShadowOffset, show_shadow = false },
    { variation = wireVariation, main_offset = wireOffset,
      shadow_offset = wireShadowOffset, show_shadow = false }
  })
end

function create_remnants(EntityName, radius, pixel_shift)
  local x,y = table.unpack(pixel_shift)
  return {
    type = "corpse",
    name = EntityName .. "-remnants",
    icon = "__base__/graphics/icons/storage-tank.png",
    flags = {"placeable-neutral", "building-direction-8-way", "not-on-map"},
    hidden_in_factoriopedia = true,
    subgroup = "storage-remnants",
    order = "a-d-a",
    selection_box = {{-(radius), -(radius)}, {(radius), (radius)}},
    tile_width = radius * 2,
    tile_height = radius * 2,
    selectable_in_game = false,
    time_before_removed = 60 * 60 * 15, -- 15 minutes
    expires = false,
    final_render_layer = "remnants",
    remove_on_tile_placement = false,
    animation = make_rotated_animation_variations_from_sheet(1,
    {
      filename = "__base__/graphics/entity/storage-tank/remnants/storage-tank-remnants.png",
      line_length = 1,
      width = 426,
      height = 282,
      direction_count = 1,
      shift = util.by_pixel(x,y),
      scale = 0.5 * (radius / 1.5)
    })
  }
end

function create_scaled_explosion(EntityName, DebrisFactor, SpeedFactor)
    local expl = util.table.deepcopy(data.raw["explosion"]["storage-tank-explosion"])
    expl.name = EntityName .. "-explosion"
    expl.icon = modName.."/graphics/icons/"..EntityName..".png"
    local effects = expl.created_effect.action_delivery.target_effects
    for _, v in pairs(effects) do
        v["repeat_count"] = round_value(v["repeat_count"] * DebrisFactor)
        v["initial_vertical_speed"] = v["initial_vertical_speed"] * SpeedFactor
        v["initial_vertical_speed_deviation"] = v["initial_vertical_speed_deviation"] * SpeedFactor
        v["speed_from_center"] = v["speed_from_center"] * SpeedFactor
        v["speed_from_center_deviation"] = v["speed_from_center_deviation"] * SpeedFactor
    end
    return expl
end

-- |COMPATIBILITY: Space Age| ---------------------------------------------------------------------

SpaceAge = {}

--Add heating requirement (applicable to the planet Aquilo)
function SpaceAge.add_heating_requirement(EntityName, HeatingEnergy)
    if mods["space-age"] then
        local entity = data.raw["storage-tank"][EntityName]
        entity.heating_energy = HeatingEnergy
    end
end

---------------------------------------------------------------------------------------------------