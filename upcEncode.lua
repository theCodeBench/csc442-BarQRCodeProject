--[[

  * * * * upcEncode.lua * * * *

File containing digit encoding functions for UPC-A barcode generation.

Author: Zachery Crandall
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]


--[[

* * * * Encode Left Side UPC-A Barcode * * * *

Encode the left digits of the barcode, assuming that the quiet zone
and left guard have been added already. 1 is used for black,
0 is used for white in the barcode. Each number corresponds to one
"module" of the barcode.

The encoding is as follows for the left side:
0: 0001101
1: 0011001
2: 0010011
3: 0111101
4: 0100011
5: 0110001
6: 0101111
7: 0111011
8: 0110111
9: 0001011

Author:     Zachery Crandall, 7-bar representations from
            http://www.cut-the-knot.org/do_you_know/BarcodeEncoding.shtml
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: digits - lookup table of the digits of the barcode
Returns:    barcode - table containing a string representation of the barcode 
                      bars where 0 is white and 1 is black
--]]
local function encodeUPCALeft( digits, barcode )
  -- Left side codes
  local leftSide = {
    -- Zero
    {0,0,0,1,1,0,1},
    -- One
    {0,0,1,1,0,0,1}, 
    -- Two
    {0,0,1,0,0,1,1}, 
    -- Three
    {0,1,1,1,1,0,1}, 
    -- Four
    {0,1,0,0,0,1,1}, 
    -- Five
    {0,1,1,0,0,0,1}, 
    -- Six
    {0,1,0,1,1,1,1}, 
    -- Seven
    {0,1,1,1,0,1,1}, 
    -- Eight
    {0,1,1,0,1,1,1}, 
    -- Nine
    {0,0,0,1,0,1,1} }

  local barcodeSize = #barcode

  -- Add the left six digits to the barcode
  for i = 1, 6 do
    -- Find the current digit to add
    local digitIndex = digits[i] + 1

    -- Add the current digit
    for j = 0, 6 do
      local barcodeIndex = barcodeSize + j + 1 + 7 * (i - 1)
      barcode[barcodeIndex] = leftSide[digitIndex][j + 1]
    end
  end

  return barcode
end



--[[

* * * * Encode Right Side UPC-A Barcode * * * *

Encode the right digits of the barcode, assuming everything to the
left of the middle guard and the middle guard have already been added. 
1 is used for black, 0 is used for white in the barcode. Each number 
corresponds to one "module" of the barcode.

The encoding is as follows for the right side:
0: 1110010
1: 1100110
2: 1101100
3: 1000010
4: 1011100
5: 1001110
6: 1010000
7: 1000100
8: 1001000
9: 1110100

Author:     Zachery Crandall, 7-bar representations from
            http://www.cut-the-knot.org/do_you_know/BarcodeEncoding.shtml
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: digits - lookup table of the digits of the barcode
Returns:    barcode - table containing a string representation of the barcode 
                      bars where 0 is white and 1 is black
--]]
local function encodeUPCARight( digits, barcode )
  -- Right side codes
  local rightSide = {
    -- Zero
    {1,1,1,0,0,1,0},
    -- One
    {1,1,0,0,1,1,0}, 
    -- Two
    {1,1,0,1,1,0,0}, 
    -- Three
    {1,0,0,0,0,1,0}, 
    -- Four
    {1,0,1,1,1,0,0}, 
    -- Five
    {1,0,0,1,1,1,0}, 
    -- Six
    {1,0,1,0,0,0,0}, 
    -- Seven
    {1,0,0,0,1,0,0}, 
    -- Eight
    {1,0,0,1,0,0,0}, 
    -- Nine
    {1,1,1,0,1,0,0} }

  local barcodeSize = #barcode

  -- Add the right six digits to the barcode
  for i = 7, 12 do
    -- Find the current digit to add
    local digitIndex = digits[i] + 1

    -- Add the current digit
    for j = 0, 6 do
      local barcodeIndex = barcodeSize + j + 1 + 7 * (i - 7)
      barcode[barcodeIndex] = rightSide[digitIndex][j + 1]
    end
  end

  return barcode
end



--[[

* * * * Encode UPC-A Barcode * * * *

Encode the full 12 digit barcode using UPC-A barcode encoding.
The left side is the type and manufacturer number, while the right
side contains the product number and checksum. 1 is used for black,
0 is used for white in the barcode. Each number corresponds to one
"module" of the barcode.

Author:     Zachery Crandall, 7-bar representations from
            http://www.cut-the-knot.org/do_you_know/BarcodeEncoding.shtml
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: digits - lookup table of the digits of the barcode
Returns:    barcode - table containing a string representation of the barcode 
                      bars where 0 is white and 1 is black
--]]
local function encodeUPCABarcode( digits )
  -- Guard patterns
  local lrguard = {1,0,1}
  local mguard = {0,1,0,1,0}

  local barcode = {}

  -- Encode each number and store in the barcode variable
  -- Add the left guard pattern
  for i = 1, 3 do
    barcode[i] = lrguard[i]
  end

  -- Add the left six digits
  barcode = encodeUPCALeft( digits, barcode )

  -- Add the middle guard pattern
  for i = 46, 50 do
    barcode[i] = mguard[i - 45]
  end

  -- Add the right six digits
  barcode = encodeUPCARight( digits, barcode )

  -- Add the right guard pattern
  for i = 93, 95 do
    barcode[i] = lrguard[i - 92]
  end

  -- Return the encoded barcode
  return barcode
end



-- Function names, to be used for cross-file operations
return{
  encodeUPCABarcode = encodeUPCABarcode,
}