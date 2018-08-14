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
local slhk_g = 20; -- Helligkeit
local slhk_r = 20; -- Helligkeit
local slhk_b = 20; -- Helligkeit

local dit = 200; -- ms für ein dit
local dah = dit * 3;

local textfile = "morse.txt";
local grussfile = "gruss.txt";
local refrain  = "refrain.txt";
local alter = 2;
local charBuffer = "";

morse.init = function( buf, first, brightness_g, brightness_r, brightness_b, dit_length ) 
    -- Straßenlaternen
    buffer = buf

    if brightness_g >= 0 and brightness_g <= 255 then
        slhk_g = brightness_g;
    end

    if brightness_r >= 0 and brightness_r <= 255 then
        slhk_r = brightness_r;
    end

    if brightness_b >= 0 and brightness_b <= 255 then
        slhk_b = brightness_b;
    end

    if first then
        slf = first; -- erste Straßenlaterne
    end
    sl1 = slf;
    sl2 = slf + 1;
    sl3 = slf + 2;
    sl4 = slf + 3;
    sl5 = slf + 4;
    sld = sl4; -- defekte Straßenlaterne

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
    buffer:set(sld, slhk_g, slhk_r, slhk_b)
    ws2812.write(buffer)
    tmr.create():alarm( 10000, tmr.ALARM_SINGLE, function()
        buffer:set(sld, 0, 0, 0)
        ws2812.write(buffer)
        alter = (alter + 1) % 4
        if alter == 0 then
            text=file.open( textfile, "r");
            morse.shot("red")
        elseif alter == 2 then
            text=file.open( grussfile, "r");
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
            buffer:set(sld, slhk_g, slhk_r, slhk_b)
            tmr.create():alarm( dit, tmr.ALARM_SINGLE, morse.singleChar);
        elseif c == "2" then
            buffer:set(sld, slhk_g, slhk_r, slhk_b)
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
        print("-----------")
        if alter == 0 then
            morse.shot("green")
        end
        buffer:set(sld, 0, 0, 0)
        ws2812.write(buffer)
        tmr.create():alarm( 1000, tmr.ALARM_SINGLE, morse.xyz);
        return;
    end
    print(char)
    charBuffer = coder.encode( char )
    tmr.create():alarm( dit, tmr.ALARM_SINGLE, morse.singleChar)
end

morse.start = function()

    if not buffer then
        print("Kein buffer initialisiert!")
        return
    end
    buffer:set(sl1, slhk_g, slhk_r, slhk_b);
    buffer:set(sl2, slhk_g, slhk_r, slhk_b);
    buffer:set(sl3, slhk_g, slhk_r, slhk_b);
    buffer:set(sl4, slhk_g, slhk_r, slhk_b);
    buffer:set(sl5, slhk_g, slhk_r, slhk_b);
    buffer:set(sld, 0, 0, 0)
    ws2812.write(buffer)

    tmr.create():alarm( 300, tmr.ALARM_SINGLE, morse.xyz);
end

morse.setDit = function( ditLength )
    if ditLength > 0 then
        dit = ditLength
        dah = dit * 3
    end
end

return morse
