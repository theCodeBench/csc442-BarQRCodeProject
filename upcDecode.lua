--[[

  * * * * upcDecode.lua * * * *

File containing digit decoding functions for UPC-A barcode interpretation.

Author: Zachery Crandall
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

--[[

* * * * Decode Left Side UPC-A Barcode * * * *

Decode the left digits of the barcode, assuming the left guard exists
in the barcode table. 1 is used for black, 0 is used for white in the 
barcode. Each number corresponds to one "module" of the barcode.

The decoding is as follows for the left side:
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
Parameters: barcode - the barcode table to be decoded where 0 is a space and 1 is a bar
            digits - table for the decoded digits of the barcode
Returns:    digits - table containing the decoded left digits of the barcode 
--]]
local function decodeUPCALeft( barcode, digits )
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

  local digitIndex = 1

  -- Ignoring the middle and right guards, read the digits in the 
  -- right half of the barcode and decode them
  for i = 4, 45, 7 do
    -- Check the current digit against the possible digits
    for j = 1, 10 do
      local match = true
      for k = 1, 7 do
        if leftSide[j][k] ~= barcode[i + k - 1] then
          match = false
        end
      end

      -- If the digit matches the barcode, record it
      if match == true then
        digits[digitIndex] = j - 1
        digitIndex = digitIndex + 1
      end
    end
  end

  return digits
end



--[[

* * * * Decode Right Side UPC-A Barcode * * * *

Decodes the right digits of the barcode, assuming the left guard, 
left digits, and middle guard exist in the barcode table provided. 
1 is used for black, 0 is used for white in the barcode. Each number 
corresponds to one "module" of the barcode.

The decoding is as follows for the right side:
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
Parameters: barcode - the barcode table to be decoded where 0 is a space and 1 is a bar
            digits - table for the decoded digits of the barcode
Returns:    digits - table containing the decoded right digits of the barcode 
--]]
local function decodeUPCARight( barcode, digits )
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

  local digitIndex = 7


  -- Ignoring the middle and right guards, read the digits in the 
  -- right half of the barcode and decode them
  for i = 51, 92, 7 do
    -- Check the current digit against the possible digits
    for j = 1, 10 do
      local match = true
      for k = 1, 7 do
        if rightSide[j][k] ~= barcode[i + k - 1] then
          match = false
        end
      end

      -- If the digit matches the barcode, record it
      if match == true then
        digits[digitIndex] = j - 1
        digitIndex = digitIndex + 1
      end
    end
  end

  return digits
end



--[[

* * * * Decode UPC-A Barcode * * * *

Given the string representation of a UPC-A barcode, it is decoded
into a lookup table of the 12 digits. The left side is the type and 
manufacturer number, while the right side contains the product 
number and checksum. 1 is used for black, 0 is used for white in 
the barcode.

Author:     Zachery Crandall, 7-bar representations from
http://www.cut-the-knot.org/do_you_know/BarcodeEncoding.shtml
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: barcode - the string representation of the barcode
Returns:    digits - lookup table of the digits of the barcode
--]]
local function decodeUPCABarcode( barcode )
  local digits = {}

  -- Decode barcode and store in a lookup table of digits
  digits = decodeUPCALeft( barcode, digits )
  digits = decodeUPCARight( barcode, digits )

  return digits
end

-- Function names, to be used for cross-file operations
return {
  decodeUPCABarcode = decodeUPCABarcode,
}