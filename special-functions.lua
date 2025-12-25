---------------------------------------------------------------------------------------------------
--  ┏┓┳┳┳┓┏┓┏┳┓┳┏┓┳┓┏┓
--  ┣ ┃┃┃┃┃  ┃ ┃┃┃┃┃┗┓
--  ┻ ┗┛┛┗┗┛ ┻ ┻┗┛┛┗┗┛                                            
---------------------------------------------------------------------------------------------------
require "util"
require "shared"
local std_func             = require "standard-functions"
local sounds               = require "__base__.prototypes.entity.sounds"
local hit_effects          = require "__base__.prototypes.entity.hit-effects"
local item_sounds          = require "__base__.prototypes.item_sounds"
local explosion_animations = require "__base__.prototypes.entity.explosion-animations"
---------------------------------------------------------------------------------------------------
-- SPECIAL FUNCTIONS
---------------------------------------------------------------------------------------------------
local special_functions = {}
---------------------------------------------------------------------------------------------------
    -- ENTITY PROTOTYPE CREATION
---------------------------------------------------------------------------------------------------

-- BOUNDING BOXES --

-- Automatically creates a collision box from the selection box and an offset value.
local function create_collision_box(Info)
    local BoundingBox     = Info.BoundingBox     -- 2x2 number array
    local CollisionOffset = Info.CollisionOffset -- number
    return {
        {BoundingBox[1][1] - CollisionOffset, BoundingBox[1][2] - CollisionOffset},
        {BoundingBox[2][1] + CollisionOffset, BoundingBox[2][2] + CollisionOffset}
    }
end

-- WIRE CONNECTIONS --

-- Creates a single wire connection for a single orientation, for use in a set.
local function create_single_wire_connection_for_set(Wire) -- number array
    local WireVariation, PixelX, PixelY, ShadowPixelOffsetY = table.unpack(Wire)
    return {
        variation     = WireVariation,
        main_offset   = util.by_pixel(PixelX, PixelY),
        shadow_offset = util.by_pixel(PixelX, PixelY + ShadowPixelOffsetY),
        show_shadow   = false
    }
end

-- Creates a full set of individually configured wire connections for each orientation.
special_functions.create_four_different_wire_connections = function(
    WireNorth, WireEast, WireSouth, WireWest -- number arrays
)
    return circuit_connector_definitions.create_vector(
        universal_connector_template, {
        create_single_wire_connection_for_set(WireNorth),
        create_single_wire_connection_for_set(WireEast ),
        create_single_wire_connection_for_set(WireSouth),
        create_single_wire_connection_for_set(WireWest )
    })
end

-- Creates a full set of identical wire connections for all orientations.
special_functions.create_four_identical_wire_connections = function(Wire) -- number array
    local Connection = create_single_wire_connection_for_set(Wire)
    local ConnectionSet = {Connection, Connection, Connection, Connection}
    return circuit_connector_definitions.create_vector(
        universal_connector_template, ConnectionSet
    )
end

-- GRAPHICS ---------------------------------------------------------------------------------------

-- Creates a table with two subtables containing entity and shadows graphics.
special_functions.create_entity_graphics_and_shadow = function(EntityName, Info)
    local Scale        = Info.Scale or 0.5 -- number
    local Frames       = Info.Frames       -- number
    local EntityWidth  = Info.EntityWidth  -- number
    local EntityHeight = Info.EntityHeight -- number
    local EntityShift  = Info.EntityShift  -- number array (can use util.by_pixel)
    local ShadowWidth  = Info.ShadowWidth  -- number
    local ShadowHeight = Info.ShadowHeight -- number
    local ShadowShift  = Info.ShadowShift  -- number array (can use util.by_pixel)
    return {{
        filename       = GRAPHICS_PATH .. EntityName .. ".png",
        priority       = "extra-high",
        scale          = Scale,
        frames         = Frames,
        width          = EntityWidth,
        height         = EntityHeight,
        shift          = EntityShift
    },{
        filename       = GRAPHICS_PATH .. EntityName .. ".png",
        priority       = "extra-high",
        scale          = Scale,
        frames         = Frames,
        y              = EntityHeight, -- Placed right below entity graphics
        width          = ShadowWidth,
        height         = ShadowHeight,
        shift          = ShadowShift,
        draw_as_shadow = true
    }}
end

-- Creates window background graphics.
local function create_window_background(Info)
    if Info.WindowIsTall then return {
        filename = GRAPHICS_PATH .. "tall-window-background" .. ".png",
        priority = "extra-high",
        width    =  32,
        height   = 132,
        scale    = Info.Scale,
        shift    = util.by_pixel(0, 0.5)
    }
    else return {
        filename = GRAPHICS_PATH .. "window-background" .. ".png",
        priority = "extra-high",
        width    =  20,
        height   =  41,
        scale    = Info.Scale,
        shift    = util.by_pixel(0, -0.5)
    } end
end

