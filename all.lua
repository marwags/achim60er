ws2812.init();

fireTon = 1;
hauslicht = 6;

slf = 2; -- erste Straßenlaterne
sl1 = slf;
sl2 = slf + 1;
sl3 = slf + 2;
sl4 = slf + 3;
sld = sl3; -- defekte Straßenlaterne
slhk = 20;

i, j, m, buffer = 0, 0, 0, ws2812.newBuffer(10, 3);
buffer:fill( 0, 0, 0); 

buffer:set(hauslicht, 70, 200, 10);

tmr.create():alarm(150, tmr.ALARM_AUTO, function()
  i = (i + 70) % 120
  j = (j + 12) % 40
  buffer:set(fireTon, j + 10, i + 100, 5)
  ws2812.write(buffer)
end)

-- Straßenlaternen
buffer:set(sl1, slhk, slhk, slhk);
buffer:set(sl2, slhk, slhk, slhk);
buffer:set(sl3, slhk, slhk, slhk);
buffer:set(sl4, slhk, slhk, slhk);

tmr.create():alarm(500, tmr.ALARM_AUTO, function()
  m = (m + 1) % 3
  
  buffer:set(sld, m*slhk, m*slhk, m*slhk)
  tmr.create():alarm(100, tmr.ALARM_SINGLE, function()
    --print("X")
    buffer:set(sld, 0, 0, 0)
    ws2812.write(buffer)
  end)
  ws2812.write(buffer)
end)


