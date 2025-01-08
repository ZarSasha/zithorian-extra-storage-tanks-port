---------------------------------------------------------------------------------------------------
--  ┳┳┓┏┓┳┓  ┳┓┏┓┏┳┓┏┓
--  ┃┃┃┃┃┃┃━━┃┃┣┫ ┃ ┣┫
--  ┛ ┗┗┛┻┛  ┻┛┛┗ ┻ ┛┗
---------------------------------------------------------------------------------------------------
modName = "__zithorian-extra-storage-tanks-port__"
  
local function GetFluidWindowBackground()
  if(useFluidBackground) then
    return {
      filename = modName .. "/graphics/entity/" .. "window-background" .. ".png",
      priority = "extra-high",
      width = 20,
      height = 41,
      scale = scale * fluidWindowBackgroundScale,
      shift = util.by_pixel(0, -0.5)
    }
  end 
  return util.empty_sprite()
end
  
local function GetFluidBackground()
  if(useFluidBackground) then
    return {
      filename = "__base__/graphics/entity/storage-tank/fluid-background.png",
      priority = "extra-high",
      width = 32,
      height = 15,
      scale = 0.8
    }
  end 
  return util.empty_sprite()
end
  
local function GetFlowSprite()
  if(useFluidBackground) then
    return {
      filename = "__base__/graphics/entity/pipe/fluid-flow-low-temperature.png",
      priority = "extra-high",
      width = 160,
      height = 20,
      scale = 0.8
    }
  end 
  return util.empty_sprite()
end
  
local function GetGasFlowSprite()
  if(useFluidBackground) then
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
      scale = 0.5
    }
  end 
  return util.empty_sprite()
end
---------------------------------------------------------------------------------------------------