local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"

local icons = beautiful.theme_path .. "/icons"

local function colored_icon(icon)
    return gears.color.recolor_image(icons .. icon, beautiful.taglist_fg_normal)
end

local tags = {}

tags.tag1 = awful.tag.add("web", {
    -- icon = "",
    layout = awful.layout.suit.floating,
    screen = awful.screen.focused(),
    single_instance = "firefox",
    icon = colored_icon "/wheel.png",
})
tags.tag2 = awful.tag.add("term", {
    layout = awful.layout.suit.magnifier,
    screen = awful.screen.focused(),
    gap = 10,
    gap_single_client = true,
    single_instance = "kitty",
    icon = colored_icon "/hilt.png",
})
tags.tag3 = awful.tag.add("music", {
    layout = awful.layout.suit.floating,
    screen = awful.screen.focused(),
    icon = colored_icon "/harp.png",
})
tags.tag4 = awful.tag.add("dev", {
    layout = awful.layout.suit.max,
    screen = awful.screen.focused(),
    icon = colored_icon "/avendesora-2.png",
})
tags.tag5 = awful.tag.add("media", {
    layout = awful.layout.suit.max.fullscreen,
    screen = awful.screen.focused(),
    icon = colored_icon "/trolloc.png",
})
tags.tag6 = awful.tag.add("doc", {
    layout = awful.layout.suit.floating,
    screen = awful.screen.focused(),
    icon = colored_icon "/star.png",
})
tags.tag7 = awful.tag.add("gaming", {
    layout = awful.layout.suit.floating,
    screen = awful.screen.focused(),
    icon = colored_icon "/telaran.png",
})
tags.tag8 = awful.tag.add("coms", {
    layout = awful.layout.suit.tile,
    screen = awful.screen.focused(),
    icon = colored_icon "/valere.png",
})
tags.tag9 = awful.tag.add("other", {
    layout = awful.layout.suit.floating,
    screen = awful.screen.focused(),
    icon = colored_icon "/ravens.png",
    persistant = true, -- custom filter
})

-- Awesome doesn't change colors of icons in taglist so we do it manually
for k, _t in pairs(tags) do
    _t:connect_signal("property::selected", function(_tag)
        -- ICON
        if _t.selected then
            _t.icon = gears.color.recolor_image(_t.icon, beautiful.taglist_fg_focus)
            
            -- START FUNCTION
            if type(_t.single_instance) == "string" then
                local found = false
                for index, c in ipairs(_t:clients()) do
    		    if string.find(c.instance, _t.single_instance) or (_t.single_instance:find("firefox") and c.instance:find("Navigator")) then
		        found = true
		    end
                end
                if not found then
                    awful.spawn.easy_async(_t.single_instance, function (out)
                    end)
                end
            end
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

return tags
