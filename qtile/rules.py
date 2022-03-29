import re
from libqtile.config import Rule, Match

WEB_MATCHES = [Match(wm_class=["Firefox", "Navigator", "qutebrowser", "brave-browser",
                               "Brave-browser", "brave", "Brave"]), Match(title=["Brave"])]

TERM_MATCHES = [Match(wm_class=["kitty", "kitty"])]

DOC_MATCHES = [Match(wm_class=["libreoffice", "libreoffice-startcenter", "libreoffice-draw",
                               "et", "Et",  # WPS Spreadsheet
                               "wps", "Wps",  # WPS Writer
                               "wpp", "Wpp",  # WPS Presentation
                               "wpspdf", "Wpspdf",  # WPS PDF
                               "calibre-gui", "calibre", "calibre-ebook-viewer",
                               "draw.io"])]

DEV_MATCHES = [Match(wm_class=["jetbrains-studio", "code",
                     "Code", "emacs", "Emacs", "jetbrains-rider", "jetbrains-clion"])]

MEDIA_MATCHES = [Match(wm_class=["mpv", "vlc"])]
GAMING_MATCHES = [Match(wm_class=["Steam", "dontstarve_steam",
                                  "lutris", "Lutris", "faeria_steam", "terraria_steam"])]
MUSIC_MATCHES = [Match(wm_class=["spotify", "Spotify"])]
OTHER_MATCHES = [Match(wm_class=re.compile(".+"))]

RULES = [
    # dialogs
    Rule(Match(wm_class=["ulauncher", "Ulauncher", re.compile(".*ulauncher.*")]), float=True,
         intrusive=True),
    Rule(Match(wm_class=["pcmanfm", "Pcmanfm"]), float=True, intrusive=True),
    Rule(Match(wm_type=["dialog"]), float=True, intrusive=True)
]
