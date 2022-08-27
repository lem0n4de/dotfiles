local wibox = require "wibox"
local awful = require "awful"
local naughty = require "naughty"
local gears = require "gears"
local beautiful = require "beautiful"
local upower = require "widgets.upower"
local rounded_rect_container = require "widgets.rounded_rect_container"

local function factory(args)
    args = args or {}
    local fg_color = args.fg_color or beautiful.battery_fg_color or beautiful.fg_color or "#fff"
    local battery_bg_color = args.bg_color or beautiful.battery_bg_color
    local battery_bg_shape = args.bg_shape or beautiful.battery_bg_shape
    local battery_bg_shape_border_color = args.bg_shape_color or beautiful.battery_bg_shape_border_color
    local battery_bg_shape_border_width = args.bg_shape_border_width or beautiful.battery_bg_shape_border_width

    local base_arc_location = "/usr/share/icons/Arc/status/symbolic/"
    local GET_BATTERY_PERCENTAGE = "cat /sys/class/power_supply/BAT0/capacity | head -1 | tr -d ' \n'"
    local GET_BATTERY_STATUS = "cat /sys/class/power_supply/BAT0/status | head -1 | tr -d ' \n'"
    local GET_BATTERY_CAPACITY_LEVEL = "cat /sys/class/power_supply/BAT0/capacity_level | head -1 | tr -d ' \n'"

    local BATTERY_STATUS_FILE = "/sys/class/power_supply/BAT0/status"
    local BATTERY_PERCENTAGE_FILE = "/sys/class/power_supply/BAT0/capacity"
    local BATTERY_CAPACITY_LEVEL_FILE = "/sys/class/power_supply/BAT0/capacity_level"
    local GET_BATTERY_INFO = "cat "
        .. BATTERY_PERCENTAGE_FILE
        .. " "
        .. BATTERY_CAPACITY_LEVEL_FILE
        .. " "
        .. BATTERY_STATUS_FILE

    local BATTERY_STATUS_DISCHARGING = "Discharging"
    local BATTERY_STATUS_CHARGING = "Charging"
    local BATTERY_STATUS_FULL = "Full"

    local BATTERY_CAPACITY_UNKNOWN = "Unknown"
    local BATTERY_CAPACITY_CRITICAL = "Critical"
    local BATTERY_CAPACITY_LOW = "Low"
    local BATTERY_CAPACITY_NORMAL = "Normal"
    local BATTERY_CAPACITY_HIGH = "High"
    local BATTERY_CAPACITY_FULL = "Full"

    local BATTERY_FULL_CHARGED = base_arc_location .. "battery-full-charged-symbolic.svg"
    local BATTERY_FULL = base_arc_location .. "battery-full-symbolic.svg"
    local BATTERY_GOOD_CHARGING = base_arc_location .. "battery-good-charging-symbolic.svg"
    local BATTERY_GOOD = base_arc_location .. "battery-good-symbolic.svg"
    local BATTERY_LOW_CHARGING = base_arc_location .. "battery-low-charging-symbolic.svg"
    local BATTERY_LOW = base_arc_location .. "battery-low-symbolic.svg"
    local BATTERY_EMPTY_CHARGING = base_arc_location .. "battery-empty-charging-symbolic.svg"
    local BATTERY_EMPTY = base_arc_location .. "battery-empty-symbolic.svg"
    local BATTERY_CAUTION_CHARGING = base_arc_location .. "battery-caution-charging-symbolic.svg"
    local BATTERY_CAUTION = base_arc_location .. "battery-caution-symbolic.svg"

    local widget = wibox.widget {
        {
            {
                id = "battery_icon_widget",
                image = BATTERY_EMPTY,
                widget = wibox.widget.imagebox,
            },
            top = 5,
            bottom = 5,
            left = 5,
            widget = wibox.container.margin,
        },
        {
            {
                id = "battery_text_widget",
                widget = wibox.widget.textbox,
            },
            left = 5,
            right = 5,
            widget = wibox.container.margin,
        },
        id = "container_widget",
        widget = wibox.layout.fixed.horizontal,
    }

    function widget:set_icon(icon)
        local w = widget:get_children_by_id("battery_icon_widget")[1]
        w.image = gears.color.recolor_image(icon, fg_color)
    end

    widget.last_notified_percentage = 0
    widget.last_notified_time = os.time()

    function widget:set_percentage(percentage)
        widget
            :get_children_by_id("battery_text_widget")[1]
            :set_markup(string.format('<span color="' .. fg_color .. '">%d%%</span>', percentage))
    end

    upower.on_state_discharging = function()
        local percentage = tonumber(upower.device_proxy.Percentage)
        if percentage ~= widget.last_notified_percentage
                and os.difftime(os.time(), widget.last_notified_time) > 60
                and percentage < 15 then

            widget.last_notified_percentage = percentage
            widget.last_notified_time = os.time()
            naughty.notify {
                title = "Battery levels critical",
                message = "%" .. percentage .. "\nÖLÜYORUUM ACİL PRİZE TAK",
                urgency = "critical",
                timeout = 5
            }
        end
        widget:set_percentage(percentage)
        widget:set_icon(BATTERY_GOOD)
    end

    upower.on_state_charging = function()
        widget:set_percentage(upower.device_proxy.Percentage)
        if upower.device_proxy.Percentage > 80 then
            widget:set_icon(BATTERY_GOOD_CHARGING)
        else
            widget:set_icon(BATTERY_LOW_CHARGING)
        end
    end

    upower.on_state_empty = function()
        widget:set_percentage(upower.device_proxy.Percentage)
        widget:set_icon(BATTERY_EMPTY)
    end

    upower.on_state_fully_charged = function()
        widget:set_percentage(upower.device_proxy.Percentage)
        widget:set_icon(BATTERY_FULL_CHARGED)
    end
    upower:init()
    upower:run_callbacks()
    return rounded_rect_container {
        widget = widget,
        bg_color = battery_bg_color,
        bg_shape = battery_bg_shape,
        bg_shape_border_color = battery_bg_shape_border_color,
        bg_shape_border_width = battery_bg_shape_border_width,
    }
end

return factory
