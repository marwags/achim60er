coder = require("coder")

morse = {}
--ws2812.init()

local buffer = nil;
--buffer:fill( 0, 0, 0); 

local slf = 1; -- erste Straßenlaterne
local sl1 = slf;
local sl2 = slf + 1;
local sl3 = slf + 2;
local sl4 = slf + 3;
local sl5 = slf + 4;
local sld = sl4; -- defekte Straßenlaterne
local slhk = 20; -- Helligkeit

local dit = 200; -- ms für ein dit
local dah = dit * 3;

local textfile = "morse.txt";
local refrain  = "refrain.txt";
local alter = 0;
local charBuffer = "";

morse.init = function( buf, first, brightness, dit_length ) 
    -- Straßenlaternen
    buffer = buf

    if brightness >= 0 and brightness <= 255 then
        slhk = brightness;
    end

    if first then
        slf = first; -- erste Straßenlaterne
    end
    sl1 = slf;
    sl2 = slf + 1;
    sl3 = slf + 2;
    sl4 = slf + 3;
    sld = sl3; -- defekte Straßenlaterne

    if dit_length then
        dit = dit_length
    end
    dah = dit * 3
end

morse.shot = function( color )
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

morse.xyz = function()
    --print("xyz")
    buffer:set(sld, slhk, slhk, slhk)
    ws2812.write(buffer)
    tmr.create():alarm( 10000, tmr.ALARM_SINGLE, function()
        buffer:set(sld, 0, 0, 0)
        ws2812.write(buffer)
        alter = (alter + 1) % 2
        if alter == 0 then
            text=file.open( textfile, "r");
            morse.shot("red")
        else
            text=file.open( refrain, "r");
        end
        tmr.create():alarm( 1000, tmr.ALARM_SINGLE, morse.abc);
    end)
end

morse.singleChar = function()
    --print(charBuffer)
    if string.len(charBuffer) > 0 then
        local c = string.sub(charBuffer,1,1);
        charBuffer = string.sub(charBuffer, 2)
        if c == "1" then
            buffer:set(sld, slhk, slhk, slhk)
            tmr.create():alarm( dit, tmr.ALARM_SINGLE, morse.singleChar);
        elseif c == "2" then
            buffer:set(sld, slhk, slhk, slhk)
            tmr.create():alarm( dah, tmr.ALARM_SINGLE, morse.singleChar);
        else
            buffer:set(sld, 0, 0, 0)
            tmr.create():alarm( dit, tmr.ALARM_SINGLE, morse.singleChar);
        end
    else
        buffer:set(sld, 0, 0, 0)
        tmr.create():alarm( dah, tmr.ALARM_SINGLE, morse.abc);
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

morse.abc = function()
    --print("abc")
    local char = text:read(1);
    if char == nil then
        text:close();
        if alter == 0 then
            morse.shot("green")
        end
        buffer:set(sld, 0, 0, 0)
        ws2812.write(buffer)
        tmr.create():alarm( 1000, tmr.ALARM_SINGLE, morse.xyz);
        return;
    end
    charBuffer = coder.encode( char )
    tmr.create():alarm( dit, tmr.ALARM_SINGLE, morse.singleChar)
end

morse.start = function()

    if not buffer then
        print("Kein buffer initialisiert!")
        return
    end
    buffer:set(sl1, slhk, slhk, slhk);
    buffer:set(sl2, slhk, slhk, slhk);
    buffer:set(sl3, slhk, slhk, slhk);
    buffer:set(sl4, slhk, slhk, slhk);
    buffer:set(sl5, slhk, slhk, slhk);
    buffer:set(sld, 0, 0, 0)
    ws2812.write(buffer)

    tmr.create():alarm( 300, tmr.ALARM_SINGLE, morse.xyz);
end

return morse
