ws2812.init()
i, buffer = 0, ws2812.newBuffer(10, 3);

buffer:fill( 50, 50, 50);
buffer:set(5, 0, 0, 0)
buffer:set(6, 0, 0, 0)
buffer:set(7, 0, 0, 0)
buffer:set(8, 0, 0, 0)
buffer:set(9, 0, 0, 0)
buffer:set(10, 0, 0, 0)
buffer:set(11, 0, 0, 0)
buffer:set(12, 0, 0, 0)
buffer:set(13, 0, 0, 0)
buffer:set(14, 0, 0, 0)

text=file.open("morse.txt", "r")

tmr.create():alarm(500, tmr.ALARM_AUTO, function()
  i = i + 1
  i = i % 2
  
  buffer:set(3, i*50, i*50, i*50)
  tmr.create():alarm(100, tmr.ALARM_SINGLE, function()
    --print("X")
    buffer:set(3, 0, 0, 0)
    ws2812.write(buffer)
  end)
  ws2812.write(buffer)
end)
