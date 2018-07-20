wifi.setmode(wifi.STATION)
--wifi.sta.config("Achim","60.Geburtstag")
wifi.sta.config({ssid="Achim",pwd="60.Geburtstag"})
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
      for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
        _GET[k] = v
      end
    end
    buf = buf .. "<!DOCTYPE html><html><body><h1>Hello, this is NodeMCU.</h1><form src=\"/\">Turn PIN1 <select name=\"pin\" onchange=\"form.submit()\"> "
    local _on, _off = "", ""
    if (_GET.pin == "ON") then
      _on = " selected=true"
    elseif (_GET.pin == "OFF") then
      _off = " selected=\"true\""
    end
    print(_GET.mtext)
    print(request)
    buf = buf .. "<option" .. _on .. ">ON</option><option" .. _off .. ">OFF</option></select><label for=\"mtext\">Morsetext: <input id=\"mtext\" name=\"mtext\"> </label><p/><input type=\"submit\" value=\"senden\"></form></body></html>"
    client:send(buf)
  end)
  conn:on("sent", function(c) c:close() end)
end)
