--==============================================================================
--                           prayer_ring.lua
--
--  Prayer time ring for Conky
--  Requires: prayer-times CLI (https://github.com/yourusername/prayer-times)
--
--==============================================================================

require 'cairo'

--------------------------------------------------------------------------------
--                                                              PRAYER RING DATA
--------------------------------------------------------------------------------

-- Prayer progress ring configuration
prayer_ring = {
    name='execi',
    arg='60 prayer --progress',
    max_value=100,
    x=125,                          -- center X (adjust to your clock)
    y=110,                          -- center Y (adjust to your clock)
    graph_radius=43,
    graph_thickness=4,
    graph_start_angle=0,
    graph_unit_angle=3.6,
    graph_unit_thickness=3.6,
    graph_bg_colour=0x00FF00,
    graph_bg_alpha=0.1,
    graph_fg_colour=0x00FF00,
    graph_fg_alpha=0.7,
}

-- Prayer text configuration
prayer_text = {
    x=125,                          -- center X
    y=110,                          -- center Y
    name_offset_y=25,               -- offset for prayer name
    time_offset_y=38,               -- offset for remaining time
    name_size=10,
    time_size=8,
    name_colour={0, 1, 0, 0.9},     -- RGBA (green)
    time_colour={1, 1, 1, 0.7},     -- RGBA (white)
}

--------------------------------------------------------------------------------
--                                                                 rgb_to_r_g_b
--------------------------------------------------------------------------------
function rgb_to_r_g_b(colour, alpha)
    return ((colour / 0x10000) % 0x100) / 255.,
           ((colour / 0x100) % 0x100) / 255.,
           (colour % 0x100) / 255.,
           alpha
end

--------------------------------------------------------------------------------
--                                                            angle_to_position
--------------------------------------------------------------------------------
function angle_to_position(start_angle, current_angle)
    local pos = current_angle + start_angle
    return ((pos * (2 * math.pi / 360)) - (math.pi / 2))
end

--------------------------------------------------------------------------------
--                                                            draw_prayer_ring
-- Draws a circular progress ring showing time until next prayer
--------------------------------------------------------------------------------
function draw_prayer_ring(display)
    local data = prayer_ring
    
    -- Parse progress value from conky
    local str = string.format('${%s %s}', data.name, data.arg)
    str = conky_parse(str)
    local value = tonumber(str) or 0
    
    local max_value = data.max_value
    local x, y = data.x, data.y
    local graph_radius = data.graph_radius
    local graph_thickness = data.graph_thickness
    local graph_start_angle = data.graph_start_angle or 0
    local graph_unit_angle = data.graph_unit_angle
    local graph_unit_thickness = data.graph_unit_thickness
    local graph_bg_colour = data.graph_bg_colour
    local graph_bg_alpha = data.graph_bg_alpha
    local graph_fg_colour = data.graph_fg_colour
    local graph_fg_alpha = data.graph_fg_alpha
    local graph_end_angle = (max_value * graph_unit_angle) % 360

    -- Background ring
    cairo_arc(display, x, y, graph_radius,
        angle_to_position(graph_start_angle, 0),
        angle_to_position(graph_start_angle, graph_end_angle))
    cairo_set_source_rgba(display, rgb_to_r_g_b(graph_bg_colour, graph_bg_alpha))
    cairo_set_line_width(display, graph_thickness)
    cairo_stroke(display)

    -- Progress arc
    local val = value % (max_value + 1)
    local i = 1
    while i <= val do
        local start_arc = (graph_unit_angle * i) - graph_unit_thickness
        local stop_arc = (graph_unit_angle * i)
        cairo_arc(display, x, y, graph_radius,
            angle_to_position(graph_start_angle, start_arc),
            angle_to_position(graph_start_angle, stop_arc))
        cairo_set_source_rgba(display, rgb_to_r_g_b(graph_fg_colour, graph_fg_alpha))
        cairo_stroke(display)
        i = i + 1
    end
end

--------------------------------------------------------------------------------
--                                                            draw_prayer_text
-- Draws prayer name and remaining time in the center
--------------------------------------------------------------------------------
function draw_prayer_text(display)
    local cfg = prayer_text
    
    -- Get prayer info
    local prayer_name = conky_parse('${execi 60 prayer --name}') or ""
    local time_remaining = conky_parse('${execi 60 prayer --remaining}') or ""
    
    -- Draw prayer name
    cairo_select_font_face(display, "Open Sans", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD)
    cairo_set_font_size(display, cfg.name_size)
    cairo_set_source_rgba(display, cfg.name_colour[1], cfg.name_colour[2], cfg.name_colour[3], cfg.name_colour[4])
    
    -- Center the text
    local extents = cairo_text_extents_t:create()
    tolua.takeownership(extents)
    cairo_text_extents(display, prayer_name, extents)
    cairo_move_to(display, cfg.x - (extents.width / 2), cfg.y + cfg.name_offset_y)
    cairo_show_text(display, prayer_name)
    cairo_stroke(display)
    
    -- Draw remaining time
    cairo_select_font_face(display, "Open Sans", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
    cairo_set_font_size(display, cfg.time_size)
    cairo_set_source_rgba(display, cfg.time_colour[1], cfg.time_colour[2], cfg.time_colour[3], cfg.time_colour[4])
    
    cairo_text_extents(display, time_remaining, extents)
    cairo_move_to(display, cfg.x - (extents.width / 2), cfg.y + cfg.time_offset_y)
    cairo_show_text(display, time_remaining)
    cairo_stroke(display)
end

--------------------------------------------------------------------------------
--                                                              conky_prayer
-- Main function to call from conky
-- Add to your lua_draw_hook_post: conky_prayer
--------------------------------------------------------------------------------
function conky_prayer()
    if conky_window == nil then
        return
    end

    local cs = cairo_xlib_surface_create(
        conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height
    )
    local display = cairo_create(cs)

    local updates = conky_parse('${updates}')
    local update_num = tonumber(updates)

    if update_num > 5 then
        draw_prayer_ring(display)
        draw_prayer_text(display)
    end

    cairo_surface_destroy(cs)
    cairo_destroy(display)
end
