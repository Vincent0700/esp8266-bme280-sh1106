--[[
    @name mqtt_publisher.lua
    @author vincent <wang.yuanqiu007@gmail.com>
    @desciption MQTT client for publishing
--]]

function mqtt_publisher(MQTT_CONFIG, cb_connect, cb_publish)

    local tmr_mqtt = tmr.create()
    local client = mqtt.Client(
        MQTT_CONFIG.id, 
        MQTT_CONFIG.timeout, 
        MQTT_CONFIG.username, 
        MQTT_CONFIG.password
    )

    client:on("offline", function(client) 
        print ("Reconnecting ...")
        reconnect()
    end)

    client:on("connect", function(client)
        print("Connected MQTT server successfully.")
        cb_connect()
        tmr_mqtt:stop()
        tmr_mqtt:alarm(
            MQTT_CONFIG.publish_rate,
            tmr.ALARM_AUTO,
            function()
                result = cb_publish()
                if (result) then
                    client:publish(
                        MQTT_CONFIG.topic,
                        result,
                        MQTT_CONFIG.qos,
                        MQTT_CONFIG.retain,
                        function(client)
                            print("sent " .. result)
                        end
                    )
                end
            end
        )
    end)
    
    function reconnect()
        tmr_mqtt:stop()
        tmr_mqtt:alarm(MQTT_CONFIG.connect_rate, tmr.ALARM_AUTO, function()
            print("Connecting ...")
            client:close()
            client:connect(MQTT_CONFIG.host, MQTT_CONFIG.port, MQTT_CONFIG.secure)
        end)
    end

    print("Connecting MQTT server " .. MQTT_CONFIG.host .. ":" .. MQTT_CONFIG.port)
    reconnect()
end

return mqtt_publisher