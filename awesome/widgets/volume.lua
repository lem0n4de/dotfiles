local wibox = require "wibox"
local awful = require "awful"
local gears = require "gears"
local beautiful = require "beautiful"
local timer = require "gears.timer"
local rounded_rect_container = require "widgets.rounded_rect_container"

local function factory(args)
    args = args or {}
    local timeout = args.timeout or 7
    local fg_color = args.fg_color or beautiful.volume_fg_color or beautiful.fg_color or "#fff"
    local bg_color = args.bg_color or beautiful.volume_bg_color or beautiful.bg_color or "#000000"
    local bg_shape = args.bg_shape or beautiful.volume_bg_shape
    local bg_shape_border_color = args.bg_shape_border_color or beautiful.volume_bg_shape_border_color
    local bg_shape_border_width = args.bg_shape_border_width or beautiful.volume_bg_shape_border_width

    local VOL_HIGH = "/usr/share/icons/Arc/status/symbolic/audio-volume-high-symbolic.svg"
    local VOL_MEDIUM = "/usr/share/icons/Arc/status/symbolic/audio-volume-medium-symbolic.svg"
    local VOL_LOW = "/usr/share/icons/Arc/status/symbolic/audio-volume-low-symbolic.svg"
    local VOL_MUTED = "/usr/share/icons/Arc/status/symbolic/audio-volume-muted-symbolic.svg"

    local VOL_UP = "pactl set-sink-volume @DEFAULT_SINK@ +5%"
    local VOL_DOWN = "pactl set-sink-volume @DEFAULT_SINK@ -5%"
    local VOL_TOGGLE_MUTE = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
    local VOL_GET = "pactl get-sink-volume @DEFAULT_SINK@ | grep '[0-9][0-9]*%' -o | head -1 | tr -d '%'"
    local VOL_IS_MUTED = "pactl get-sink-mute @DEFAULT_SINK@ | cut -d ' ' -f 2 | grep yes -o -Z"
    local GET_DEFAULT_SINK_NAME =
        "pactl list sinks | grep $(pactl get-default-sink) -B 2 -A 50 -m 1 | grep Description | cut -d ':' -f 2 -z | sed 's/ //1' "

    local widget = wibox.widget {
        {
            {
                id = "icon_widget",
                image = VOL_HIGH,
                widget = wibox.widget.imagebox,
            },
            top = 3,
            bottom = 3,
            left = 5,
            widget = wibox.container.margin,
        },
        {
            {
                id = "text_widget",
                widget = wibox.widget.textbox,
            },
            left = 3,
            right = 3,
            widget = wibox.container.margin,
        },
        id = "container_widget",
        left = 5,
        right = 5,
        top = 5,
        widget = wibox.layout.fixed.horizontal,
    }

    function widget:get_default_sink() end

    function widget:update_widget(new_vol, is_muted, device_name)
        vol = tonumber(new_vol)
        local icon_widget = widget:get_children_by_id("icon_widget")[1]
        if is_muted then
            icon_widget.image = gears.color.recolor_image(VOL_MUTED, fg_color)
        elseif vol >= 66 then
            icon_widget.image = gears.color.recolor_image(VOL_HIGH, fg_color)
        elseif vol >= 33 then
            icon_widget.image = gears.color.recolor_image(VOL_MEDIUM, fg_color)
        else
            icon_widget.image = gears.color.recolor_image(VOL_LOW, fg_color)
        end

        dev = ""
        if device_name and type(device_name) == "string" then
            if string.len(device_name) > 20 then
                dev = string.sub(device_name, 1, 17) .. "..."
            else
                dev = device_name
            end
        end
        widget
            :get_children_by_id("text_widget")[1]
            :set_markup('<span color="' .. fg_color .. '">' .. vol .. "% " .. "[ " .. dev .. " ]  " .. "</span>")
    end

    function widget:volume_get_and_update()
        awful.spawn.easy_async_with_shell(VOL_GET, function(new_vol)
            -- Awesome starts earlier than pulse at first,
            -- so we try again till it started and returned correctly
            if new_vol == nil or new_vol == "" then
                return widget:volume_get_and_update()
            end
            awful.spawn.easy_async_with_shell(VOL_IS_MUTED, function(out)
                if string.match(out, "yes") then
                    is_muted = true
                else
                    is_muted = false
                end
                awful.spawn.easy_async_with_shell(GET_DEFAULT_SINK_NAME, function(dev)
                    if out then
                        widget:update_widget(new_vol, is_muted, dev)
                    end
                end)
                -- widget:update_widget(new_vol, is_muted)
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
    local t = timer { timeout = timeout }
    t:connect_signal("timeout", function()
        t:stop()
        widget:volume_get_and_update()
        t:again()
    end)
    t:start()
    t:emit_signal "timeout"
    return rounded_rect_container {
        widget = widget,
        bg_color = bg_color,
        bg_shape = bg_shape,
        bg_shape_border_color = bg_shape_border_color,
        bg_shape_border_width = bg_shape_border_width,
    }
end

return factory
