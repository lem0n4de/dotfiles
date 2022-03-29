from libqtile.widget import base
from libqtile.config import Key
from libqtile.log_utils import logger
from libqtile.lazy import lazy
from libqtile import images
import pulsectl_asyncio
import pulsectl
import asyncio
import pathlib
import cairocffi
from decorations_mixin import DecorationsMixin


async def _pulse_get_default_sink(
        pulse: pulsectl_asyncio.PulseAsync
    ) -> pulsectl_asyncio.pulsectl_async.PulseSinkInfo:
    default_sink_name = (await pulse.server_info()).default_sink_name
    return await pulse.get_sink_by_name(default_sink_name)


volume = 0
vc = 3


class VolumeWidget(base.ThreadPoolText, base.MarginMixin, base.PaddingMixin, DecorationsMixin):
    defaults = [
        ("configure_keys", None, "Configure XF86 keys. Pass the keys list or None"),
        ("volume_change", 5, "Percentage of volume change used by keys")]
    pulse_running = False
    poll_task: asyncio.Task = None

    def __init__(self, **config):
        super().__init__("", **config)
        self.add_defaults(VolumeWidget.defaults)
        self.add_defaults(base.PaddingMixin.defaults)
        self.add_defaults(base.MarginMixin.defaults)
        self.update_interval = None
        self.surfaces = {}
        global vc
        vc = self.volume_change

        if self.configure_keys != None:
            self.configure_keys.extend([
                Key([], "XF86AudioRaiseVolume", VolumeWidget.cmd_increase_volume,
                    desc="Increase volume by 5%"),
                Key([], "XF86AudioLowerVolume", VolumeWidget.cmd_decrease_volume,
                    desc="Decrease volume by 5%"),
                Key([], "XF86AudioMute", VolumeWidget.cmd_mute, desc="Mute")
            ])
            logger.debug("Keys extended.")

    def timer_setup(self):
        async def run():
            self.poll_task = asyncio.create_task(self.poll())
            self.poll_task.add_done_callback(
                lambda x: logger.debug("poll task done"))

        loop = asyncio.get_event_loop()
        loop.create_task(run())

    async def poll(self):
        try:
            async with pulsectl_asyncio.PulseAsync("VolumeWidget") as pulse:
                await self.update_volume(None)  # To draw widget
                async for event in pulse.subscribe_events('sink'):
                    await self.update_volume(event)
            return f"Volume: {volume}"
        except Exception as e:
            logger.exception(e)

    async def update_volume(self, event_info):
        done = False
        for i in range(5):
            if not done:
                try:
                    async with pulsectl_asyncio.PulseAsync("VolumeWidget") as pulse:
                        default_sink = await _pulse_get_default_sink(pulse)
                        volume = round(default_sink.volume.value_flat * 100)
                        mute = "MUTED" if default_sink.mute == 1 else ""
                        self.update(f"{mute} Volume: {volume}")
                        done = True
                except Exception as e:
                    logger.exception(e)
    
    def _configure(self, qtile, bar):
        super()._configure(qtile, bar)
    
    def setup_images(self):
        try:
            self.surfaces = {}

            files = [path for path in pathlib.Path("/home/lem0n/.dotfiles/qtile/wot").iterdir()]

            d_images = [images.Img.from_path(img.resolve()) for img in files]

            for img in d_images:
                # new_height = self.bar.height
                width = 10 
                img.resize(width=width)
                self.surfaces[img.name] = img.pattern
            logger.warn(self.surfaces)
        except Exception as e:
            logger.exception(e)
    

    # def draw(self):
    #     if len(self.surfaces) == 0:
    #         self.setup_images()
    #     self.drawer.clear(self.background or self.bar.background)
    #     self.drawer.ctx.set_source(self.surfaces["svg2"])
    #     self.drawer.ctx.paint()
    #     self.drawer.draw(offsetx=self.offset, width=self.length)

    @lazy.function
    def cmd_increase_volume(qtile):
        ### Async version somehow core dumps qtile
        # async def _cmd_increase_volume():
        #     async with pulsectl_asyncio.PulseAsync("VolumeWidget") as pulse:
        #         default_sink = await _pulse_get_default_sink(pulse)
        #         volume = default_sink.volume.value_flat + (vc/100)
        #         await pulse.volume_set_all_chans(default_sink, volume)
        # asyncio.create_task(_cmd_increase_volume()).add_done_callback(lambda x: logger.warn(f"VOLUME INCREASED: {x}"))
        global volume, vc
        with pulsectl.Pulse("VolumeWidget") as pulse:
            default_sink_name = pulse.server_info().default_sink_name
            default_sink = pulse.get_sink_by_name(default_sink_name)
            volume = default_sink.volume.value_flat + (vc/100)
            pulse.volume_set_all_chans(default_sink, volume)

    @lazy.function
    def cmd_decrease_volume(qtile):
        ### Async version somehow core dumps qtile
        # async def _cmd_decrease_volume():
        #     async with pulsectl_asyncio.PulseAsync("VolumeWidget") as pulse:
        #         default_sink = await _pulse_get_default_sink(pulse)
        #         volume = default_sink.volume.value_flat - (vc/100)
        #         await pulse.volume_set_all_chans(default_sink, volume)
        # asyncio.create_task(_cmd_decrease_volume()).add_done_callback(lambda x: logger.warn(f"VOLUME DECREASED: {x}"))
        global volume, vc
        with pulsectl.Pulse("VolumeWidget") as pulse:
            default_sink_name = pulse.server_info().default_sink_name
            default_sink = pulse.get_sink_by_name(default_sink_name)
            volume = default_sink.volume.value_flat - (vc/100)
            pulse.volume_set_all_chans(default_sink, volume)
    
    @lazy.function
    def cmd_mute(qtile):
        # async def _cmd_mute():
        #     async with pulsectl_asyncio.PulseAsync("VolumeWidget") as pulse:
        #         default_sink = await _pulse_get_default_sink(pulse)
        #         await pulse.mute(default_sink)
        # asyncio.create_task(_cmd_mute()).add_done_callback(lambda x: logger.warn(f"VOLUME MUTED: {x}"))
        with pulsectl.Pulse("VolumeWidget") as pulse:
            default_sink_name = pulse.server_info().default_sink_name
            default_sink = pulse.get_sink_by_name(default_sink_name)
            pulse.mute(default_sink, mute = not default_sink.mute)


