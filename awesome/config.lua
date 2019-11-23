-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("VISUAL") or os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor
commands = {
    brightness_up = "xbacklight -inc 5",
    brightness_down = "xbacklight -dec 5",
    rofi_run = "rofi -matching regex -show run",
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