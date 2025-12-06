---------------------------------------------------------------------------------------------------
--  ┏┓┏┓┳┓┏┳┓┳┓┏┓┓ 
--  ┃ ┃┃┃┃ ┃ ┣┫┃┃┃   -- RUNTIME STAGE
--  ┗┛┗┛┛┗ ┻ ┛┗┗┛┗┛
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- SCRIPT TO PREVENT ROTATION OF 3x4 STORAGE TANK --
---------------------------------------------------------------------------------------------------
-- Normal rotation can cause the storage tank to overlap with nearby entities, due to its unequal
-- side lengths. This script prevents rotation without making problematic changes to the prototype
-- itself. Performance cost seems neglible.

local function disable_rotation_of_entity(event)
    if string.find(event.entity.name, "zith-storage-tank-3x4", 1, true) then
        local reverseRotation =
            (event.previous_direction == defines.direction.north and
             event.entity.direction   == defines.direction.east)  or
            (event.previous_direction == defines.direction.west  and
             event.entity.direction   == defines.direction.north) or
            (event.previous_direction == defines.direction.south and
             event.entity.direction   == defines.direction.west)  or
            (event.previous_direction == defines.direction.east  and
             event.entity.direction   == defines.direction.south)
        event.entity.rotate({reverse = reverseRotation})
    end
end

script.on_event(defines.events.on_player_rotated_entity, disable_rotation_of_entity)

---------------------------------------------------------------------------------------------------
-- END NOTES
---------------------------------------------------------------------------------------------------