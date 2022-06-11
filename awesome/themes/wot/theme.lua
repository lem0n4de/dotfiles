local gears = require "gears"
local theme_assets = require "beautiful.theme_assets"
local xresources = require "beautiful.xresources"
local dpi = xresources.apply_dpi

local gfs = require "gears.filesystem"
local themes_path = gfs.get_themes_dir()

local WheelOfTime = require "themes.wot.colors"

tasklist_colors = {
    { bg = WheelOfTime.DARK_RED, fg = WheelOfTime.RED },
    { bg = WheelOfTime.DARK_BLUE, fg = WheelOfTime.BLUE },
    { bg = WheelOfTime.DARK_BROWN, fg = WheelOfTime.BROWN },
    { bg = WheelOfTime.DARK_GREEN, fg = WheelOfTime.GREEN },
    { bg = WheelOfTime.DARK_GRAY, fg = WheelOfTime.GRAY },
    { bg = WheelOfTime.DARK_YELLOW, fg = WheelOfTime.YELLOW },
    { bg = WheelOfTime.DARK_WHITE, fg = WheelOfTime.WHITE },
}

local theme = {}
-- local _theme = theme
-- theme = {}
-- theme.mt = {
--     __index = function(t, k)
--         if k == "tasklist_task_border_color" then
--             fg = tasklist_colors[math.random(#tasklist_colors)].fg
--             print(fg)
--             return fg
--         end
--         return _theme[k]
--     end,
--     __newindex = function(t, k, v) _theme[k] = v end,
-- }

-- setmetatable(theme, theme.mt)

theme.colors = {
    neon_green = "#1ad271",
    neon_purple = "#1ad271",
}

theme.font = "Liberation Sans 11"

theme.bg_normal = WheelOfTime.DARK_RED .. "cc" -- "#222222"
theme.bg_focus = WheelOfTime.DARK_RED -- "#535d6c"
theme.bg_urgent = WheelOfTime.RED -- "#ff0000"
theme.bg_minimize = WheelOfTime.DARK1 -- "#444444"
theme.bg_systray = WheelOfTime.DARK1 .. "00"

theme.fg_normal = WheelOfTime.GRAY -- "#aaaaaa"
theme.fg_focus = WheelOfTime.WHITE -- "#ffffff"
theme.fg_urgent = WheelOfTime.WHITE -- "#ffffff"
theme.fg_minimize = WheelOfTime.WHITE -- "#ffffff"

theme.useless_gap = dpi(0)
theme.border_width = dpi(1)
theme.border_normal = "#000000"
theme.border_focus = "#535d6c"
theme.border_marked = "#91231c"

theme.top_left_border_color = WheelOfTime.WHITE -- "#ffffff"
theme.top_left_border_width = dpi(2)
-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
-- theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:

-- TAGLIST
local icons = gears.filesystem.get_configuration_dir() .. "icons"

theme.taglist_total_shape = function(cr, width, height, radius)
    gears.shape.rounded_rect(cr, width, height, 10)
end
theme.taglist_total_border_width = 2
theme.taglist_total_border_color = WheelOfTime.BLUE

theme.taglist_bg = WheelOfTime.DARK1
theme.taglist_fg_focus = WheelOfTime.BLUE
theme.taglist_fg_normal = WheelOfTime.DARK_BLUE
theme.taglist_fg_occupied = WheelOfTime.BROWN
theme.taglist_bg_focus = WheelOfTime.DARK2
theme.taglist_bg_urgent = WheelOfTime.ORANGE

theme.taglist_squares_not_selected_color = WheelOfTime.WHITE

local taglist_square_size = dpi(8)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.taglist_bg_focus)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size,
    theme.taglist_squares_not_selected_color
)
theme.taglist_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 5)
end

-- TASKLIST
theme.tasklist_bg_and_border_colors = function()
    return tasklist_colors[math.random(#tasklist_colors)]
end

theme.wibar_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 50)
end


-- VOLUME
theme.volume_bg_color = WheelOfTime.DARK_GREEN
theme.volume_bg_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 10)
end
theme.volume_bg_shape_border_color = WheelOfTime.GREEN
theme.volume_bg_shape_border_width = 2

theme.volume_fg_color = WheelOfTime.GREEN


-- BATTERY 
theme.battery_fg_color = WheelOfTime.GRAY
theme.battery_bg_color = WheelOfTime.DARK_GRAY
theme.battery_bg_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 10)
end
theme.battery_bg_shape_border_color = WheelOfTime.GRAY
theme.battery_bg_shape_border_width = 2

-- TEXTCLOCK
theme.textclock_fg_color = WheelOfTime.RED
theme.textclock_bg_color = WheelOfTime.DARK_RED
theme.textclock_bg_shape = function (cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 10)
end
theme.textclock_bg_shape_border_color = WheelOfTime.RED
theme.textclock_bg_shape_border_width = 2


-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_icon_size = 120
theme.notification_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 5)
end

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
-- theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = themes_path .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = themes_path .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = themes_path .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = themes_path .. "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = themes_path .. "default/titlebar/maximized_focus_active.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Arc"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
