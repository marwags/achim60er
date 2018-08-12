require("morse")

textfile = "morse.txt";
originalfile = "original.txt";

wifi.setmode(wifi.STATION)
--wifi.sta.config("Achim","60.Geburtstag")
wifi.sta.config({ssid="Achim",pwd="60.Geburtstag"})
wifi.sta.sethostname("Karte")
print(wifi.sta.getip())
srv = net.createServer(net.TCP)
srv:listen(80, function(conn)
  conn:on("receive", function(client, request)
    local buf = ""
    local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP")
    if (method == nil) then
      _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP")
    end
    local _GET = {}
    if (vars ~= nil) then
      for k, v in string.gmatch(vars, "(%w+)=([%w%+%d%%_]+)&*") do
        _GET[k] = v
      end
    end
    if _GET.mtext == nil then
        _GET.mtext = ""
    end
    local unescape = function(url)
      url = url:gsub("+", " ")
      url = url:gsub("%%(%x%x)", function(x)
          return string.char(tonumber(x, 16))
        end)
      return string.lower(url)
    end
    local mtext = unescape(_GET.mtext)
    print(mtext)
    if mtext == nil or mtext == "" then
        local mf = file.open( textfile, "r")
        if mf then
            mtext = mf:read()
            mf:close()
            mf = nil
        else
            mtext = ""
        end
    end
    buf = buf .. "<!DOCTYPE html><html><body><h1>Gl&uuml;ckwunsch zum 60., Achim.</h1><form src=\"/\"> "
    buf = buf .. "<label for=\"mtext\">Morsetext: <input id=\"mtext\" name=\"mtext\" value=\"" .. mtext .. "\" size=\"100\"> </label><p/><input type=\"submit\" value=\"senden\"></form></body></html>"
    client:send(buf)

    mf = file.open( textfile, "w+")
    if mf then
        if mtext == "reset" then
            local of = file.open( originalfile, "r");
            if of then
                mf:write(of:read());
            end
            mtext = ""
        elseif mtext == "renew" then
           file.rename( "init.lua", "alt.lua")
        else
           mf:write(mtext)
        end
        mf:close()
        mf = nil
    end
  end)
  conn:on("sent", function(c) c:close() end)
end)

ws2812.init();

feuertonne = 1;
ersteLaterne = 2;
hauslicht = 7;

i, j, m, buffer = 0, 0, 0, ws2812.newBuffer(10, 3);
buffer:fill( 0, 0, 0); 

buffer:set(hauslicht, 70, 200, 10);

tmr.create():alarm(150, tmr.ALARM_AUTO, function()
  i = (i + 70) % 120
  j = (j + 12) % 40
  buffer:set(feuertonne, j + 10, i + 100, 5)
  ws2812.write(buffer)
end)

morse.init( buffer, ersteLaterne, 50, 50, 20, 200)
morse.start()

