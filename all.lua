require("morse")

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

morse.init( buffer, ersteLaterne, 30, 200)
morse.start()

