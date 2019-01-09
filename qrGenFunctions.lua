--[[

  * * * * qrGenFunctions.lua * * * *

File containing functions used to generate the final
QR code.  

Author: Ryan Hinrichs
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]



--[[

  * * * * Lookup * * * *
  
Function containing the looking table for alphanumeric
characters. Used to calculate the corresponding binary
data string for a string of characters.  Takes in a pair of
characters and turns them into a single digit.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: pair - the pair of characters to be converted
Returns:    val  - the value calculated for the characters
--]]
local function lookup( pair )
  
  --lookup table for alphanumeric characters
  local alphtab = {}
  alphtab["0"] = 0
  alphtab["1"] = 1
  alphtab["2"] = 2
  alphtab["3"] = 3
  alphtab["4"] = 4
  alphtab["5"] = 5
  alphtab["6"] = 6
  alphtab["7"] = 7
  alphtab["8"] = 8
  alphtab["9"] = 9
  alphtab["A"] = 10
  alphtab["B"] = 11
  alphtab["C"] = 12
  alphtab["D"] = 13
  alphtab["E"] = 14
  alphtab["F"] = 15
  alphtab["G"] = 16
  alphtab["H"] = 17
  alphtab["I"] = 18
  alphtab["J"] = 19
  alphtab["K"] = 20
  alphtab["L"] = 21
  alphtab["M"] = 22
  alphtab["N"] = 23
  alphtab["O"] = 24
  alphtab["P"] = 25
  alphtab["Q"] = 26
  alphtab["R"] = 27
  alphtab["S"] = 28
  alphtab["T"] = 29
  alphtab["U"] = 30
  alphtab["V"] = 31
  alphtab["W"] = 32
  alphtab["X"] = 33
  alphtab["Y"] = 34
  alphtab["Z"] = 35
  alphtab[" "] = 36
  alphtab["$"] = 37
  alphtab["%"] = 38
  alphtab["*"] = 39
  alphtab["+"] = 40
  alphtab["-"] = 41
  alphtab["."] = 42
  alphtab["/"] = 43
  alphtab[":"] = 44

  --Separates the pair into characters
  local first = string.sub(pair, 1, 1)
  local second = string.sub(pair, 2, 2)
  local val = 0

  --If there are two characters, converts them
  --into a number by the formula:
  --45 * firstval + secondval
  if(alphtab[second]) then
    val = (45 * alphtab[first]) + alphtab[second]
  else
    val = alphtab[first]
  end
  
  --Returns calculated value
  return val
end



--[[

  * * * * Convert * * * *
  
Takes in a number, converts it into binary, and places
it into the correct location in the QR data string.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: mode - defines how big the binary string needs to be
            num  - the number to be converted
            qrdata - the QR data string
            pointer - where to start placing data in the string
--]]
local function convert( mode, num, qrdata, pointer)
  local binval = {}
  local count = 1
  local charcoun = 0
  
  --Converts the number to a binary table
  while( num > 0) do
    if (num - 2 * math.floor(num / 2)) == 1 then
      binval[count] = 1
    else
      binval[count] = 0
    end   
    
    count = count + 1
    num = math.floor(num / 2)
  end
 
  --Specifies the size of the bitstring
  if mode == 0 then
    charcoun = 10
  elseif mode == 1 then
    charcoun = 9
  elseif mode == 3 then
    charcoun = 11
  elseif mode == 5 then
    charcoun = 8
  else 
    charcoun = 6
  end
    
  --Fills the data string, with 0's padded if the size is
  --incorrect
  if mode ~= 2  then
    while(count-1 < charcoun) do
      qrdata[pointer] = 0
      pointer = pointer + 1
      charcoun = charcoun - 1
    end
    
    pointer = pointer + 1
    
    for i = 0, count - 2 do
      qrdata[pointer + i - 1] = binval[count - i - 1]
    end
  elseif mode == 2 then --Special case for number input
    for i = 0, count - 2 do
      qrdata[pointer + i - 1] = binval[count - i - 1]
    end
  end
end

--[[

  * * * * Add 236 * * * *
  
Adds the number 236, per QR standards, to the end of the
data string.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: qrdata - the QR data string
            start - the start point for the function
--]]
local function add236( qrdata, start)
  
  qrdata[start] = 1
  qrdata[start + 1] = 1
  qrdata[start + 2] = 1
  qrdata[start + 3] = 0
  qrdata[start + 4] = 1
  qrdata[start + 5] = 1
  qrdata[start + 6] = 0
  qrdata[start + 7] = 0
end



--[[

  * * * * Add 17 * * * *
  
Adds the number 17, per QR standards, to the end of the
data string.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: qrdata - the QR data string
            start - the start point for the function
--]]
local function add17( qrdata , start)
  qrdata[start] = 0
  qrdata[start + 1] = 0
  qrdata[start + 2] = 0
  qrdata[start + 3] = 1
  qrdata[start + 4] = 0
  qrdata[start + 5] = 0
  qrdata[start + 6] = 0
  qrdata[start + 7] = 1
end



--[[

  * * * * Add 236 and 17 * * * *
  
Adds the numbers 236 and 17, per QR standards, to the end of the
data string, until the data string is the appropriate size for
Version 1 QR codes.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: qrdata - the QR data string
            start - the start point for the function
--]]
local function add236_17( qrdata )
  local term = 0
  --Adds 236 and 17 to string until size is correct, per
  --QR standards
  while #qrdata < 128 do
    if term == 0 then 
      add236( qrdata, #qrdata + 1 )
      term = 1
    elseif term == 1 then
      add17( qrdata, #qrdata + 1 )
      term = 0
    end
  end
  
  return qrdata
end

--Function names, to be used for cross-file operations
return {
  lookup = lookup,
  convert = convert,
  add236_17 = add236_17,
}