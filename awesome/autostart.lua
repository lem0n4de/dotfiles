local awful = require("awful")


function start_apps()
    awful.spawn.once("nm-applet")
    awful.spawn.once("telegram-desktop")
end

return start_apps
    