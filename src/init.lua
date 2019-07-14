--[[
    @name init.lua
    @author vincent <wang.yuanqiu007@gmail.com>
    @desciption Entrypoint
--]]

--------------------------------------------------
---- Initialize Variables
--------------------------------------------------

local WIFI_AUTH = {}
local WIFI_CONFIG = {}

WIFI_AUTH.ssid = "VINCENT"
WIFI_AUTH.pwd = "wgy12345"
WIFI_AUTH.save = false
WIFI_CONFIG.ip = "192.168.50.21"
WIFI_CONFIG.netmask = "255.255.255.0"
WIFI_CONFIG.gateway = "192.168.50.1"

local ui = require("ui")
local sensor = require("sensor")

local t1 = tmr.create()
local t2 = tmr.create()

--------------------------------------------------
---- Setup Screen & Sensor
--------------------------------------------------

print("Setting up Screen & Sensor ...")

ui:init()
sensor:init()

ui:drawLabel(0, "Addr")
ui:drawLabel(1, "Temp")
ui:drawLabel(2, "Pres")
ui:drawLabel(3, "Humi")
ui:drawValue(0, "Connecting")
ui:flush()

t1:alarm(
    1000,
    tmr.ALARM_AUTO,
    function()
        T, P, H = sensor:getData()
        ui:drawValue(1, T .. " C")
        ui:drawValue(2, P .. " Pa")
        ui:drawValue(3, H .. " %")
        ui:flush()
    end
)

--------------------------------------------------
---- Setup Wifi
--------------------------------------------------

print("Setting up Wifi ...")

wifi.setmode(wifi.STATION)
wifi.sta.setip(WIFI_CONFIG)
wifi.sta.config(WIFI_AUTH)
wifi.sta.connect()

t2:alarm(
    1000,
    tmr.ALARM_AUTO, 
    function()
        if wifi.sta.getip() == nil then
            print("Waiting for IP ...")
        else
            ip, netmask, gateway = wifi.sta.getip()
            if (ip == WIFI_CONFIG.ip and gateway == WIFI_CONFIG.gateway) then
                ui:drawValue(0, WIFI_CONFIG.ip)
                print("Wifi is ready.")
            else
                ui:drawValue(0, "Error")
                print("Cannot get IP.")
            end
            t2:stop()
        end
    end
)
