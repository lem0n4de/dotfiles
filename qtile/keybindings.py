from libqtile.config import Key
from libqtile.lazy import lazy

import commands
from workspaces import get_workspaces_list

MOD = "mod4"
TERMINAL = "kitty"


def get_keybindings():
    _keys = [
        # A list of available commands that can be bound to keys can be found
        # at https://docs.qtile.org/en/latest/manual/config/lazy.html

        # Switch between windows
        Key([MOD], "h", lazy.layout.left(), desc="Move focus to left"),
        Key([MOD], "l", lazy.layout.right(), desc="Move focus to right"),
        Key([MOD], "j", lazy.layout.down(), desc="Move focus down"),
        Key([MOD], "k", lazy.layout.up(), desc="Move focus up"),
        Key([MOD], "space", lazy.layout.next(),
            desc="Move window focus to other window"),

        # Move windows between left/right columns or move up/down in current stack.
        # Moving out of range in Columns layout will create new column.
        Key([MOD, "shift"], "h", lazy.layout.shuffle_left(),
            desc="Move window to the left"),
        Key([MOD, "shift"], "l", lazy.layout.shuffle_right(),
            desc="Move window to the right"),
        Key([MOD, "shift"], "j", lazy.layout.shuffle_down(),
            desc="Move window down"),
        Key([MOD, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

        # Grow windows. If current window is on the edge of screen and direction
        # will be to screen edge - window would shrink.
        Key([MOD, "control"], "h", lazy.layout.grow_left(),
            desc="Grow window to the left"),
        Key([MOD, "control"], "l", lazy.layout.grow_right(),
            desc="Grow window to the right"),
        Key([MOD, "control"], "j", lazy.layout.grow_down(),
            desc="Grow window down"),
        Key([MOD, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
        Key([MOD, "control"], "n", commands.unminimize_last_window_in_group(),
            desc="Reset all window sizes"),
        Key([MOD], "n", commands.minimize_current_window(), desc="Minimize window"),

        # Toggle between split and unsplit sides of stack.
        # Split = all windows displayed
        # Unsplit = 1 window displayed, like Max layout, but still with
        # multiple stack panes
        Key([MOD, "shift"], "Return", lazy.layout.toggle_split(),
            desc="Toggle between split and unsplit sides of stack"),
        Key([MOD], "Return", lazy.spawn(TERMINAL), desc="Launch terminal"),

        # Toggle between different layouts as defined below
        Key([MOD, "shift"], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
        Key([MOD], "q", lazy.window.kill(), desc="Kill focused window"),

        Key([MOD, "control"], "r", lazy.restart(), desc="Reload the config"),
        Key([MOD, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

        # Custom commands
        Key([MOD], "Tab", lazy.group.next_window(), desc="Focus next window"),
        Key([MOD], "f", lazy.window.toggle_floating(), desc="Toggle floating"),
        Key([], "XF86MonBrightnessUp", lazy.spawn(
            "xbacklight -inc 5"), desc="Increase brightness by 5%"),
        Key([], "XF86MonBrightnessDown", lazy.spawn(
            "xbacklight -dec 5"), desc="Decrease brightness by 5%"),
        Key([MOD], "r", lazy.spawn("sh -c 'PATH=$PATH:$HOME/.local/bin:$HOME/.dotfiles/bin rofi -show run'"), # "ulauncher-toggle"),
            desc="Run launcher application"),
        Key([MOD], "w", lazy.spawn("rofi -show window"),
            desc="Show rofi window list"),
        # Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"), desc="Increase volume by 5%"),
        # Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"), desc="Decrease volume by 5%"),
        # Key([], "XF86AudioMute", lazy.spawn(
        #     "pactl set-sink-mute @DEFAULT_SINK@ toggle"), desc="Mute"),
        Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"), desc="Mute"),
        Key([], "XF86AudioPause", lazy.spawn("playerctl play-pause"), desc="Mute"),
    ]

    for i, g in enumerate(get_workspaces_list()):
        _keys.extend([
            Key([MOD], f"{i+1}", lazy.group[g.name].toscreen(),
                desc="Switch to group {}".format(g.name)),
            Key([MOD, "shift"], f"{i+1}", lazy.window.togroup(g.name, switch_group=False),
                desc="Switch to & move focused window to group {}".format(g.name))
        ])

    return _keys
