# Conky Integration

This directory contains examples for integrating prayer times with Conky.

## Simple Text Integration

Add to your `.conkyrc` text section:

```lua
${voffset 15}
${goto 50}${font Open Sans:bold:size=13}${color}Prayer
${goto 50}${font Open Sans:normal:size=9}${color1}${execi 60 prayer}
```

Or show more details:

```lua
${voffset 15}
${goto 50}${font Open Sans:bold:size=13}${color}Prayer Times
${goto 50}${font Open Sans:bold:size=9}${color}Next${alignr 50}${font Open Sans:normal:size=9}${color1}${execi 60 prayer --name} (${execi 60 prayer --remaining})
${goto 50}${font Open Sans:bold:size=9}${color}Fajr${alignr 50}${font Open Sans:normal:size=9}${color1}${execi 3600 prayer --json | jq -r '.all_prayers.Fajr'}
${goto 50}${font Open Sans:bold:size=9}${color}Dhuhr${alignr 50}${font Open Sans:normal:size=9}${color1}${execi 3600 prayer --json | jq -r '.all_prayers.Dhuhr'}
${goto 50}${font Open Sans:bold:size=9}${color}Asr${alignr 50}${font Open Sans:normal:size=9}${color1}${execi 3600 prayer --json | jq -r '.all_prayers.Asr'}
${goto 50}${font Open Sans:bold:size=9}${color}Maghrib${alignr 50}${font Open Sans:normal:size=9}${color1}${execi 3600 prayer --json | jq -r '.all_prayers.Maghrib'}
${goto 50}${font Open Sans:bold:size=9}${color}Isha${alignr 50}${font Open Sans:normal:size=9}${color1}${execi 3600 prayer --json | jq -r '.all_prayers.Isha'}
```

## Visual Ring Integration

For a visual progress ring (like the clock), use `prayer_ring.lua`.

### Setup

1. Copy `prayer_ring.lua` to your conky directory:

```bash
cp prayer_ring.lua ~/.config/conky/
```

2. Add to your conky config:

```lua
lua_load = '~/.config/conky/prayer_ring.lua',
lua_draw_hook_post = 'conky_prayer',
```

If you already have a lua file loaded (like `conky_grey.lua`), you can either:

**Option A:** Add the prayer functions to your existing lua file

**Option B:** Load multiple lua files:

```lua
lua_load = '~/.config/conky/conky_grey.lua ~/.config/conky/prayer_ring.lua',
```

### Integrating with conky_grey.lua

If you're using the `conky_grey.lua` clock, add these to your existing file:

1. Add the `clock_prayer` data after `clock_s`:

```lua
-- PRAYER PROGRESS
clock_prayer = {
    {
    name='execi',                  arg='60 prayer --progress',  max_value=100,
    x=125,                         y=110,
    graph_radius=43,
    graph_thickness=4,
    graph_unit_angle=3.6,          graph_unit_thickness=3.6,
    graph_bg_colour=0x00FF00,      graph_bg_alpha=0.1,
    graph_fg_colour=0x00FF00,      graph_fg_alpha=0.7,
    txt_radius=0,
    txt_weight=0,                  txt_size=0,
    txt_fg_colour=0xFFFFFF,        txt_fg_alpha=0.0,
    graduation_radius=0,
    graduation_thickness=0,        graduation_mark_thickness=0,
    graduation_unit_angle=0,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.0,
    },
}
```

2. Add the prayer ring to `go_clock_rings()`:

```lua
for i in pairs(clock_prayer) do
    load_clock_rings(display, clock_prayer[i])
end
```

3. Add `draw_prayer_text()` function and call it in `conky_main()`.

## Customization

### Ring Colors

Change the color in `prayer_ring.lua`:

```lua
graph_bg_colour=0x00FF00,    -- Background (green)
graph_fg_colour=0x00FF00,    -- Foreground (green)
```

Common colors:
- Green: `0x00FF00`
- White: `0xFFFFFF`
- Gold: `0xFFD700`
- Cyan: `0x00FFFF`

### Ring Position

Adjust `x` and `y` to match your clock center:

```lua
x=125,
y=110,
```

### Ring Size

Adjust `graph_radius` for the ring size:

```lua
graph_radius=43,    -- Smaller = closer to center
```
