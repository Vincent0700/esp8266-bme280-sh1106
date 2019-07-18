--
-- @name init_wifi.lua
-- @author vincent <wang.yuanqiu007@gmail.com>
-- @description Initialize Wifi with configuration
--

local init_wifi = function(config, auth, cb_success, cb_failed)

    wifi.setmode(wifi.STATION)
    wifi.sta.setip(config)
    wifi.sta.config(auth)
    wifi.sta.connect()

    local tmr_wifi = tmr.create()
    tmr_wifi:alarm(1000, tmr.ALARM_AUTO,
        function()
            if wifi.sta.getip() == nil then
                print("Waiting for IP ...")
            else
                local ip, netmask, gateway = wifi.sta.getip()
                if (ip == config.ip and gateway == config.gateway) then
                    print("Wifi is ready.")
                    cb_success()
                else
                    print("Cannot get IP.")
                    cb_failed()
                end
                tmr_wifi:stop()
            end
        end)

end

return init_wifi

