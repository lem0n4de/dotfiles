local awful = require("awful")


function start_apps()
    awful.spawn.once("nm-applet")
end

return start_apps
