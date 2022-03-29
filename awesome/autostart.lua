local awful = require("awful")


function start_apps()
    awful.spawn.single_instance("nm-applet")
    -- awful.spawn.single_instance("mpris-proxy")
    awful.spawn.single_instance("picom -b")
    -- awful.spawn.single_instance("ulauncher --hide-window")
end

return start_apps
