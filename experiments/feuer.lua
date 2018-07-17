ws2812.init();
i, j, buffer = 0, 0, ws2812.newBuffer(1, 3);
buffer:fill( 0, 0, 0); 

tmr.create():alarm(150, tmr.ALARM_AUTO, function()
  i = (i + 70) % 120
  j = (j + 12) % 40
  buffer:set(1, j + 10, i + 100, 5)
  ws2812.write(buffer)
end)
