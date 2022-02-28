local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local function factory(args)
    args = args or {}
    local fg_color = args.fg_color or beautiful.fg_color or "#fff"

    local base_arc_location = "/usr/share/icons/Arc/status/symbolic/"
    local GET_BATTERY_PERCENTAGE = "cat /sys/class/power_supply/BAT0/capacity | head -1 | tr -d ' \n'"
    local GET_BATTERY_STATUS = "cat /sys/class/power_supply/BAT0/status | head -1 | tr -d ' \n'"
    local GET_BATTERY_CAPACITY_LEVEL = "cat /sys/class/power_supply/BAT0/capacity_level | head -1 | tr -d ' \n'"

    local BATTERY_STATUS_FILE = "/sys/class/power_supply/BAT0/status"
    local BATTERY_PERCENTAGE_FILE = "/sys/class/power_supply/BAT0/capacity"
    local BATTERY_CAPACITY_LEVEL_FILE = "/sys/class/power_supply/BAT0/capacity_level"
    local GET_BATTERY_INFO = "cat " .. BATTERY_PERCENTAGE_FILE .. " " .. BATTERY_CAPACITY_LEVEL_FILE .. " " .. BATTERY_STATUS_FILE

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
                widget = wibox.widget.imagebox
            },
            top = 5,
            bottom = 5,
            left = 5,
            widget = wibox.container.margin
        },
        {
            {
                id = "battery_text_widget",
                widget = wibox.widget.textbox
            },
            left = 5,
            right = 5,
            widget = wibox.container.margin
        },
        id = "container_widget",
        widget = wibox.layout.fixed.horizontal
    }

    function widget:set_icon(icon)
        local w = widget:get_children_by_id("battery_icon_widget")[1]
        w.image = gears.color.recolor_image(icon, fg_color)
    end

    function widget:set_percentage(percentage)
        widget:get_children_by_id("battery_text_widget")[1]:set_markup(string.format('<span color="' .. fg_color .. '">%d%%</span>', percentage))
    end

    function widget:update_widget(percentage, capacity_level, status)
        print("Percentage: " .. percentage .. " capacity_level: " .. capacity_level .. " status: " .. status)
        local p = tonumber(percentage)
        widget:set_percentage(p)
        if string.match(capacity_level, BATTERY_CAPACITY_FULL) then
            if string.match(status, BATTERY_STATUS_FULL) then
                widget:set_icon(BATTERY_FULL_CHARGED)
            else
                widget:set_icon(BATTERY_FULL)
            end

        elseif string.match(capacity_level, BATTERY_CAPACITY_HIGH) then
            if string.match(status, BATTERY_STATUS_CHARGING) then
                widget:set_icon(BATTERY_GOOD_CHARGING)
            else
                widget:set_icon(BATTERY_GOOD)
            end

        elseif string.match(capacity_level, BATTERY_CAPACITY_NORMAL) then
            if string.match(status, BATTERY_STATUS_CHARGING) then
                widget:set_icon(BATTERY_GOOD_CHARGING)
            elseif tonumber(percentage) > 90 then
                widget:set_icon(BATTERY_FULL)
            else
                widget:set_icon(BATTERY_GOOD)
            end

        elseif string.match(capacity_level, BATTERY_CAPACITY_LOW) then
            if string.match(status, BATTERY_STATUS_CHARGING) then
                widget:set_icon(BATTERY_LOW_CHARGING)
            else
                widget:set_icon(BATTERY_LOW)
            end

        elseif string.match(capacity_level, BATTERY_CAPACITY_CRITICAL) then
            if string.match(status, BATTERY_STATUS_CHARGING) then
                widget:set_icon(BATTERY_CAUTION_CHARGING)
            else
                widget:set_icon(BATTERY_CAUTION)
            end
        end
    end
    watch_widget = awful.widget.watch(GET_BATTERY_INFO, 7, function (widget, stdout)
        local count = 0
        local percentage = ""
        local status = ""
        local capacity_level = ""
        for line in stdout:gmatch("[^\r\n]+") do
            print(line)
            if count == 0 then
                percentage = line
                count = count + 1
            elseif count == 1 then
                capacity_level = line
                count = count + 1
            elseif count == 2 then
                status = line
                count = 0
            end
        end
        widget:update_widget(percentage, capacity_level, status)
        return widget
    end, widget)
    return watch_widget
end

return factory