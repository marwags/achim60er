ws2812.init()

i, j, buffer = 0, 0, ws2812.newBuffer(10, 3);
buffer:fill( 0, 0, 0); 

slf = 1; -- erste Straßenlaterne
sl1 = slf;
sl2 = slf + 1;
sl3 = slf + 2;
sl4 = slf + 3;
sld = sl3; -- defekte Straßenlaterne
slhk = 20; -- Helligkeit

dit = 200; -- ms für ein dit
dah = dit * 3;

textfile = "morse.txt";
text=file.open( textfile, "r");
charBuffer = "";

-- Straßenlaternen
buffer:set(sl1, slhk, slhk, slhk);
buffer:set(sl2, slhk, slhk, slhk);
buffer:set(sl3, slhk, slhk, slhk);
buffer:set(sl4, slhk, slhk, slhk);

buffer:set(sld, 0, 0, 0)
ws2812.write(buffer)

abc = function()
    buffer:set(sld, 0, 100, 0)
    ws2812.write(buffer)
end

xyz = function()
    print("xyz")
    buffer:set(sld, slhk, slhk, slhk)
    ws2812.write(buffer)
    tmr.create():alarm( 10000, tmr.ALARM_SINGLE, function()
        buffer:set(sld, 0, 0, 0)
        ws2812.write(buffer)
        tmr.create():alarm( 1000, tmr.ALARM_SINGLE, abc);
    end)
end

singleChar = function()
    --print(charBuffer)
    if string.len(charBuffer) > 0 then
        local c = string.sub(charBuffer,1,1);
        charBuffer = string.sub(charBuffer, 2)
        if c == "1" then
            buffer:set(sld, slhk, slhk, slhk)
            tmr.create():alarm( dit, tmr.ALARM_SINGLE, singleChar);
        elseif c == "2" then
            buffer:set(sld, slhk, slhk, slhk)
            tmr.create():alarm( dah, tmr.ALARM_SINGLE, singleChar);
        else
            buffer:set(sld, 0, 0, 0)
            tmr.create():alarm( dit, tmr.ALARM_SINGLE, singleChar);
        end
    else
        buffer:set(sld, 0, 0, 0)
        tmr.create():alarm( dah, tmr.ALARM_SINGLE, abc);
--[[
        tmr.create():alarm( 50, tmr.ALARM_SINGLE, function()
            buffer:set(sld, 30, 0, 0)
            ws2812.write(buffer)
            tmr.create():alarm( 10, tmr.ALARM_SINGLE, function()
                buffer:set(sld, 0, 0, 0)
                ws2812.write(buffer)
            end);
        end);
--]]
    end
    ws2812.write(buffer)
end

abc = function()
    --print("abc")
    local char = text:read(1);
    if char == nil then
        text:close();
        text=file.open( textfile, "r");
        buffer:set(sld, 0, 0, 0)
        ws2812.write(buffer)
        tmr.create():alarm( 1000, tmr.ALARM_SINGLE, xyz);
        return;
    end
    print(char)
    if char == "a" then
        charBuffer = "102"
    elseif char == "b" then
        charBuffer = "2010101"
    elseif char == "c" then
        charBuffer = "2010201"
    elseif char == "d" then
        charBuffer = "20101"
    elseif char == "e" then
        charBuffer = "1"
    elseif char == "f" then
        charBuffer = "1010201"
    elseif char == "g" then
        charBuffer = "20201"
    elseif char == "h" then
        charBuffer = "1010101"
    elseif char == "i" then
        charBuffer = "101"
    elseif char == "j" then
        charBuffer = "1020202"
    elseif char == "k" then
        charBuffer = "20102"
    elseif char == "l" then
        charBuffer = "1020101"
    elseif char == "m" then
        charBuffer = "202"
    elseif char == "n" then
        charBuffer = "201"
    elseif char == "o" then
        charBuffer = "20202"
    elseif char == "p" then
        charBuffer = "1020201"
    elseif char == "q" then
        charBuffer = "2020102"
    elseif char == "r" then
        charBuffer = "10201"
    elseif char == "s" then
        charBuffer = "10101"
    elseif char == "t" then
        charBuffer = "2"
    elseif char == "u" then
        charBuffer = "10102"
    elseif char == "v" then
        charBuffer = "1010102"
    elseif char == "w" then
        charBuffer = "10202"
    elseif char == "x" then
        charBuffer = "2010102"
    elseif char == "y" then
        charBuffer = "2010202"
    elseif char == "z" then
        charBuffer = "2020101"
    elseif char == " " then
        charBuffer = "000000"
    else
        charBuffer = "101010101"
    end
    tmr.create():alarm( dit, tmr.ALARM_SINGLE, singleChar)
end

tmr.create():alarm( 300, tmr.ALARM_SINGLE, xyz);

