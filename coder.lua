coder = {}

coder.encode = function( char )

local charBuffer = ""

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
    elseif char == "1" then
        charBuffer = "102020202"
    elseif char == "2" then
        charBuffer = "101020202"
    elseif char == "3" then
        charBuffer = "101010202"
    elseif char == "4" then
        charBuffer = "101010102"
    elseif char == "5" then
        charBuffer = "101010101"
    elseif char == "6" then
        charBuffer = "201010101"
    elseif char == "7" then
        charBuffer = "202010101"
    elseif char == "8" then
        charBuffer = "202020101"
    elseif char == "9" then
        charBuffer = "202020201"
    elseif char == "0" then
        charBuffer = "202020202"
    elseif char == "à" or char == "å" then
        charBuffer = "102020102"
    elseif char == "ä" then
        charBuffer = "1020102"
    elseif char == "è" then
        charBuffer = "102010102"
    elseif char == "é" then
        charBuffer = "101020101"
    elseif char == "ö" then
        charBuffer = "2020201"
    elseif char == "ü" then
        charBuffer = "1010202"
    elseif char == "ß" then
        charBuffer = "1010102020101"
    elseif char == "ñ" then
        charBuffer = "202010202"
    elseif char == "." then
        charBuffer = "10201020102"
    elseif char == "," then
        charBuffer = "20201010202"
    elseif char == ":" then
        charBuffer = "20202010101"
    elseif char == ";" then
        charBuffer = "20102010201"
    elseif char == "-" then
        charBuffer = "20101010102"
    elseif char == "_" then
        charBuffer = "10102020102"
    elseif char == "(" then
        charBuffer = "201020201"
    elseif char == ")" then
        charBuffer = "20102020102"
    elseif char == "'" then
        charBuffer = "10202020201"
    elseif char == "=" then
        charBuffer = "201010102"
    elseif char == "+" then
        charBuffer = "102010201"
    elseif char == "/" then
        charBuffer = "201010201"
    elseif char == "@" then
        charBuffer = "10202010201"
    elseif char == " " then
        charBuffer = "000000"
    else
        charBuffer = "101010101"
    end
    return charBuffer
end

return coder
