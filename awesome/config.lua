-- This is used later as the default terminal and editor to run.
local awful = require "awful"

terminal = "kitty"
editor = os.getenv("VISUAL") or os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor
file_explorer = "pcmanfm"
dotfiles = os.getenv "HOME" .. "/.dotfiles"

commands = {
    brightness_up = "xbacklight -inc 5",
    brightness_down = "xbacklight -dec 5",
    -- rofi_run = "ulauncher-toggle",
    rofi_run = "rofi -show run",
    rofi_drun = "rofi -show drun",
    rofi_window = "rofi -show window",
    volume_up = "pactl set-sink-volume @DEFAULT_SINK@ +5%",
    volume_down = "pactl set-sink-volume @DEFAULT_SINK@ -5%",
    volume_mute = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
}

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
