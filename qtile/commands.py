from libqtile.command.client import InteractiveCommandClient
from libqtile.log_utils import logger
from libqtile.lazy import lazy

minimized_windows = []

@lazy.function
def minimize_current_window(qtile):
    logger.debug(f"{minimized_windows} is minimized_windows")
    if len(minimized_windows) > 0:
        logger.debug(f"Last minimized window {minimized_windows[-1]}")
       
    window = qtile.current_window.wid
    qtile.current_window.cmd_toggle_minimize()
    minimized_windows.append(window)

@lazy.function
def unminimize_last_window_in_group(qtile):
    minimized_in_workspace = [x for x in qtile.current_group.windows if x.minimized]
    found = False
    for window_id in reversed(minimized_windows):
        for i in minimized_in_workspace:
            if i.wid == window_id:
                i.cmd_toggle_minimize()
                minimized_windows.remove(i.wid)
                logger.debug(f"UNminimized {i}")
                break
        if found:
            break