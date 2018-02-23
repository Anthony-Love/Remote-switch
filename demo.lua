id = '4567'
station_cfg={}
station_cfg.ssid="ssid"
station_cfg.pwd="pwd"
wifi.sta.config(station_cfg)

wifi.setmode(wifi.STATION)
wifi.sta.autoconnect(1)
led1 = 1  
led2 = 4  
gpio.mode(led1, gpio.OUTPUT)  
gpio.mode(led2, gpio.OUTPUT)
switch1 = "1关闭状态"
switch2 = "2关闭状态"
function startServer()
conn=net.createConnection(net.TCP, 0) 
conn:on("connection", function(conn, c)
conn:send(id)
tmr.alarm(2, 30000, 1, function() 
    conn:send(' ')
end)            
end)
conn:on("receive", function(conn, pl)
        print(pl)
        if(pl == "ON1")then  
            gpio.write(led1, gpio.LOW)
            switch1 = "1打开状态"
            print('on led1')
        elseif(pl == "OFF1")then  
            gpio.write(led1, gpio.HIGH)
            switch1 = "1关闭状态"
            print('off led1')
        elseif(pl == "ON2")then  
            gpio.write(led2, gpio.LOW)
            switch2 = "2打开状态"
            print('on led2')
        elseif(pl == "OFF2")then  
            gpio.write(led2, gpio.HIGH)
            switch2 = "2关闭状态"
            print('off led2')
        end

        buf="<head><meta http-equiv='Content-type' content='text/html; charset=utf-8'/></head>";     
        buf =buf.."<body><h1> ZAN Web control</h1>";  
        buf = buf.."<p>Switch <a href=\"ON1\"><button>ON</button></a> <a href=\"OFF1\"><button>OFF</button></a></p>"
        buf = buf.."<p>LED <a href=\"ON2\"><button>ON</button></a> <a href=\"OFF2\"><button>OFF</button></a></p>"..switch1.."<br>"..switch2.."<br>"..'<h3> Data To MCU:</h3><br>'..pl..'</body>';
        print(buf)
        conn:send(buf)
        print("ok")
        end)
conn:connect(8001,"www.zanyu.shop")
end
tmr.alarm(1, 1000, 1, function() 
   if wifi.sta.getip()==nil then
        print("Connect AP, Waiting...") 
   else
        tmr.stop(1)
        startServer()
      
   end
end)
