function add_setting(Name, Value)
  data:extend({
    {
      type = "double-setting",
      name = Name,
      setting_type = "startup",
      minimum_value = 100,
      default_value = Value
    }
  })
end

add_setting("z-fluid-tank-volume-1x1",   3000)
add_setting("z-fluid-tank-volume-2x2",  12000)
add_setting("z-fluid-tank-volume-3x4",  72000)
add_setting("z-fluid-tank-volume-5x5", 150000)