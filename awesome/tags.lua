local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local inspect = require "inspect"

local icons = beautiful.theme_path .. "/icons"

local function colored_icon(icon)
    return gears.color.recolor_image(icons .. icon, beautiful.taglist_fg_normal)
end

tag1 = ""
tag2 = ""
tag3 = ""
tag4 = ""
tag5 = ""
tag6 = ""
tag7 = ""
tag8 = ""
tag9 = ""
tag1 = awful.tag.add("web", {
    -- icon = "",
    layout = awful.layout.suit.floating,
    screen = awful.screen.focused(),
    -- icon = icons .. "firefox-brands.png"
    icon = colored_icon "/wheel.png",
})
tag2 = awful.tag.add("term", {
    layout = awful.layout.suit.spiral,
    screen = awful.screen.focused(),
    gap = 10,
    gap_single_client = true,
    icon = colored_icon "/hilt.png",
})
tag3 = awful.tag.add("music", {
    layout = awful.layout.suit.floating,
    screen = awful.screen.focused(),
    icon = colored_icon "/harp.png",
})
tag4 = awful.tag.add("dev", {
    layout = awful.layout.suit.max,
    screen = awful.screen.focused(),
    icon = colored_icon "/avendesora-2.png",
})
tag5 = awful.tag.add("media", {
    layout = awful.layout.suit.max.fullscreen,
    screen = awful.screen.focused(),
    icon = colored_icon "/trolloc.png",
})
tag6 = awful.tag.add("doc", {
    layout = awful.layout.suit.floating,
    screen = awful.screen.focused(),
    icon = colored_icon "/star.png",
})
tag7 = awful.tag.add("gaming", {
    layout = awful.layout.suit.max,
    screen = awful.screen.focused(),
    icon = colored_icon "/telaran.png",
})
tag8 = awful.tag.add("coms", {
    layout = awful.layout.suit.floating,
    screen = awful.screen.focused(),
    icon = colored_icon "/valere.png",
})
tag9 = awful.tag.add("other", {
    layout = awful.layout.suit.floating,
    screen = awful.screen.focused(),
    icon = colored_icon "/ravens.png",
    persistant = true, -- custom filter
})

-- Awesome doesn't change colors of icons in taglist so we do it manually
local _tag_list = { tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8, tag9 }
for index, _t in ipairs(_tag_list) do
    ---@diagnostic disable-next-line: undefined-field
    _t:connect_signal("property::selected", function(_tag)
        if _t.selected then
            _t.icon = gears.color.recolor_image(_t.icon, beautiful.taglist_fg_focus)
        else
            if #_t:clients() > 0 then
                _t.icon = gears.color.recolor_image(_t.icon, beautiful.taglist_fg_occupied)
            else
                _t.icon = gears.color.recolor_image(_t.icon, beautiful.taglist_fg_normal)
            end
        end
    end)

    _t:connect_signal("tagged", function(c)
        if _t.selected then
            _t.icon = gears.color.recolor_image(_t.icon, beautiful.taglist_fg_focus)
        else
            print("tagged without focus")
            _t.icon = gears.color.recolor_image(_t.icon, beautiful.taglist_fg_occupied)
        end
    end)

    _t:connect_signal("untagged", function(c)
        if _t.selected then
            _t.icon = gears.color.recolor_image(_t.icon, beautiful.taglist_fg_focus)
        else
            if #_t:clients() > 0 then
                _t.icon = gears.color.recolor_image(_t.icon, beautiful.taglist_fg_occupied)
            else
                _t.icon = gears.color.recolor_image(_t.icon, beautiful.taglist_fg_normal)
            end
        end
    end)
end
