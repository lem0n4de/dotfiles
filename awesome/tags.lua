local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

tag1 = ""
tag2 = ""
tag3 = ""
tag4 = ""
tag5 = ""
tag6 = ""
tag7 = ""
tag8 = ""
tag9 = ""

local icons = gears.filesystem.get_configuration_dir() .. "icons/"
tag1 = awful.tag.add("web", {
    -- icon = "",
    layout = awful.layout.suit.floating,
    screen = awful.screen.focused(),
    icon = icons .. "firefox-brands.png"
})
tag2 = awful.tag.add("term", {
    layout = awful.layout.suit.spiral,
    screen = awful.screen.focused(),
    gap = 10,
    gap_single_client = true,
    icon = icons .. "terminal-solid.png"
})
tag3 = awful.tag.add("doc", {
    layout = awful.layout.suit.floating,
    screen = awful.screen.focused(),
    icon = icons .. "folder-regular.png"
})
tag4 = awful.tag.add("dev", {
    layout = awful.layout.suit.max,
    screen = awful.screen.focused(),
    icon = icons .. "code-branch-solid.png"
})
tag5 = awful.tag.add("media", {
    layout = awful.layout.suit.max.fullscreen,
    screen = awful.screen.focused(),
    icon = icons .. "video-solid.png"
})
tag6 = awful.tag.add("coms", {
    layout = awful.layout.suit.floating,
    screen = awful.screen.focused(),
    icon = icons .. "headset-solid.png"
})
tag7 = awful.tag.add("gaming", {
    layout = awful.layout.suit.max,
    screen = awful.screen.focused(),
    icon = icons .. "gamepad-solid.png"
})
tag9 = awful.tag.add("music", {
    layout = awful.layout.suit.floating,
    screen = awful.screen.focused(),
    icon = icons .. "spotify-brands.png"
})
tag8 = awful.tag.add("other", {
    layout = awful.layout.suit.floating,
    screen = awful.screen.focused(),
    icon = icons .. "life-ring-regular.png"
})
