local awful = require "awful"
local wibox = require "wibox"
local gears = require "gears"
local beautiful = require "beautiful"
local common = require "awful.widget.common"
local rounded_rect_container = require "widgets.rounded_rect_container"
local base = require "wibox.widget.base"
local dpi = require("beautiful").xresources.apply_dpi

local function init_buttons()
    local buttons = gears.table.join(
        awful.button({}, 1, function(c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal("request::activate", "tasklist", { raise = true })
            end
        end),
        awful.button({}, 3, function()
            awful.menu.client_list { theme = { width = 250 } }
        end),
        awful.button({}, 4, function()
            awful.client.focus.byidx(1)
        end),
        awful.button({}, 5, function()
            awful.client.focus.byidx(-1)
        end)
    )
    return buttons
end

local function default_template()
    local ib = wibox.widget.imagebox()
    local tb = wibox.widget.textbox()
    local bgb = wibox.container.background()
    local tbm = wibox.container.margin(tb, dpi(4), dpi(4))
    local ibm = wibox.container.margin(ib, dpi(4))
    local l = wibox.layout.fixed.horizontal()

    -- All of this is added in a fixed widget
    l:fill_space(true)
    l:add(ibm)
    l:add(tbm)

    -- And all of this gets a background
    bgb:set_widget(l)

    return { ib = ib, tb = tb, bgb = bgb, tbm = tbm, ibm = ibm, primary = bgb }
end

local function custom_template(args)
    local l = base.make_widget_from_value(args.widget_template)

    -- The template system requires being able to get children elements by ids.
    -- This is not optimal, but for now there is no way around it.
    assert(
        l.get_children_by_id,
        "The given widget template did not result in a" .. "layout with a 'get_children_by_id' method"
    )

    return {
        ib = l:get_children_by_id("icon_role")[1],
        tb = l:get_children_by_id("text_role")[1],
        bgb = l:get_children_by_id("background_role")[1],
        tbm = l:get_children_by_id("text_margin_role")[1],
        ibm = l:get_children_by_id("icon_margin_role")[1],
        primary = l,
        update_callback = l.update_callback,
        create_callback = l.create_callback,
    }
end

function factory(s)
    local b = init_buttons()

    local widget = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = b,
        layout = { widget = wibox.layout.fixed.horizontal },
        style = {
            fg_normal = beautiful.tasklist_fg_normal or beautiful.fg_normal,
            bg_normal = beautiful.tasklist_bg_normal or beautiful.bg_normal,
            shape_border_width = beautiful.tasklist_task_border_width or 2,
            shape_border_color = beautiful.tasklist_task_border_color or "#aaaaaa",
            shape = beautiful.tasklist_task_shape or function(cr, w, h)
                gears.shape.rounded_rect(cr, w, h, 10)
            end,

            shape_border_width_focus = beautiful.tasklist_task_border_width_focus
                or beautiful.tasklist_task_border_width
                or 2,
            shape_border_color_focus = beautiful.tasklist_task_border_width_focus or "#ffffff",

            shape_border_width_minimized = beautiful.tasklist_task_border_width_minimized
                or beautiful.tasklist_task_border_width
                or 2,
            shape_border_color_minimized = beautiful.tasklist_task_border_color_minimized
                or beautiful.tasklist_task_border_color
                or "#828282",

            shape_border_width_urgent = beautiful.tasklist_task_border_width_urgent
                or beautiful.tasklist_task_border_width
                or 2,
            shape_border_color_urgent = beautiful.tasklist_task_border_color_urgent
                or beautiful.tasklist_task_border_color
                or "#ff0000",
        },
        widget_template = {
            {
                {
                    {
                        widget = wibox.container.margin,
                        margins = 2,
                        { id = "icon_role", widget = wibox.widget.imagebox },
                    },
                    { id = "text_role", widget = wibox.widget.textbox },
                    layout = wibox.layout.fixed.horizontal,
                },
                widget = wibox.container.margin,
                left = 10,
                right = 10,
            },
            id = "background_role",
            widget = wibox.container.background,
        },
        update_function = function(w, buttons, label, data, objects, args)
            w:reset()
            for i, o in ipairs(objects) do
                local cache = data[o]

                if not cache then
                    cache = (args and args.widget_template) and custom_template(args) or default_template()

                    cache.primary:buttons(common.create_buttons(buttons, o))

                    if cache.create_callback then
                        cache.create_callback(cache.primary, o, i, objects)
                    end

                    data[o] = cache
                elseif cache.update_callback then
                    cache.update_callback(cache.primary, o, i, objects)
                end

                local text, bg, bg_image, icon, item_args = label(o, cache.tb)
                item_args = item_args or {}

                -- The text might be invalid, so use pcall.
                if cache.tbm and (text == nil or text == "") then
                    cache.tbm:set_margins(0)
                elseif cache.tb then
                    if not cache.tb:set_markup_silently(text) then
                        cache.tb:set_markup "<i>&lt;Invalid text&gt;</i>"
                    end
                end

                if cache.bgb then
                    -- Randomize border and bg colors of task widgets
                    if cache.bgb._bg and cache.bgb._fg then
                        if o.minimized then
                            cache.bgb:set_bg(cache.bgb._bg .. "aa")
                            cache.bgb.shape_border_color = cache.bgb._fg .. "aa"
                        else
                            cache.bgb:set_bg(cache.bgb._bg)
                            cache.bgb.shape_border_color = cache.bgb._fg
                        end
                    elseif type(beautiful.tasklist_bg_and_border_colors) == "function" then
                        _colors = beautiful.tasklist_bg_and_border_colors()
                        cache.bgb:set_bg(_colors.bg)
                        cache.bgb.shape_border_color = _colors.fg
                        cache.bgb._bg = _colors.bg
                        cache.bgb._fg = _colors.fg
                    else
                        cache.bgb:set_bg(bg)
                    end

                    -- TODO v5 remove this if, it existed only for a removed and
                    -- undocumented API
                    if type(bg_image) ~= "function" then
                        cache.bgb:set_bgimage(bg_image)
                    else
                        gears.debug.deprecate(
                            "If you read this, you used an undocumented API"
                                .. " which has been replaced by the new awful.widget.common "
                                .. "templating system, please migrate now. This feature is "
                                .. "already staged for removal",
                            { deprecated_in = 4 }
                        )
                    end

                    cache.bgb.shape = item_args.shape
                    cache.bgb.shape_border_width = item_args.shape_border_width
                end

                if cache.ib and icon then
                    cache.ib:set_image(icon)
                elseif cache.ibm then
                    cache.ibm:set_margins(0)
                end

                w:add(cache.primary)
            end
        end,
    }
    return widget
end

return factory