-- Creates fluid background graphics.
local function create_fluid_background(Info)
    return {
        filename = "__base__/graphics/entity/storage-tank/fluid-background.png",
        priority = "extra-high",
        width    =  32,
        height   =  15,
        scale    = Info.Scale
    }
end

-- Creates flow graphics.
local function create_flow_sprite(Info)
    if Info.WindowIsTall then return {
        filename = GRAPHICS_PATH .. "fluid-flow-low-temperature-extended.png",
        priority = "extra-high",
        width    = 160,
        height   =  20,
        scale    = Info.Scale
    }
    else return {
        filename = "__base__/graphics/entity/pipe/fluid-flow-low-temperature.png",
        priority = "extra-high",
        width    = 160,
        height   =  20,
        scale    = Info.Scale
    } end
end

-- Creates gas flow graphics.
local function create_gas_flow_sprite(Info)
    return {
        filename            = GRAPHICS_PATH .. "steam-narrowed-cropped.png",
        priority            = "extra-high",
        line_length         = 10,
        width               = 24, -- compressed to half (min. 20 needed)
        height              = 28, -- trimmed 2 pixels
        frame_count         = 60,
        axially_symmetrical = false,
        animation_speed     = 0.25,
        direction_count     = 1,
        scale               = Info.Scale
    }
end

-- ENTITY PROTOTYPE CREATION --

-- Creates the final entity prototype table to be added to database.
special_functions.create_entity = function(EntityName, Info)
    -- Dictionary:
    local sound_sizes   = {
        ["small"]  = {"metal",       sounds.metal_small_open, sounds.metal_small_close},
        ["large"]  = {"metal-large", sounds.metal_large_open, sounds.metal_large_close}
    }
    -- Main table:
    local entity = {
        type = "storage-tank",
        name = EntityName,
        icon = ICON_PATH .. EntityName .. ".png",
        flags = {"placeable-player", "player-creation"},
        minable = {
            mining_time = Info.MiningTime,
            result = EntityName
        },
        fast_replaceable_group = Info.FastReplaceGroup,
        max_health = Info.Health,
        dying_explosion = EntityName .. "-explosion",
        corpse = EntityName .. "-remnants",
        selection_box = Info.SelectionBox,
        collision_box = create_collision_box({
            BoundingBox     = Info.SelectionBox,
            CollisionOffset = Info.CollisionOffset
        }),
        tile_height = Info.TileHeight,
        drawing_box_vertical_extension = Info.DrawBoxVertExt,
        icon_draw_specification = Info.IconDrawSpec,
        fluid_box = {
            volume = settings.startup[EntityName.."-volume-setting"].value,
            pipe_covers = pipecoverspictures(),
            pipe_connections = Info.PipeConnections,
            hide_connection_Info = true
        },
        window_bounding_box = Info.WindowBox,
        pictures = {
            picture = {
                sheets = Info.EntitySprites
            },
            window_background = create_window_background({
                WindowIsTall    = Info.WindowIsTall,
                Scale           = Info.WindowScale
            }),
            fluid_background  = create_fluid_background({
                Scale           = Info.FluidScale
            }),
            flow_sprite       = create_flow_sprite({
                WindowIsTall    = Info.WindowIsTall,
                Scale           = Info.FluidFlowScale
            }),
            gas_flow          = create_gas_flow_sprite({
                Scale           = Info.FluidScale
            })
        },
        flow_length_in_ticks = Info.FluidFlowLength,
        damaged_trigger_effect = hit_effects.entity(),
        impact_category = sound_sizes[Info.SoundSizeCategory][1],
        open_sound = sound_sizes[Info.SoundSizeCategory][2],
        close_sound = sound_sizes[Info.SoundSizeCategory][3],
        working_sound = {
            sound = {
                filename = "__base__/sound/storage-tank.ogg",
                volume = Info.SoundVolume,
                audible_distance_modifier = 0.5
            },
            match_volume_to_activity = true,
            max_sounds_per_prototype = 3
        },
        circuit_connector = Info.WireConnections,
        circuit_wire_max_distance = default_circuit_wire_max_distance,
    }
    -- COMPATIBILITY for Space Age DLC: Adds heating requirement on Aquilo.
    if SPACE_AGE.IsPresent then entity.heating_energy = Info.HeatingEnergy end
    return entity
end

---------------------------------------------------------------------------------------------------
    -- ITEM PROTOTYPE CREATION
---------------------------------------------------------------------------------------------------
special_functions.create_item = function(EntityName, Info)
    local SoundSizeCat = Info.SoundSizeCat -- string: "small" or "large"
    local StackSize    = Info.StackSize    -- number
    local Weight       = Info.Weight       -- number
    return {
        type = "item",
        name = EntityName,
        icon = ICON_PATH .. EntityName .. ".png",
        icon_size = 64, icon_mipmaps = 4, -- remove mipmaps
        subgroup = "storage",
        order = "bc",
        inventory_move_sound = item_sounds["metal-"..SoundSizeCat.."-inventory_move"],
        pick_sound = item_sounds["metal-"..SoundSizeCat.."-inventory_pickup"],
        drop_sound = item_sounds["metal-"..SoundSizeCat.."-inventory_move"],
        place_result = EntityName,
        stack_size = StackSize,
        weight = Weight*kg
    }
