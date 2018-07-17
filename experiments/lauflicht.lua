ws2812.init()
local i, buffer = 0, ws2812.newBuffer(10, 3); buffer:fill( 0, 0, 0); tmr.create():alarm(300, 1, function()
  i = i + 1
  buffer:fade(4)
  buffer:set(i % buffer:size() + 1, 20, 255, 5)
  ws2812.write(buffer)
end)
