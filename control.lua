---------------------------------------------------------------------------------------------------
--  ┏┓┏┓┳┓┏┳┓┳┓┏┓┓ 
--  ┃ ┃┃┃┃ ┃ ┣┫┃┃┃ 
--  ┗┛┗┛┛┗ ┻ ┛┗┗┛┗┛
---------------------------------------------------------------------------------------------------

-- 3x4 STORAGE TANK: SCRIPT TO PREVENT ROTATION --
function disable_rotation_function(event)
  if(event.entity.name == "fluid-tank-3x4") then
    reverseRotation = 
    (event.previous_direction == defines.direction.north and
    event.entity.direction == defines.direction.east) or
    (event.previous_direction == defines.direction.west and
    event.entity.direction == defines.direction.north) or 
    (event.previous_direction == defines.direction.south and
    event.entity.direction == defines.direction.west) or
    (event.previous_direction == defines.direction.east and
    event.entity.direction == defines.direction.south)
    event.entity.rotate({reverse = reverseRotation})
  end
end
  
script.on_event(defines.events.on_player_rotated_entity, disable_rotation_function)
---------------------------------------------------------------------------------------------------