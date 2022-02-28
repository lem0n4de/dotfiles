from re import sub
from libqtile import hook
from libqtile.lazy import lazy
from libqtile.log_utils import logger
import subprocess
import psutil

@hook.subscribe.startup_once
def startup():
    try:
        subprocess.Popen(["nm-applet"], shell=True)
        subprocess.Popen("mpris-proxy", shell=True)
        subprocess.Popen("picom -b", shell=True)
        subprocess.Popen("ulauncher --hide-window --no-window-shadow", shell=True)
    except Exception as e:
        logger.exception(e)


@hook.subscribe.client_new
def spotify(window):
    pid = window.get_pid()
    proc = psutil.Process(pid)
    if "spotify" in proc.name():
        window.togroup("music")
        
