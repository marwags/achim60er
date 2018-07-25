coder = require("coder")

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
refrain  = "refrain.txt";
alter = 0;
--text=file.open( textfile, "r");
charBuffer = "";

-- Straßenlaternen
buffer:set(sl1, slhk, slhk, slhk);
buffer:set(sl2, slhk, slhk, slhk);
buffer:set(sl3, slhk, slhk, slhk);
buffer:set(sl4, slhk, slhk, slhk);

buffer:set(sld, 0, 0, 0)
ws2812.write(buffer)

shot = function( color )
    if color == "red" then
        buffer:set(sld, 0, 100, 0)
    elseif color == "green" then
        buffer:set(sld, 100, 0, 0)
    elseif color == "blue" then
        buffer:set(sld, 0, 0, 100)
    else
        buffer:set(sld, 100, 100, 100)
    end
    ws2812.write(buffer)
    tmr.create():alarm( 10, tmr.ALARM_SINGLE, function()
        buffer:set(sld, 0, 0, 0)
        ws2812.write(buffer)
    end);
end

abc = function()
    buffer:set(sld, 0, 100, 0)
    ws2812.write(buffer)
end

xyz = function()
    --print("xyz")
    buffer:set(sld, slhk, slhk, slhk)
    ws2812.write(buffer)
    tmr.create():alarm( 10000, tmr.ALARM_SINGLE, function()
        buffer:set(sld, 0, 0, 0)
        ws2812.write(buffer)
        alter = (alter + 1) % 2
        if alter == 0 then
            text=file.open( textfile, "r");
            shot("red")
        else
            text=file.open( refrain, "r");
        end
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
        if alter == 0 then
            shot("green")
        end
        buffer:set(sld, 0, 0, 0)
        ws2812.write(buffer)
        tmr.create():alarm( 1000, tmr.ALARM_SINGLE, xyz);
        return;
    end
    charBuffer = coder.encode( char )
    tmr.create():alarm( dit, tmr.ALARM_SINGLE, singleChar)
end

tmr.create():alarm( 300, tmr.ALARM_SINGLE, xyz);
