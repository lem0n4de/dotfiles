local awful = require "awful"
local wibox = require "wibox"
local gears = require "gears"
local beautiful = require "beautiful"
local rounded_rect_container = require "widgets.rounded_rect_container"

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)

function factory(screen)
    mytaglist = awful.widget.taglist {
        screen = screen,
        filter = function(t)
            if t.persistant ~= nil then
                return #t:clients() > 0 or not t.persistant
            end
            return true
        end,
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    { id = "icon_role", widget = wibox.widget.imagebox },
                    top = 3,
                    bottom = 3,
		    left = 10,
                    right = 10,
                    id = "icon_margin_role",
                    widget = wibox.container.margin,
                },
                -- {
                --     {id = "text_role", widget = wibox.widget.textbox},
                --     margins = 2,
                --     right = 10,
                --     widget = wibox.container.margin
                -- },
                layout = wibox.layout.fixed.horizontal,
            },
            id = "background_role",
            widget = wibox.container.background,
        },
    }

    taglist_container = rounded_rect_container {
        widget = mytaglist,
        bg_color = beautiful.taglist_bg,
        bg_shape = beautiful.taglist_total_shape,
        bg_shape_border_color = beautiful.taglist_total_border_color,
        bg_shape_border_width = beautiful.taglist_total_border_width,
    }

    return taglist_container
end

return factory
