--
-- @name init_mqtt.lua
-- @author vincent <wang.yuanqiu007@gmail.com>
-- @description MQTT client for publishing
--

function init_mqtt(config, cb_connect, cb_disconnect, cb_publish)

    local client = mqtt.Client(config.id, config.timeout, config.username, config.password)

    local tmr_mqtt = tmr.create()
    local reconnect = function()
        tmr_mqtt:stop()
        tmr_mqtt:alarm(config.connect_rate, tmr.ALARM_AUTO, function()
            print("Connecting ...")
            client:close()
            client:connect(config.host, config.port, config.secure)
        end)
    end

    client:on("offline", function(client)
        print("Reconnecting ...")
        cb_disconnect()
        reconnect()
    end)

    client:on("connect", function(client)
        print("Connected MQTT server successfully.")
        cb_connect()
        tmr_mqtt:stop()
        tmr_mqtt:alarm(config.publish_rate,
            tmr.ALARM_AUTO,
            function()
                local result = cb_publish()
                if (result) then
                    client:publish(config.topic,
                        result,
                        config.qos,
                        config.retain,
                        function(client)
                            print("sent " .. result)
                        end)
                end
            end)
    end)

    print("Connecting MQTT server " .. config.host .. ":" .. config.port)
    reconnect()
end

return init_mqtt