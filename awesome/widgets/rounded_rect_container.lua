local wibox = require "wibox"
local gears = require "gears"
local i = require "inspect"

local function factory(args)
    local args = args or {}
    if args.widget == nil then
        error "no widget passed"
    end
    local fg_color = args.fg_color or "#fff"
    local bg_color = args.bg_color or "#000000"
    local bg_shape = args.bg_shape or function(cr, w, h)
        return gears.shape.rounded_rect(cr, w, h, 10)
    end
    local bg_shape_border_color = args.bg_shape_border_color or "ffffff"
    local bg_shape_border_width = args.bg_shape_border_width or 2

    local widget = wibox.widget {
        {

            { layout = wibox.layout.fixed.horizontal, args.widget },
            fg = fg_color,
            bg = bg_color,
            shape = bg_shape,
            shape_border_color = bg_shape_border_color,
            shape_border_width = bg_shape_border_width,
            widget = wibox.container.background,
        },
        widget = wibox.container.margin,
        left = 10,
        right = 10,
    }

    widget._widget = args.widget

    widget.mt = {}
    widget.mt.__index = function(table, key)
        return widget._widget[key]
    end
    setmetatable(widget, widget.mt)
    return widget
end

return factory
