--[[

  * * * * upcGeneration.lua * * * *

File containing routines for UPC-A barcode generation.

Author: Zachery Crandall
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

local encode = require "upcEncode"
local image = require "image"
local upcDigit = require "upcPrintDigits"
local viz = require "visual"



--[[

  * * * * Validate UPC-A Barcode * * * *
  
The barcode number formatting is validated. The type is one 
integer, manufacturer and product numbers are five integers each.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: type - the type specification for the barcode
            manufacturer - UPC manufacturer number
            product - product number
Returns:    true - valid barcode
            false - invalid barcode
--]]
local function isValidParts( type, manufacturer, product )
  -- Check that none of the provided numbers are nil
  if type == nil or manufacturer == nil or product == nil then
    return false
  end

  -- Check for valid type
  if type < 0 or type > 9 then
    return false
  end

  -- Check manufacturer
  if manufacturer < 0 or manufacturer / 99999 > 1 then
    return false
  end

  -- Check product
  if product < 0 or product / 99999 > 1 then
    return false
  end

  return true
end



--[[

  * * * * Concatonate UPC-A Barcode Pieces * * * *

Combines the provided UPC-A barcode pieces into a lookup table of single digits. 

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: type - the type specification for the barcode
            manufacturer - UPC manufacturer number
            product - product number
            checksum - calculated UPC-A checksum
Returns:    digits - lookup table of barcode digits
--]]
local function concatCode( type, manufacturer, product, checksum )
  local digits = {}

  -- Concatonate numbers into a lookup table of barcode digits
  -- Add type to digits
  digits[1] = type

  -- Add manufacturer number
  for i = 6, 2, -1 do
    -- Extract the digit from the manufacturer code
    digits[i] = manufacturer % 10

    manufacturer = (manufacturer - digits[i]) / 10
  end

  -- Add product number
  for i = 11, 7, -1 do
    -- Extract the digit from the manufacturer code
    digits[i] = product % 10

    product = (product - digits[i]) / 10
  end

  -- Add checksum
  digits[12] = checksum

  -- Return the lookup table of barcode digits
  return digits
end



--[[

* * * * Calculate UPC-A Checksum * * * *

The checksum is a Modulo 10 calculation. This is calculated for the
given barcode digits using the following steps:

1. Add the values of the digits in positions 1, 3, 5, 7, 9, and 11.
2. Multiply this result by 3.
3. Add the values of the digits in positions 2, 4, 6, 8, and 10.
4. Sum the results of steps 2 and 3.
5. The check character is the smallest number which, when added to 
the result in step 4, produces a multiple of 10.

Author:     Zachery Crandall, calculations adopted from 
            http://www.makebarcode.com/specs/upc_a.html
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: type - the type specification for the barcode
            manufacturer - UPC manufacturer number
            product - product number
Returns:    checksum - calculated UPC-A checksum
--]]
local function calculateChecksum( type, manufacturer, product )
  local checksum = 0
  local sum = 0
  local digits = {}

  -- Concatonate numbers into a lookup table of barcode digits
  digits = concatCode( type, manufacturer, product )

  -- Calculate checksum
  -- 1. Add the values of the digits in positions 1, 3, 5, 7, 9, and 11.
  for i = 1, 11, 2 do
    sum = sum + digits[i]
  end

  -- 2. Multiply this result by 3.
  sum = sum * 3

  -- 3. Add the values of the digits in positions 2, 4, 6, 8, and 10.
  -- 4. Sum the results of steps 2 and 3.
  for i = 2, 10, 2 do
    sum = sum + digits[i]
  end

  -- 5. The check character is the smallest number which, when added to 
  --    the result in step 4, produces a multiple of 10.
  sum = sum % 10

  if sum ~= 0 then
    checksum = 10 - sum
  end

  -- Return checksum
  return checksum
end



--[[

  * * * * Print Barcode * * * *

Prints the specified barcode to the image, where the barcode
is provided as a 1D table of 0's and 1's. 0 corresponds to white
and 1 corresponds to black.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image the barcode will appear on
            barcode - table of the barcode; 1 = black; 0 = white
            buffer - buffer pixels from the sides of the image
--]]
local function printBarcode( img, barcode, buffer, barcodeHeight )
  -- Iterate through the image printing the barcode
  for r,c in img:pixels(buffer) do 
    if c < #barcode + buffer then
      local i = 255 - 255 * barcode[c - buffer + 1]

      -- Output the majority of the barcode
      if r < barcodeHeight + buffer then
        img:at(r,c).rgb = { i, i, i }
        -- Output overhanging bars for 5 module widths below the main barcode
      elseif r < barcodeHeight + buffer + 5 then
        -- The left, middle, and right guards are dropped
        if c < 3 + buffer or c > 91 + buffer or (c > 44 + buffer and c < 50 + buffer) then
          img:at(r,c).rgb = { i, i, i }
        end
      end
    end
  end
end



--[[

* * * * Create Barcode Image * * * *

Creates an image appropriately sized to hold a standard barcode.
The barcode for the specified digits is then generated, along with
the digits themselves in the appropriate places on the image.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image the barcode will appear on
            digits - lookup table of the digits of the barcode
            barcode - table of the string representation of the barcode
Returns:    img - the generated UPC-A barcode image
--]]
local function createUPCImg( img, barcode, digits )
  local barcodeHeight = #barcode / 2
  local buffer = 9
  local numberRow = barcodeHeight + buffer

  -- Create a flat img to work with the size of the barcode
  img = image.flat(#barcode + buffer * 2, barcodeHeight + buffer * 2 + 13, 255)

  -- Print the barcode on the image
  printBarcode( img, barcode, buffer, barcodeHeight )

  -- Print the numbers on the barcode
  img = upcDigit.printNumbers( img, digits, numberRow )

  return img
end



--[[

* * * * Generate UPC-A Barcode * * * *

Given a valid UPC-A barcode type specification number, manufacturer number,
and product number, this function generates an image of a valid UPC-A barcode.
Before barcode generation, the barcode numbers are validated (type is one 
number, manufacturer and product numbers are 5 numbers each) and the twelfth 
digit of the barcode, the checksum, is calculated from the other provided
numbers. The barcode digits are then encoded and the digits printed in the
correct places on the barcode. The complete barcode is then returned
for display.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image the barcode will appear on
            type - the type specification for the barcode
            manufacturer - UPC manufacturer number
            product - product number
Returns:    img - the generated UPC-A barcode
--]]
local function genUPC( img, type, manufacturer, product )
  local barcode = {}
  local digits = {}
  local checksum = 0

  -- Validate the string to be encoded
  if( not isValidParts( type, manufacturer, product )) then
    io.write("Invalid barcode number provided.\n")
    viz.message("Error", "Invalid barcode number provided.")
    return img
  end

  -- Calculate the checksum of the barcode
  checksum = calculateChecksum( type, manufacturer, product )

  -- Put the type, manufacturer, product, and checksum numbers in a digit lookup table
  digits = concatCode( type, manufacturer, product, checksum )

  -- Generate barcode pattern
  barcode = encode.encodeUPCABarcode( digits )

  -- Print barcode on the blank image
  img = createUPCImg( img, barcode, digits )

  return img
end


--Function names, to be used for cross-file operations
return {
  genUPC = genUPC,
}