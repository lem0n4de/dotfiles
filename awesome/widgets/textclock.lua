local wibox = require "wibox"
local gears = require "gears"
local beautiful = require "beautiful"
local rounded_rect_container = require "widgets.rounded_rect_container"

local function default_shape(cr, w, h)
    return gears.shape.rounded_rect(cr, w, h, 10)
end


function factory(args)
    local args = args or {}
    widget = wibox.widget.textclock()
    local fg_color = args.fg_color or beautiful.textclock_fg_color or beautiful.fg_normal or "#fff"
    local bg_color = args.bg_color or beautiful.textclock_bg_color or beautiful.bg_normal or "#000"
    local bg_shape = args.textclock_bg_shape or beautiful.textclock_bg_shape or default_shape
    local bg_shape_border_color = args.textclock_bg_shape_border_color or beautiful.textclock_bg_shape_border_color
    local bg_shape_border_width = args.textclock_bg_shape_border_width or beautiful.textclock_bg_shape_border_width or 0

    print(fg_color, bg_color)

    container = rounded_rect_container {
        widget = widget,
        fg_color = fg_color,
        bg_color = bg_color,
        bg_shape = bg_shape,
        bg_shape_border_color = bg_shape_border_color,
        bg_shape_border_width = bg_shape_border_width
    }

    return container
end

return factory