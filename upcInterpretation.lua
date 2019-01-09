--[[

  * * * * upcInterpretation.lua * * * *

File containing routines for UPC-A barcode interpretation.

Author: Zachery Crandall
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

local decode = require "upcDecode"
local viz = require "visual"

--[[

* * * * Find Start of Barcode * * * *

Given an image of a UPC-A barcode, this function will scan the image from
left to right starting with the top left corner (0,0). Once a sufficiently
dark pixel is found, it is assumed to be the start of the barcode left guard.
Due to this restriction, the barcode image must be free of any shadows or other
noise that may trigger this condition.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image of the UPC-A barcode
Returns:    r, c - the row and column values of the top left point of the barcode
            -1, -1 - barcode not detected
--]]
local function findStart( img )  
  local barfound = false
  local c = -1
  local r = 0

  -- Find the first bar by scanning the image from the top left
  while barfound == false and r < img.height do    
    -- Increment row and col iterators as necessary to traverse the image
    c = c + 1
    if c >= img.width - 1 then
      c = 0
      r = r + 1
    end

    local pixel = img:at(r,c)

    -- Detect when the left guard begins
    if pixel.r * 0.30 + pixel.g * 0.59 + pixel.b * 0.11 < 129 then
      barfound = true
      return r,c
    end
  end

  return -1,-1
end



--[[

* * * * Find Width of a Module * * * *

Given a valid UPC-A barcode image, this function determines the pixel
width of a module of the barcode by measuring the first bar of the
left guard of the barcode which, by the standards of UPC-A barcodes, 
is one module in width.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image of a UPC-A barcode to be interpreted
            startRow - the row of the top left pixel of the barcode
            startCol - the column of the top left pixel of the barcode
Returns:    width - pixel width of a module
--]]
local function findModuleWidth( img, startRow, startCol )
  local barfound = true
  local moduleWidth = 0
  local r, c = startRow, startCol

  -- Find where the first bar ends, counting the width of the module as well
  while barfound == true do
    moduleWidth = moduleWidth + 1

    -- Increment row and col iterators as necessary to traverse the image
    c = c + 1

    local pixel = img:at(r,c)

    -- Detect when the first bar ends
    if pixel.r * 0.30 + pixel.g * 0.59 + pixel.b * 0.11 > 40 then
      barfound = false
    elseif c >= img.width - 1 then
      return 0
    end
  end

  return moduleWidth
end


--[[

* * * * Read UPC-A Barcode * * * *

Given a valid UPC-A barcode image, this function scans, decodes, and 
reports the string representation of the UPC-A barcode encoded digits

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image of a UPC-A barcode to be interpreted
Returns:    barcode - the string representation of the barcode,
                    - this will be empty if the read fails
--]]
local function readBarcode( img )
  local barcode = {}
  local moduleWidth = 0
  local r, c = findStart( img )

  -- If the first bar was not found, report barcode detection error
  if r < 0 or c < 0 then
    return barcode
  end

  -- Find the module width of the barcode
  moduleWidth = findModuleWidth( img, r, c )

  -- If the width of the first bar was not properly detected, report error
  if moduleWidth == 0 or img.width - c < 95 * moduleWidth - 1 then
    return barcode
  end

  -- Read in a row of the barcode
  -- Start at the start of the barcode and iterate over the first element of
  -- each module in the barcode (there are 95 of them)
  for i = c, c + 95 * moduleWidth - 1, moduleWidth do
    local barCount = 0
    local spaceCount = 0
    local pixel = img:at(r,i)

    -- Read in an individual module
    for _ = 1, moduleWidth do
      -- If the pixel is close to black store it as a 1, otherwise store a 0
      if pixel.r * 0.30 + pixel.g * 0.59 + pixel.b * 0.11 < 41 then
        barCount = barCount + 1
      else
        spaceCount = spaceCount + 1
      end
    end

    -- Determine whether the module is a bar or space
    if barCount >= spaceCount then
      barcode[(i - c) / moduleWidth + 1] = 1
    else
      barcode[(i - c) / moduleWidth + 1] = 0
    end
  end

  return barcode
end



--[[

* * * * Validate UPC-A Barcode * * * *

Given the digits of a UPC-A barcode, it is checked for validity using
checksum error checking. This is done by summing the odd indexed 
digits multiplied by 3 with the even digits, then ensuring that this
sum is divisible by 10.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: digits - digits of the decoded UPC-A barcode
Returns:    true - is a valid UPC-A barcode
            false - is not a valid UPC-A barcode
--]]
local function isValidUPCA( digits )
  local sum = 0

  -- Check for the correct number of digits
  if #digits ~= 12 then
    return false
  end

  -- Sum the odd indexed digits multiplied by 3
  for i = 1, 11, 2 do
    sum = sum + digits[i]
  end
  sum = sum * 3

  -- Add the even indexed digits to the sum
  for i = 2, 12, 2 do
    sum = sum + digits[i]
  end

  -- Return false if invalid
  if sum % 10 ~= 0 then
    return false
  end

  -- Otherwise return true
  return true
end



--[[

* * * * Report UPC-A Barcode Digits * * * *

Given a table of 12 UPC-A barcode digits, outputs the barcode type
specifier, manufacturer number, product number, and checksum digit
to the console. 

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: digits - a table containing the 12 digits of the UPC-A barcode
--]]
local function outputUPCDigits( digits )
  local outputStr = ""

  -- Report type
  io.write("Barcode type specifier: ", tostring(digits[1]), "\n")
  outputStr = outputStr .. "Barcode type specifier: " .. tostring(digits[1]) .. "\n"

  -- Report Manufacturer number
  io.write("Manufacturer number: ")
  outputStr = outputStr .. "Manufacturer number: "
  for i = 2, 6 do
    io.write(tostring(digits[i]))
    outputStr = outputStr .. tostring(digits[i])
  end
  io.write("\n")
  outputStr = outputStr .. "\n"

  -- Report Product number
  io.write("Product number: ")
  outputStr = outputStr .. "Product number: "
  for i = 7, 11 do
    io.write(tostring(digits[i]))
    outputStr = outputStr .. tostring(digits[i])
  end
  io.write("\n")
  outputStr = outputStr .. "\n"

  -- Report checksum
  io.write("Checksum digit: ", tostring(digits[12]), "\n")
  outputStr = outputStr .. "Checksum digit: " .. tostring(digits[12]) .. "\n"

  -- In a message box
  viz.message("Decoded Message", outputStr)
end



--[[

* * * * Interpret UPC-A Barcode * * * *

Given a valid UPC-A barcode image, this function reads and decodes the barcode, 
reporting the type, manufacturer number, product number, and checksum. 

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image of a UPC-A barcode to be interpreted
Returns:    img - the unchanged image of the UPC-A barcode
--]]
local function interpUPC( img )
  local barcode = {}
  local digits = {}

  -- Read barcode and get string interpretation
  barcode = readBarcode( img )

  -- Report if the barcode reading failed
  if #barcode == 0 then
    io.write("Error reading barcode\n")
    viz.message("Error", "Error reading barcode\n")
    return img
  end

  -- Decode barcode
  digits = decode.decodeUPCABarcode( barcode )

  -- Validate the barcode using the checksum
  if not isValidUPCA( digits ) then
    io.write("Error reading barcode\n")
    viz.message("Error", "Error reading barcode\n")
    return img
  else
    outputUPCDigits( digits )
  end

  return img
end



-- Function names, to be used for cross-file operations
return {
  interpUPC = interpUPC,
}