end

---------------------------------------------------------------------------------------------------
    -- RECIPE PROTOTYPE CREATION
---------------------------------------------------------------------------------------------------
special_functions.create_recipe = function(EntityName, Info)
    local EnergyNeed  = Info.EnergyNeed  -- number
    local IronPlates  = Info.IronPlates  -- number
    local SteelPlates = Info.SteelPlates -- number
    return {
        type = "recipe",
        name = EntityName,
        enabled = false,
        energy_required = EnergyNeed,
        ingredients = {
            {type = "item", name = "iron-plate",  amount =  IronPlates},
            {type = "item", name = "steel-plate", amount = SteelPlates}
        },
        results = {
            {type = "item", name = EntityName, amount = 1}
        }
    }
end

---------------------------------------------------------------------------------------------------
    -- EXPLOSION PROTOTYPE CREATION
---------------------------------------------------------------------------------------------------
special_functions.create_explosion = function(EntityName, Info)
    local SoundSizeCat  = Info.SoundSizeCat     -- string: "small", "medium" or "large"
    local SoundVolMin   = Info.SoundVolMin or 1 -- number
    local SoundVolMax   = Info.SoundVolMax or 1 -- number
    local AnimSizeCat   = Info.AnimSizeCat      -- string: "small", "medium" "big" or "massive"
    local AnimScale     = Info.AnimScale or 1   -- number
    local AnimHeight    = Info.AnimHeight or 0  -- number
    local DebrisAmountX = Info.DebrisAmountX    -- number
    local DebrisSpeedX  = Info.DebrisSpeedX     -- number

    local sound_sizes   = {
        ["small"]  = sounds.small_explosion,
        ["medium"] = sounds.medium_explosion,
        ["large"]  = sounds.large_explosion(SoundVolMin, SoundVolMax)
    }
    local anim_sizes  = {
        ["small"]  = explosion_animations.small_explosion(AnimScale),
        ["medium"] = explosion_animations.medium_explosion(AnimScale),
        ["big"]    = explosion_animations.big_explosion(AnimScale)
    }
    ---@diagnostic disable-next-line: undefined-field
    local explosion = table.deepcopy(data.raw["explosion"]["storage-tank-explosion"])
    explosion.name = EntityName .. "-explosion"
    explosion.icon = ICON_PATH .. EntityName .. ".png"
    explosion.animations = anim_sizes[AnimSizeCat]
    explosion.height = AnimHeight
    explosion.sound = sound_sizes[SoundSizeCat]
    local effects = explosion.created_effect.action_delivery.target_effects
    for _, effect in pairs(effects) do
        effect["repeat_count"] =
            std_func.round_number(effect["repeat_count"] * DebrisAmountX)
        effect["initial_vertical_speed"] =
            effect["initial_vertical_speed"] * DebrisSpeedX
        effect["initial_vertical_speed_deviation"] =
            effect["initial_vertical_speed_deviation"] * DebrisSpeedX
        effect["speed_from_center"] =
            effect["speed_from_center"] * DebrisSpeedX
        effect["speed_from_center_deviation"] =
            effect["speed_from_center_deviation"] * DebrisSpeedX
    end
    return explosion
end

---------------------------------------------------------------------------------------------------
    -- REMNANTS PROTOTYPE CREATION
---------------------------------------------------------------------------------------------------
special_functions.create_remnants = function(EntityName, Info)
    local TileRadius = Info.TileRadius or 1.5    -- number
    local PixelShift = Info.PixelShift or {0, 0} -- number array
    local x,y  = table.unpack(PixelShift)
    return {
        type = "corpse",
        name = EntityName .. "-remnants",
        icon = "__base__/graphics/icons/storage-tank.png",
        flags = {"placeable-neutral", "building-direction-8-way", "not-on-map"},
        hidden_in_factoriopedia = true,
        subgroup = "storage-remnants",
        order = "a-d-a",
        selection_box = {{-(TileRadius), -(TileRadius)}, {(TileRadius), (TileRadius)}},
        tile_width = TileRadius * 2,
        tile_height = TileRadius * 2,
        selectable_in_game = false,
        time_before_removed = 60 * 60 * 15, -- 15 minutes
        expires = false,
        final_render_layer = "remnants",
        remove_on_tile_placement = false,
        animation = make_rotated_animation_variations_from_sheet(1, {
            filename = "__base__/graphics/entity/storage-tank/remnants/storage-tank-remnants.png",
            line_length = 1,
            width = 426,
            height = 282,
            direction_count = 1,
            shift = util.by_pixel(x,y),
            scale = 0.5 * (TileRadius / 1.5)
        })
    }
end

---------------------------------------------------------------------------------------------------
return special_functions
---------------------------------------------------------------------------------------------------