--[[

  * * * * qrPrint.lua * * * *

File containing functions to print the final
QR code.

Author: Ryan Hinrichs
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

--[[

  * * * * Printcube * * * *
  
Prints a 2-dimensional module into the image.  Converts a pixel location
into the correct size, and prints a black square at that coordinate.


Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - image containing QR code
            row - the row that the module will be at
            col - the column that the module will be at
Returns:    img - image containing QR code
--]]
local function printcube( img, row, col )
  for r = 0, 20 do 
   for c = 0, 20 do
      img:at( 21 * row + r , 21 * col + c ).rgb = { 0, 0, 0 }
    end
  end
  
  return img
end



--[[

  * * * * Printz * * * *
  
Prints two bits of the QR data string in a zigzag pattern,
used to help improve the efficiency of the overall program layout.


Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - image containing QR code
            qrdata - QR data string
            start - start location for the QR data string
            row - the row that the module will be at
            col - the column that the module will be at
Returns:    img - image containing QR code
--]]
local function printz( img, qrdata, start, row, col)
  if qrdata[start] == 1 then printcube( img, row, col) end
  if qrdata[start + 1] == 1 then printcube( img, row, col - 1) end
end



--[[

  * * * * Flip * * * *
  
Returns a flipped bit, used for the mask function.


Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: num - number sent in
Returns:    0   - if num = 1
            1   - if num = 0
--]]
local function flip( num )
  if num == 0 then return 1
  else return 0 end
end



--[[

  * * * * Format Bits * * * *
  
Prints the necessary modules to indicate error code mode
as well as the mask being used for the QR code.  In this 
demonstration, these are consistent values, so the code
can be explicitly defined.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - image containing QR code
Returns:    img - image containing QR code
--]]
local function formatbits( img )
  printcube( img, 2, 8)
  printcube( img, 3, 8)
  printcube( img, 4, 8)
  printcube( img, 5, 8)
  printcube( img, 7, 8)
  
  printcube( img, 8, 0)
  printcube( img, 8, 2)
  printcube( img, 8, 3)
  printcube( img, 8, 4)
  printcube( img, 8, 5)
  
  printcube( img, 15, 8)
  printcube( img, 16, 8)
  printcube( img, 17, 8)
  printcube( img, 18, 8)
  printcube( img, 20, 8)
  
  printcube( img, 8, 14)
  printcube( img, 8, 15)
  printcube( img, 8, 16)
  printcube( img, 8, 17)
  printcube( img, 8, 18)
  
  return img
end



--[[

  * * * * Apply Mask * * * *
  
Flips the appopriate bits to apply mask 2 in QR
interpretation, otherwise known as flipping all bits in 
columns whose value is divisible by 3.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: qrdata - QR data string
Returns:    N/A
--]]
local function applymask( qrdata )
  --Iterates through the appropriate intervals which
  --correspond to every third column
  for i = 0, #qrdata do
    if i < 24 then
      if i % 2 == 1 then qrdata[i] = flip( qrdata[i] ) end
    elseif i < 49 and i > 25 then
      if i % 2 == 0 then qrdata[i] = flip( qrdata[i] ) end
    elseif i < 96 and i > 72 then
      if i % 2 == 1 then qrdata[i] = flip( qrdata[i] ) end
    elseif i < 137 and i > 97 then
      if i % 2 == 0 then qrdata[i] = flip( qrdata[i] ) end
    elseif i < 184 and i > 176 then
      if i % 2 == 1 then qrdata[i] = flip( qrdata[i] ) end
    elseif i < 192 and i > 184 then
      if i % 2 == 1 then qrdata[i] = flip( qrdata[i] ) end
    elseif i < 201 and i > 193 then
      if i % 2 == 0 then qrdata[i] = flip( qrdata[i] ) end
    end
  end
end



--[[

  * * * * Print QR * * * *
  
Iterates through the QR data string, and prints the
modules appropriately.   It traverses in a 2d zigzag
pattern, traversing from the bottom right of the image 
to the upper left, and uses the printz function to print
in a 'z' pattern.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: qrdata - the QR data string
            img - the image containing the QR code
Returns:    img - the image containing the QR code
--]]
local function printqr( qrdata , img)

  --Applys mask 2 to the bits
  applymask( qrdata )
  
  --Prints columns 14-21
  for i = 0, 11 do
    printz( img, qrdata, 2 * i + 1, 20 - i, 20)
    printz( img, qrdata, 2 * i + 25, 9 + i, 18)
    printz( img, qrdata, 2 * i + 49, 20 - i, 16)
    printz( img, qrdata, 2 * i + 73, 9 + i, 14)
  end
  
  --Prints columns 10-13, lower portion
  for i = 0, 13 do
    printz( img, qrdata, 2 * i + 97, 20 - i, 12)
    printz( img, qrdata, 2 * i + 153, 7 + i, 10)
  end
  
  --Prints columns 10-13, upper portion
  for i = 0, 5 do
    printz( img, qrdata, 2 * i + 127, 5 - i, 12)
    printz( img, qrdata, 2 * i + 139, i, 10)
  end
  
  --Prints columns 1-9
  for i = 0, 3 do
    printz( img, qrdata, 2 * i + 181, 12 - i, 8)
    printz( img, qrdata, 2 * i + 189, 9 + i, 5)
    printz( img, qrdata, 2 * i + 197, 12 - i, 3)
    printz( img, qrdata, 2 * i + 205, 9 + i, 1)
  end
  
  --Prints the format bits
  formatbits( img )
  
  return img
end


--Function names, to be used for cross-file operations
return {
  printqr = printqr,
  printcube = printcube,
}