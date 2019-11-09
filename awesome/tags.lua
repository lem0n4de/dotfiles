local tyrannical = require("tyrannical")
local awful = require("awful")

-- TODO: Change names to icons
tyrannical.tags = {
    {
        name = "web",
        init = true,
        exclusive = true,
        no_focus_stealing_out = true,
        layout = awful.layout.suit.max,
        class = {
            "Firefox", "Navigator"
        }
    },
    {
        name = "term",
        init = true,
        exclusive = true,
        no_focus_stealing_out = true,
        layout = awful.layout.suit.spiral,
        class = {
            "kitty", "kitty",
        }
    },
    {
        name = "coms",
        init = true,
        exclusive = true,
        no_focus_stealing_out = true,
        layout = awful.layout.suit.floating,
        class = {
            "discord", "telegram-desktop", "TelegramDesktop",
        }
    },
    {
        name = "dev",
        init = true,
        exclusive = true,
        no_focus_stealing_out = true,
        layout = awful.layout.suit.max.fullscreen,
        class = {
            "jetbrains-studio", "code", "Code",
        }
    },
    {
        name = "media",
        init = true,
        exclusive = true,
        no_focus_stealing_out = true,
        layout = awful.layout.suit.max.fullscreen,
        class = {
            "mpv",
        }
    },
    {
        name = "doc",
        init = true,
        exclusive = true,
        no_focus_stealing_out = true,
        layout = awful.layout.suit.floating,
        class = {
            "libreoffice",
        }
    },
    {
        name = "other",
        init = true,
        exclusive = false,
        no_focus_stealing_out = true,
        layout = awful.layout.suit.floating,
        fallback = true
    }
}

tyrannical.properties.intrusive = {
    "ksnapshot"     , "pinentry"       , "gtksu"     , "kcalc"        , "xcalc"               ,
    "feh"           , "Gradient editor", "About KDE" , "Paste Special", "Background color"    ,
    "kcolorchooser" , "plasmoidviewer" , "Xephyr"    , "kruler"       , "plasmaengineexplorer",
}

tyrannical.properties.floating = {
    "MPlayer"      , "pinentry"        , "ksnapshot"  , "pinentry"     , "gtksu"          ,
    "xine"         , "feh"             , "kmix"       , "kcalc"        , "xcalc"          ,
    "yakuake"      , "Select Color$"   , "kruler"     , "kcolorchooser", "Paste Special"  ,
    "New Form"     , "Insert Picture"  , "kcharselect", "mythfrontend" , "plasmoidviewer"
}

-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {
    "Xephyr"       , "ksnapshot"       , "kruler"
}

tyrannical.settings.no_focus_stealing_out = true
tyrannical.settings.block_children_focus_stealing = true --Block popups ()
tyrannical.settings.group_children = true --Force popups/dialogs to have the same tags as the parent client
