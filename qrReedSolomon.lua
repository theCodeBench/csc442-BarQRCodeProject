--[[

  * * * * qrReedSolomon.lua * * * *

File containing math to perform Reed Solomon error
generation

Author: Ryan Hinrichs
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]


local math = require "math"
local logAntilogLookup = require "logAntilogLookup"

--[[

  * * * * Binary to Decimal * * * *
  
Takes a table, representative of a binary string, and 
converts it into a decimal number.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: arr - array containing binary string
            start - start location in the array
Returns:    num - the converted number
--]]
local function bintodec( arr, start)
  local num = 0

  for i = 0, 7 do
    num = num + arr[start + i] * math.pow( 2, 7 - i)
  end

  return num
end



--[[

  * * * * Generate Poly * * * *
  
Creates the generator polynomial for the Reed Solomon algorithm.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: genpoly - table containing the generator polynomial 
              coefficients
--]]
local function generatepoly(genpoly)
  genpoly[11] = 0
  genpoly[10] = 251
  genpoly[9] = 67
  genpoly[8] = 46
  genpoly[7] = 61
  genpoly[6] = 118
  genpoly[5] = 70
  genpoly[4] = 64
  genpoly[3] = 94
  genpoly[2] = 32
  genpoly[1] = 45
end



--[[

  * * * * Message Polynomial * * * *
  
Creates the original message polynomial out of the codewords
for use in the Reed Solomon algorithm.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: codewords - codewords created from the input message
            messpoly - table of message polynomial coefficients
Returns:    true - valid barcode
            false - invalid barcode
--]]
local function messagepoly( codewords, messpoly)
  for i = 1, #codewords / 8 do
    messpoly[(#codewords / 8) - i + 1] = bintodec( codewords, (8 * (i - 1)) + 1)
  end
end



--[[

  * * * * Reed Solomon * * * *
  
Performs the Reed Solomon algorithm on the message polynomial to 
generate the error codewords.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: codewords - codewords given by the input message
            errorcodes - error code table containing the generated
                          error codes
--]]
local function reedSol( codewords, errorcodes)
  local altergenpoly = {}
  local genpoly = {}
  local messpoly = {}
  local gsize = 0
  local lead = 0
  local size = 0

  --Create message polynomial and generator polynomial
  messagepoly( codewords, messpoly)
  generatepoly( genpoly )
  size = #messpoly

  --Increase size of message polynomial by 10
  for i = 1, size do
    messpoly[(size - i) + 11] = messpoly[(size - i) + 1]
  end

  for i = 1, 10 do
    messpoly[i] = 0
  end

  size = #messpoly
  gsize = #genpoly

  --Takes the lead value of the message polynomial
  lead = messpoly[size]

  while size > 10 do
    --Converts the lead value to the Galois field
    lead = logAntilogLookup.lookupTab( lead, 0)

    --Shifts the generator polynomial by the lead value
    for j = 1, 11 do
      altergenpoly[12 - j] = genpoly[12 - j] + lead
      if altergenpoly[12 - j] >= 255 then 
        altergenpoly[12 - j] = altergenpoly[12 - j] % 255        end
        if altergenpoly[12 - j] ~= 0 then
          altergenpoly[12 - j] = logAntilogLookup.lookupTab(altergenpoly[12 - j], 1)
        else
          altergenpoly[12 - j] = 1
        end
      end

      --XORs the message polynomial with the altered generator polynomial
      for k = 0, size - 1 do
        if altergenpoly[#genpoly - k] == nil then 
          altergenpoly[#genpoly - k] = 0 
        end
        
        messpoly[size - k] = bit32.bxor(messpoly[size - k],
          altergenpoly[#genpoly - k])
      end

      --Resets the lead value
      lead = messpoly[size]

      --Adjusts the size appropriately
      while lead == 0 do
        size = size - 1
        lead = messpoly[size]
      end
    end

    --Takes the 10 smallest message polynomial coefficents
    --and returns them as the error codes
    for i = 1, 10 do
      errorcodes[i] = messpoly[10 - i + 1]
    end
  end

--Function names, to be used for cross-file operations
  return {
    reedSol = reedSol,
  }