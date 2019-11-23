local awful = require("awful")

tag1 = ""
tag2 = ""
tag3 = ""
tag4 = ""
tag5 = ""
tag6 = ""
tag8 = ""
tag7 = ""

tag1 = awful.tag.add("web", {
    -- icon = "",
    layout = awful.layout.suit.max,
    screen = awful.screen.focused(),
})
tag2 = awful.tag.add("term", {
    layout = awful.layout.suit.spiral,
    screen = s,
})
tag3 = awful.tag.add("doc", {
    layout = awful.layout.suit.floating,
    screen = s
})
tag4 = awful.tag.add("dev", {
    layout = awful.layout.suit.max,
    screen = s
})
tag5 = awful.tag.add("media", {
    layout = awful.layout.suit.max.fullscreen,
    screen = s
})
tag6 = awful.tag.add("coms", {
    layout = awful.layout.suit.floating,
    screen = s
})
tag7 = awful.tag.add("gaming", {
    layout = awful.layout.suit.max,
    screen = s
})
tag8 = awful.tag.add("other", {
    layout = awful.layout.suit.floating,
    screen = s
})
