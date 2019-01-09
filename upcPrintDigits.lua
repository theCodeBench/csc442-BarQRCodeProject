--[[

  * * * * upcPrintDigits.lua * * * *

File containing routines for printing digits on a UPC-A barcode.

Author: Zachery Crandall
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

local num = require "digits"

--[[

  * * * * is Digit Output Column * * * *
  
Check if the column is a starting column for a digit in the
barcode.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: col - the current column
Returns:    true - is a starting column for a digit
            false - is not a starting column for a digit
--]]
local function isDigitOutCol( col )
  return col == 1 or col == 105 or (col > 13 and col < 47) or (col > 58 and col < 94)
end



--[[

  * * * * Print Digit * * * *
  
Prints the provided digit starting with the top left pixel
specified by startRow and startCol.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to have the digit printed to
            numberTable - 7 x 13 table containing the specified number
            startRow - the starting row for the digit
            startCol - the starting col for the digit
--]]
local function printDigit( img, numberTable, startRow, startCol )
  local imgCol = startCol
  
  -- Print the number
  for numRow = 1, 13 do
    for numCol = 1, 7 do
      local i = 255 - 255 * numberTable[numRow][numCol]
      img:at(startRow + numRow,imgCol + numCol - 1).rgb = { i, i, i }                                                                                                                    
    end
  end
end



--[[

  * * * * Print Barcode Numbers * * * *
  
Given a 1D array of the digits contained in the barcode, the
numeric representation of the digits are printed starting at the
provided startRow. This makes the digits appear underneath the
barcode between the underhanging guard bars.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to have numbers printed to
            digits - 1D array of the digits of barcodes
            startRow - the starting row for the numbers
Returns:    img - the image with the digits printed on it
--]]
local function printNumbers( img, digits, startRow )
  local digitIndex = 1
  local imgCol = 0
  
  -- Round the start row to an integer
  startRow = math.ceil(startRow)

  while imgCol < img.width do
    -- Only output at the proper columns in the barcode
    if isDigitOutCol( imgCol ) then
      local number = num.getNumber(digits[digitIndex])
      
      -- Print the correct digit
      printDigit( img, number, startRow, imgCol )

      -- Skip over the number just printed
      imgCol = imgCol + 7

      -- Increment the digit index
      digitIndex = digitIndex + 1
    end

    -- Increment the current image column
    imgCol = imgCol + 1
  end

  return img
end



--Function names, to be used for cross-file operations
return {
  printNumbers = printNumbers,
}