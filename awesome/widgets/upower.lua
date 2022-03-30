local inspect = require "inspect"
local dp = require "dbus_proxy"

upower = {
    properties_proxy = nil,
    device_proxy = nil,
    on_state_unknown = nil,
    on_state_charging = nil,
    on_state_discharging = nil,
    on_state_empty = nil,
    on_state_fully_charged = nil,
    on_state_pending_charge = nil,
    on_state_pending_discharge = nil
}

info = {
    state = nil
}

local function call_if_not_nil(f, ...)
    local arg = {...}
    if type(f) == "function" then f(arg) end
end

function upower:run_callbacks(state)
    local s = state or self.device_proxy.State
    if s then
        if s == 0 then
            -- print("STATE UNKNOWN")
            call_if_not_nil(self.on_state_unknown)
        elseif s == 1 then
            -- print("CHARGING")
            call_if_not_nil(self.on_state_charging)
        elseif s == 2 then
            -- print("DISCHARGING")
            call_if_not_nil(self.on_state_discharging)
        elseif s == 3 then
            -- print("EMPTY")
            call_if_not_nil(self.on_state_empty)
        elseif s == 4 then
            -- print("FULLY CHARGED")
            call_if_not_nil(self.on_state_fully_charged)
        elseif s == 5 then
            -- print("PLUGGED BUT NOT CHARGING")
            call_if_not_nil(self.on_state_pending_charge)
        elseif s == 6 then
            -- print("PENDING DISCHARGE????")
            call_if_not_nil(self.on_state_pending_discharge)
        end
    end
end

function upower:on_properties_changed_callback()
    return function(property_proxy, appeared)
        if appeared then
            -- proxy.is_connected is true
            print("proxy connected")
            property_proxy:connect_signal(function(p, x, y)
                assert(p == property_proxy)
                self:run_callbacks(y.State)
            end, "PropertiesChanged")

        else
            -- proxy.is_connected is false
            print("proxy not connected")
        end
    end
end

function upower:init_device_proxy()
    self.device_proxy = dp.Proxy:new({
        bus = dp.Bus.SYSTEM,
        name = "org.freedesktop.UPower",
        interface = "org.freedesktop.UPower.Device",
        path = "/org/freedesktop/UPower/devices/battery_BAT0"
    })

    print("Percentage and state is: ", self.device_proxy.Percentage,
          self.device_proxy.State)
end

function upower:init_properties_proxy()
    self.properties_proxy = dp.monitored.new({
        bus = dp.Bus.SYSTEM,
        name = "org.freedesktop.UPower",
        interface = "org.freedesktop.DBus.Properties",
        path = "/org/freedesktop/UPower/devices/battery_BAT0"
    }, upower:on_properties_changed_callback())
end

function upower:init()
    self.__index = self
    self:init_properties_proxy()
    self:init_device_proxy()
end

return upower
