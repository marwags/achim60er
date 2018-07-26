textfile = "morse.txt";
originalfile = "original.txt";

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
      for k, v in string.gmatch(vars, "(%w+)=([%w%+%d%%_]+)&*") do
        _GET[k] = v
      end
    end
    if _GET.mtext == nil then
        _GET.mtext = ""
    end
    local hex_to_char = function(x)
      return string.char(tonumber(x, 16))
    end
    
    local unescape = function(url)
      return url:gsub("%%(%x%x)", hex_to_char)
    end
    local mtext = string.lower(string.gsub(unescape(_GET.mtext), "+", " "))
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
    buf = buf .. "<label for=\"mtext\">Morsetext: <input id=\"mtext\" name=\"mtext\" value=\"\"> </label><p/><input type=\"submit\" value=\"senden\" size=\"100\"></form></body></html>"
    client:send(buf)

    mf = file.open( textfile, "w+")
    if mf then
        if mtext == "reset" then
            local of = file.open( originalfile, "r");
            if of then
                mf:write(of:read());
            end
            mtext = ""
        else
           mf:write(mtext)
        end
        mf:close()
        mf = nil
    end
  end)
  conn:on("sent", function(c) c:close() end)
end)
