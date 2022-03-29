from libqtile import hook
from libqtile.lazy import lazy
from libqtile.log_utils import logger
import subprocess
import psutil


def run_with_shell(command, only_once=True):
    try:
        if only_once:
            ps = command if type(command) == str else command[0]
            for proc in psutil.process_iter():
                if proc.name().lower() == ps:
                    logger.debug(f"{command} is running alredy.")
                    return
        subprocess.Popen(command, shell=True)
    except Exception as e:
        logger.exception(e)


@hook.subscribe.startup_once
def startup():
    app_list = ["nm-applet", "mpris-proxy", ["picom", "-b"], "blueman-applet"]
    for app in app_list:
        run_with_shell(app)


@hook.subscribe.client_new
def spotify(window):
    pid = window.get_pid()
    proc = psutil.Process(pid)
    if "spotify" in proc.name():
        window.togroup("music")
