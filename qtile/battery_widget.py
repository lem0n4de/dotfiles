from pickletools import string1
import psutil as ps
from libqtile.log_utils import logger
from libqtile.widget import base

from decorations_mixin import DecorationsMixin


class BatteryWidget(base.ThreadPoolText, base.MarginMixin, base.PaddingMixin, DecorationsMixin):
    defaults = [
        ("charging_indicator", "^", "Charging indicator character."),
        ("update_interval", 5, "Update interval in seconds")
    ]

    def __init__(self, **config):
        super().__init__("", **config)
        self.add_defaults(BatteryWidget.defaults)
        self.add_defaults(base.MarginMixin.defaults)
        self.add_defaults(base.PaddingMixin.defaults)

    def poll(self):
        percent, secsleft, plugged = ps.sensors_battery()
        str = ""
        if plugged:
            str += self.charging_indicator + " "
        str += f"Battery: {round(percent, 2)}%"
        return str
