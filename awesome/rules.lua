local awful = require("awful")
local beautiful = require("beautiful")
local tags = require("tags")
local controls = require("controls")

colors = {
    "#21fc0d", "#fffc00", "#560a86", "#01d28e", "#ffd800",
    "#9d0b0b", "#f45905",
}

awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = controls.client.keys,
            buttons = controls.client.buttons,
            screen = awful.screen.preferred,
            titlebars_enabled = false,
            placement = awful.placement.no_overlap +
                awful.placement.no_offscreen,
        },
    }, -- Add titlebars to normal clients and dialogs
    {
        rule_any = {
            type = { "dialog" },
            class = { "pcmanfm" },
        },
        properties = {
            titlebars_enabled = true,
            floating = true,
        },
    }, { rule = {}, properties = { tag = tag9 } }, {
        rule_any = {
            class = {
                "Firefox", "firefox", "Navigator",
                "qutebrowser", "brave-browser",
                "Brave-browser",
            },
        },
        properties = { tag = tag1 },
    }, {
        rule_any = { class = { "kitty", "kitty" } },
        properties = {
            tag = tag2,
            border_width = 2,
            border_color = function()
                return colors[math.random(#colors)]
            end,
        },
    }, {
        rule_any = { class = { "spotify", "Spotify" } },
        properties = { tag = tag3 },
    }, {
        rule_any = {
            class = {
                "jetbrains-studio", "code", "Code", "emacs",
                "Emacs", "jetbrains-rider",
                "jetbrains-clion", "jetbrains-idea",
            },
        },
        properties = { tag = tag4 },
    }, {
        rule_any = { class = { "mpv", "vlc" } },
        properties = { tag = tag5 },
    }, {
        rule_any = {
            class = {
                "libreoffice", "libreoffice-startcenter",
                "libreoffice-draw", "et", "Et", -- WPS Spreadsheet
                "wps", "Wps", -- WPS Writer
                "wpp", "Wpp", -- WPS Presentation
                "wpspdf", "Wpspdf", -- WPS PDF
                "calibre-gui", "calibre",
                "calibre-ebook-viewer", "draw.io",
                "Inkscape",
            },
        },
        properties = { tag = tag6 },
    }, {
        rule_any = {
            class = {
                "Steam", "dontstarve_steam", "lutris",
                "Lutris", "faeria_steam", "terraria_steam",
                "heroic", "r5apex",
            },
        },
        properties = { tag = tag7 },
    }, {
        rule_any = {
            class = {
                "discord", "telegram-desktop",
                "TelegramDesktop", "skype", "Skype",
            },
        },
        properties = { tag = tag8 },
    },

}
