from turtle import color
from typing import List  # noqa: F401
import os

from libqtile import bar, layout
from libqtile.config import Click, Drag, Match, Screen
from libqtile.lazy import lazy
from libqtile.log_utils import logger

from qtile_extras import widget
from qtile_extras.widget.decorations import RectDecoration
from rules import RULES
from theme import Catpuccin, WheelOfTime
import hooks
import workspaces
import keybindings


keys = keybindings.get_keybindings()
groups = workspaces.get_workspaces_list()

layouts = [
    layout.Columns(border_focus_stack=['#d75f5f', '#8f3d3d'], border_width=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='Liberation',
    fontsize=13,
    padding=3,
)
extension_defaults = widget_defaults.copy()
sl = 15

def get_decor(color, border_color = None):
    return [
        RectDecoration(colour=color, radius=10, filled=True, padding_y=3),
        RectDecoration(colour=border_color if border_color else color, radius=12, filled=False, padding=2),
    ]
screens = [
    Screen(
        wallpaper=f"{os.getenv('HOME')}/Pictures/wallpapers/wall",
        top=bar.Bar(
            [
                widget.Spacer(length=sl),
                widget.GroupBox(
                    fontsize=15,
                    rounded=True,
                    decorations = [
                        RectDecoration(colour=WheelOfTime.DARK1, radius=10, filled=True, padding_y=3),
                        RectDecoration(colour=WheelOfTime.BLUE, radius=10, filled=False, padding=2),
                        ],
                    padding = 10,
                    padding_y = [0, 2],
                    margin=5,
                    highlight_method = "text",
                    inactive = WheelOfTime.DARK_BLUE, # NO PROGRAM OPEN BUT NOT FOCUSED
                    active = WheelOfTime.BROWN, # HAS A PROGRAM OPEN BUT NOT FOCUSED
                    this_current_screen_border = WheelOfTime.BLUE, # FOCUSED
                    urgent_color = WheelOfTime.LIGHT1,
                    borderwidth=2,
                    ),
                widget.Spacer(length=sl),
                widget.CurrentLayout(
                    decorations = get_decor(WheelOfTime.DARK_BROWN, WheelOfTime.BROWN),
                    foreground = WheelOfTime.BROWN,
                    padding = 10,
                ),
                widget.Spacer(length=sl),
                widget.TaskList(
                    rounded = True,
                    highlight_method = "block",
                    border = WheelOfTime.DARK_RED,
                    foreground = WheelOfTime.WHITE),
                widget.Spacer(length=sl),
                widget.Systray(),
                widget.Spacer(length=sl),
                widget.PulseVolume(
                    get_volume_command="pactl get-sink-volume @DEFAULT_SINK@ | grep '[0-9][0-9]*%' -o | head -1 | tr -d '%'",
                    mute_command="pactl set-sink-mute @DEFAULT_SINK@ toggle",
                    volume_up_command="pactl set-sink-volume @DEFAULT_SINK@ +5%",
                    volume_down_command="pactl set-sink-volume @DEFAULT_SINK@ -5%",
                    decorations = get_decor(WheelOfTime.DARK_GREEN, WheelOfTime.GREEN),
                    padding = 10),
                widget.Spacer(length=sl),
                widget.Backlight(
                    backlight_name="amdgpu_bl0",
                    fmt="Brightness: {}",
                    decorations = get_decor(WheelOfTime.DARK_YELLOW, WheelOfTime.YELLOW),
                    padding = 10),
                widget.Spacer(length=sl),
                widget.Battery(
                    update_interval=5,
                    decorations = get_decor(WheelOfTime.DARK_GRAY, WheelOfTime.GRAY),
                    foreground = WheelOfTime.GRAY,
                    padding = 10),
                widget.Spacer(length=sl),
                widget.Clock(
                    format='%Y-%m-%d %a %I:%M %p',
                    decorations = get_decor(WheelOfTime.DARK1, WheelOfTime.BLUE),
                    foreground = WheelOfTime.BLUE,
                    padding = 10),
                widget.Spacer(length=sl),
                widget.QuickExit(
                    decorations = get_decor(WheelOfTime.DARK_RED, WheelOfTime.RED),
                    foreground = WheelOfTime.RED,
                    padding = 10
                ),
            ],
            32,
            opacity = 1,
            background = "#00000000",
            border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            border_color=["#00000000", "000000", "#00000007", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([keybindings.MOD], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([keybindings.MOD], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([keybindings.MOD], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = RULES  # type: List
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
