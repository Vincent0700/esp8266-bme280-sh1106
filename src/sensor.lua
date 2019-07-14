--[[
    @name sensor.lua
    @author vincent <wang.yuanqiu007@gmail.com>
    @desciption A package of module bme280
--]]

local Sensor = {}

function Sensor:init()
    local sda, scl = 1, 2
    i2c.setup(0, sda, scl, i2c.SLOW)
    bme280.setup()
end

function Sensor:getData()
    local T, P, H, QNH = bme280.read(alt)
    local Tsgn = (T < 0 and -1 or 1)
    T = Tsgn * T
    T = string.format("%s%d.%02d", Tsgn < 0 and "-" or "", T / 100, T % 100)
    P = string.format("%d.%03d", P / 1000, P % 1000)
    H = string.format("%d.%03d", H / 1000, H % 1000)
    return T, P, H
end

return Sensor
