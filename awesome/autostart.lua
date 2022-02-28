local awful = require("awful")


function start_apps()
    awful.spawn.once("nm-applet")
    awful.spawn.once("mpris-proxy")
    awful.spawn.once("picom -b")
    awful.spawn.single_instance("ulauncher --hide-window")
end

return start_apps