# ['__abstractmethods__', '__annotations__', '__class__', '__delattr__', '__dict__',
#  '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__gt__',
#  '__hash__', '__init__', '__init_subclass__', '__le__', '__lt__', '__module__', '__ne__',
#  '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__',
#  '__subclasshook__', '__weakref__', '_abc_impl', '_drag', '_eventloop', '_finalize_configurables',
#  '_find_closest_closest', '_get_command_signature', '_items', '_prepare_socket_path', '_process_screens',
#  '_select', '_state', '_stop', '_stopped_event', 'add_group', 'async_loop', 'call_later', 'call_soon',
#  'call_soon_threadsafe', 'chord_stack', 'cmd_add_rule', 'cmd_addgroup', 'cmd_commands', 'cmd_critical',
#  'cmd_debug', 'cmd_delgroup', 'cmd_display_kb', 'cmd_doc', 'cmd_error', 'cmd_eval',
#  'cmd_findwindow', 'cmd_function', 'cmd_get_state', 'cmd_get_test_data', 'cmd_groups', 'cmd_hide_show_bar', 'cmd_info', 'cmd_internal_windows', 'cmd_items', 'cmd_labelgroup', 'cmd_list_widgets', 'cmd_loglevel', 'cmd_loglevelname', 'cmd_next_layout', 'cmd_next_screen', 'cmd_next_urgent', 'cmd_pause', 'cmd_prev_layout', 'cmd_prev_screen', 'cmd_qtile_info', 'cmd_qtilecmd',
#     'cmd_reconfigure_screens', 'cmd_reload_config', 'cmd_remove_rule', 'cmd_restart',
#     'cmd_run_extension', 'cmd_screens', 'cmd_shutdown', 'cmd_simulate_keypress', 'cmd_spawn',
#     'cmd_spawncmd', 'cmd_status', 'cmd_switch_groups', 'cmd_switchgroup', 'cmd_sync',
#     'cmd_to_layout_index', 'cmd_to_screen', 'cmd_togroup', 'cmd_tracemalloc_dump',
#     'cmd_tracemalloc_toggle', 'cmd_ungrab_all_chords', 'cmd_ungrab_chord', 'cmd_validate_config',
#     'cmd_warning', 'cmd_windows', 'command', 'commands', 'config', 'core', 'current_group',
#     'current_layout', 'current_screen', 'current_window', 'delete_group', 'dgroups',
#     'dump_state', 'finalize', 'find_closest_screen', 'find_screen', 'find_window',
#     'focus_screen', 'free_reserved_space', 'grab_button', 'grab_chord', 'grab_key',
#     'grab_keys', 'groups', 'groups_map', 'items', 'keys_map', 'load_config', 'loop',
#     'manage', 'mouse_map', 'move_to_group', 'no_spawn', 'paint_screen', 'process_button_click',
#     'process_button_motion', 'process_button_release', 'process_key_event', 'register_widget',
#     'reserve_space', 'restart', 'run_in_executor', 'screens', 'select', 'server', 'socket_path',
#     'stop', 'ungrab_key', 'ungrab_keys', 'unmanage', 'update_desktops', 'warp_to_screen',
#     'widgets_map', 'windows_map']
