from libqtile import configurable


class DecorationsMixin(configurable.Configurable):
    ''' This is Mixin version of qtile-extras modify
        to use decorations with user-made widgets.
    '''
    defaults = [
        ("decorations", [], "Used to decorate with qtile extras")
    ]

    def __init_subclass__(cls) -> None:
        super().__init_subclass__()
        DecorationsMixin.inject_decorations(cls)
        DecorationsMixin.inject_bar_border(cls)
    
    @staticmethod
    def inject_bar_border(classdef):
        @property
        def width(self):
            if self.bar.horizontal:
                return self.length
            return self.bar.width

        @property
        def height(self):
            if self.bar.horizontal:
                return self.bar.height
            return self.length

        def _offset_draw(self, offsetx=0, offsety=0, width=None, height=None):
            if self.bar.horizontal:
                self._realdraw(offsetx=offsetx, offsety=self.offsety, width=width, height=height)
            else:
                self._realdraw(offsetx=self.offsetx, offsety=offsety, width=width, height=height)

        def _configure(self, qtile, bar):
            self._old_bar_configure(qtile, bar)
            self._realdraw = self.drawer.draw
            self.drawer.draw = self._offset_draw

        if not hasattr(classdef, "_injected_offsets"):

            classdef._offset_draw = _offset_draw
            classdef._old_bar_configure = classdef._configure
            classdef._configure = _configure
            classdef._injected_offsets = True
            classdef.height = height
            classdef.width = width

    
    @staticmethod
    def inject_decorations(classdef):
        """
        Method to inject ability for widgets to display decorations.
        """

        def new_clear(self, colour):
            """Draw decorations after clearing background."""
            self._clear(colour)

            for decoration in self.decorations:
                decoration.draw()

        def configure_decorations(self):
            if hasattr(self, "decorations"):
                if not self.configured:
                    # Give each widget a copy of the decoration objects
                    temp_decs = []
                    for i, dec in enumerate(self.decorations):
                        cloned_dec = dec.clone()
                        cloned_dec._configure(self)
                        temp_decs.append(cloned_dec)
                    self.decorations = temp_decs

                self._clear = self.drawer.clear
                self.drawer.clear = self.new_clear

        def new_configure(self, qtile, bar):
            self.old_configure(qtile, bar)
            self.configure_decorations()

        if not hasattr(classdef, "_injected_decorations"):
            classdef.old_configure = classdef._configure
            classdef.new_clear = new_clear
            classdef.configure_decorations = configure_decorations
            classdef._configure = new_configure

            classdef.defaults.append(("decorations", [], "Decorations for widgets"))
            classdef._injected_decorations = True
