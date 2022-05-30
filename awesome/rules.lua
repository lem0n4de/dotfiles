local awful = require "awful"
local beautiful = require "beautiful"
local tags = require "tags"
local controls = require "controls"
local ruled = require "ruled"
colors = {
    "#21fc0d",
    "#fffc00",
    "#560a86",
    "#01d28e",
    "#ffd800",
    "#9d0b0b",
    "#f45905",
}

ruled.client.append_rules {
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
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            tag = tags.tag9
        },
    }, -- Add titlebars to normal clients and dialogs
    {
        rule_any = {
            type = { "dialog" },
            class = { "Pcmanfm", "pcmanfm" },
        },
        properties = {
            titlebars_enabled = true,
            floating = true,
        },
    },
    {
        rule_any = {
            class = {
                "Firefox",
                "firefox",
                "Navigator",
                "qutebrowser",
                "brave-browser",
                "Brave-browser",
            },
        },
        properties = { tag = tags.tag1 },
    },
    {
        rule_any = { class = { "kitty", "kitty" } },
        properties = {
            tag = tags.tag2,
            border_width = 2,
            border_color = function()
                return colors[math.random(#colors)]
            end,
        },
    },
    {
        rule_any = { class = { "spotify", "Spotify" } },
        properties = { tag = tags.tag3 },
    },
    {
        rule_any = {
            class = {
                "jetbrains-studio",
                "code",
                "Code",
                "emacs",
                "Emacs",
                "jetbrains-rider",
                "jetbrains-idea",
                "jetbrains-clion",
                "jetbrains-clion",
                "qtcreator",
                "QtCreator",
            },
        },
        properties = { tag = tags.tag4 },
    },
    {
        rule_any = { class = { "mpv", "vlc" } },
        properties = { tag = tags.tag5 },
    },
    {
        rule_any = {
            class = {
                "libreoffice",
                "libreoffice-startcenter",
                "libreoffice-draw",
                "^et$", -- WPS Spreadsheet
                "^wps$", -- WPS Writer
                "^wpp$", -- WPS Presentation
                "pdf", -- WPS PDF
                "calibre-gui",
                "calibre",
                "calibre-ebook-viewer",
                "draw.io",
                "Inkscape",
                "anki",
                "Anki",
            },
        },
        properties = { tag = tags.tag6 },
    },
    {
        rule_any = {
            class = {
                "Steam",
                "dontstarve_steam",
                "lutris",
                "Lutris",
                "faeria_steam",
                "terraria_steam",
                "heroic",
                "r5apex",
                "rocketleague.exe"
            },
        },
        properties = { tag = tags.tag7 },
    },
    {
        rule_any = {
            class = {
                "discord",
                "telegram-desktop",
                "TelegramDesktop",
                "skype",
                "Skype",
            },
        },
        properties = { tag = tags.tag8 },
    },
}
