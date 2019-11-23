local awful = require("awful")
local beautiful = require("beautiful")
local tags = require("tags")
local controls = require("controls")

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = controls.client.keys,
                     buttons = controls.client.buttons,
                     screen = awful.screen.preferred,
                     titlebars_enabled = false,
                     tag = tag8,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
     }
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    { rule_any = { class = { "Firefox", "Navigator", "qutebrowser" } },
      properties = { tag = tag1 } },
    {
      rule_any = { class = { "kitty", "kitty" } },
      properties = { tag = tag2 }
    },
    {
      rule_any = { class = {
        "libreoffice", "libreoffice-startcenter",
        "et", "Et", -- WPS Spreadsheet
        "wps", "Wps", -- WPS Writer
        "wpp", "Wpp", -- WPS Presentation
        "wpspdf", "Wpspdf" -- WPS PDF
      } },
      properties = { tag = tag3 }
    },
    {
      rule_any = { class = { "jetbrains-studio", "code", "Code", "emacs", "Emacs" } },
      properties = { tag = tag4 }
    },
    {
      rule_any = { class = { "mpv", "spotify", "Spotify" } },
      properties = { tag = tag5 }
    },
    {
      rule_any = { class = { "discord", "telegram-desktop", "TelegramDesktop" } },
      properties = { tag = tag6 }
    },
    {
      rule_any = { class = { "Steam", "dontstarve_steam", "lutris", "faeria_steam" } },
      properties = { tag = tag7 }
    },
}