--
-- @name init.lua
-- @author vincent <wang.yuanqiu007@gmail.com>
-- @description Entrypoint
--

--------------------------------------------------
---- Initialize Variables
--------------------------------------------------

local WIFI_AUTH = {}
local WIFI_CONFIG = {}
local SENSOR_CONFIG = {}
local MQTT_CONFIG = {}

SENSOR_CONFIG.rate = 3000

WIFI_AUTH.ssid = "VINCENT"
WIFI_AUTH.pwd = "wgy12345"
WIFI_AUTH.save = false
WIFI_CONFIG.ip = "192.168.50.21"
WIFI_CONFIG.netmask = "255.255.255.0"
WIFI_CONFIG.gateway = "192.168.50.1"

MQTT_CONFIG.host = "192.168.50.193"
MQTT_CONFIG.port = 1883
MQTT_CONFIG.username = "Vincent0700"
MQTT_CONFIG.password = "Secret123"
MQTT_CONFIG.connect_rate = 2000
MQTT_CONFIG.publish_rate = 10000
MQTT_CONFIG.id = "bme280_dev"
MQTT_CONFIG.timeout = 120
MQTT_CONFIG.topic = "/sensor"
MQTT_CONFIG.secure = 0
MQTT_CONFIG.qos = 0
MQTT_CONFIG.retain = 0

local ui = require("ui")
local sensor = require("sensor")
local init_wifi = require("init_wifi")
local init_mqtt = require("init_mqtt")

local tmr_disp = tmr.create()
local json_data = nil

--------------------------------------------------
---- Setup Screen & Sensor
--------------------------------------------------

print("Setting up Screen ...")

ui:init()
ui:drawLabel(0, "Stat")
ui:drawLabel(1, "Temp")
ui:drawLabel(2, "Pres")
ui:drawLabel(3, "Humi")
ui:drawValue(0, "Init BME280")
ui:flush()

sensor:init()
tmr_disp:alarm(SENSOR_CONFIG.rate,
    tmr.ALARM_AUTO,
    function()
        local T, P, H = sensor:getData()
        json_data = sjson.encode({ temp = T, pres = P, humi = H })
        ui:drawValue(1, T .. " C")
        ui:drawValue(2, P .. " Pa")
        ui:drawValue(3, H .. " %")
        ui:flush()
    end)

--------------------------------------------------
---- Setup WIFI
--------------------------------------------------

print("Setting up WIFI ...")
ui:drawValue(0, "Connect WIFI")

init_wifi(WIFI_CONFIG, WIFI_AUTH,
    function()
        -- Setup MQTT Client
        ui:drawValue(0, "Connect MQTT")

        local n = 0
        init_mqtt(MQTT_CONFIG,
            function() ui:drawValue(0, "Preparing") end,
            function() ui:drawValue(0, "Connect MQTT") end,
            function()
                n = (n + 1) % 16
                ui:drawValue(0, string.rep(">", n))
                return json_data
            end)
    end,
    function()
        -- Connect Error
        ui:drawValue(0, "Error")
    end)
