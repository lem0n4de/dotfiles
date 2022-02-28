local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local function factory(args)
    args = args or {}
    local fg_color = args.fg_color or beautiful.fg_color or "#fff"
    
    local VOL_HIGH = "/usr/share/icons/Arc/status/symbolic/audio-volume-high-symbolic.svg"
    local VOL_MEDIUM = "/usr/share/icons/Arc/status/symbolic/audio-volume-medium-symbolic.svg"
    local VOL_LOW = "/usr/share/icons/Arc/status/symbolic/audio-volume-low-symbolic.svg"
    local VOL_MUTED = "/usr/share/icons/Arc/status/symbolic/audio-volume-muted-symbolic.svg"
    
    local VOL_UP = "pactl set-sink-volume @DEFAULT_SINK@ +5%"
    local VOL_DOWN = "pactl set-sink-volume @DEFAULT_SINK@ -5%"
    local VOL_TOGGLE_MUTE = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
    local VOL_GET = "pactl get-sink-volume @DEFAULT_SINK@ | grep '[0-9][0-9]*%' -o | head -1 | tr -d '%'"
    local VOL_IS_MUTED = "pactl get-sink-mute @DEFAULT_SINK@ | cut -d ' ' -f 2 | grep yes -o -Z"
    
    local widget = wibox.widget {
        {
            {
                id = "icon_widget",
                image = VOL_HIGH,
                widget = wibox.widget.imagebox
            },
            top = 3,
            bottom = 3,
            left = 5,
            widget = wibox.container.margin
        },
        {
            {
                id = "text_widget",
                widget = wibox.widget.textbox
            },
            left = 3,
            right = 3,
            widget = wibox.container.margin
        },
        id = "container_widget",
        left = 5,
        right = 5,
        top = 5,
        widget = wibox.layout.fixed.horizontal
    }

    function widget:update_widget(new_vol, is_muted)
        vol = tonumber(new_vol)
        icon_widget = widget:get_children_by_id("icon_widget")[1]
        if is_muted then
            icon_widget.image = gears.color.recolor_image(VOL_MUTED, fg_color)
        elseif vol >= 66 then
            icon_widget.image = gears.color.recolor_image(VOL_HIGH, fg_color)
        elseif vol >= 33 then
            icon_widget.image = gears.color.recolor_image(VOL_MEDIUM, fg_color)
        else
            icon_widget.image = gears.color.recolor_image(VOL_LOW, fg_color)
        end
        widget:get_children_by_id("text_widget")[1]:set_markup(string.format('<span color="' .. fg_color .. '">%d%%</span>', vol))
    end
    
    function widget:volume_get_and_update()
        awful.spawn.easy_async_with_shell(VOL_GET, function(new_vol)
            awful.spawn.easy_async_with_shell(VOL_IS_MUTED, function(out)
                if string.match(out, "yes") then
			is_muted = true
		else
			is_muted = false
		end
                widget:update_widget(new_vol, is_muted)
            end)
        end)
    end
    
    function widget:volume_up()
        awful.spawn.easy_async(VOL_UP, function(out)
            widget:volume_get_and_update()
        end)
    end
    
    function widget:volume_down()
        awful.spawn.easy_async(VOL_DOWN, function(out)
            widget:volume_get_and_update()
        end)
    end
    
    function widget:volume_mute()
        awful.spawn.easy_async(VOL_TOGGLE_MUTE, function(out)
            widget:volume_get_and_update()
        end)
    end

    widget:volume_get_and_update()
    return widget
end

return factory
