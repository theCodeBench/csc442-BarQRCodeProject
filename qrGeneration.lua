--[[

  * * * * qrGeneration.lua * * * *

File containing functions that will be used to 
setup the framework for QR code generation.

Author: Ryan Hinrichs
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

require "ip"
local image = require "image"
local math = require "math"
local string = require "string"
local qrGenFunctions = require "qrGenFunctions"
local qrPrint = require "qrPrint"
local qrReedSolomon = require "qrReedSolomon"
local viz = require "visual"


--[[ * * * * Check Input * * * *

  Checks the user's input for any unknown characters.
  All unknown characters are replaced with "*" to avoid
  causing write errors. 

  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: input - input string given by user
  Returns:    Error corrected string from the input
--]]
local function checkInput( input )
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

  local char = ""

  for i=1, #input do
    local str = string.sub(input, i, i)
    if alphtab[str] then
      char = char .. str
    else
      char = char .. "*"
    end
  end

  return char
end


--[[

  * * * * Process Alpha String * * * *

Processes a string of alphanumeric characters so that
it can be used for QR generation.  It takes the characters
given and converts them into numbers by the method required
by QR standards.  It will also only process uppercase 
characters, which is also a normal standard of QR codes.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: input - input string given by user
            codenums - array that will be filled with 
              the encoded numbers to fill the QR code
Returns:    the number of character pairs in the 
              codenums array
--]]
local function processAlphastring( input, codenums )

  --converts the string to uppercase
  input = string.upper(input)

  -- check input for any unknown characters**
  input = checkInput(input)

  --creates substring pairs of the characters and
  --converts the pairs into their corresponding 
  --numbers
  for i = 0, math.floor(#input / 2) do
    codenums[i] = string.sub(input, (2 * i) + 1, (2 * i) + 2)
    codenums[i] = qrGenFunctions.lookup(codenums[i])
  end

  return math.floor(#input / 2)
end



--[[

  * * * * Process Number String * * * *

Processes a string of numbers so that it can be used for QR 
generation. This function takes the string of numbers and 
converts it into smaller, 3-digit numbers. It then returns
those numbers.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: input - input string given by user
            codenums - array that will be filled with 
              the encoded numbers to fill the QR code
--]]
local function processNumstring( input, codenums )
  --string of numbers to be processed
  local procstr = {}

  --reference array for converting numbers 
  --to binary
  local ref = {2, 1, 0}

  local count = math.floor(#input / 3) * 3
  local remain = #input - count
  local tempnum = 0

  for i = 1, #input do --convert string into table
    procstr[i] = tonumber(string.sub(input, i, i))
    if(procstr[i] == nil) then
      viz.message("Error Message", "Invalid String. Numerical Mode Cannot Contain Characters")
      return -1
    end
  end

  --Turn single digit numbers into 3 digit numbers
  for j = 1, count / 3 do 
    for i = 1, 3 do
      tempnum = tempnum + procstr[3 * (j - 1) + i] * math.pow(10, ref[i])
    end

    codenums[j] = tempnum --fill code number array
    tempnum = 0
  end

  --special case to add the remaining digits
  if remain == 1 then
    tempnum = procstr[count + 1]
  elseif remain == 2 then
    tempnum = 10 * procstr[count + 1] + procstr[count + 2]
  end

  codenums[(count / 3) + 1] = tempnum
end



--[[

  * * * * Square Generation * * * *
  
Creates the finder squares that go in the upper left, 
upper right, and lower left of the image.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image the QR code will be shown on
            cshift - the shifted distance of the columns
            rshift - the shifted distance of the rows
Returns:    img - the image the QR code will be shown on
--]]
local function sqrgen( img , rshift, cshift)
  --the table containing the map for the squares
  --in testing, it required the final row of zeros
  --to work correctly for rounding
  local rows = { 0, 0, 0, 0, 0, 0, 0,
    0, 1, 1, 1, 1, 1, 0,
    0, 1, 0, 0, 0, 1, 0,                 
    0, 1, 0, 0, 0, 1, 0,                 
    0, 1, 0, 0, 0, 1, 0,
    0, 1, 1, 1, 1, 1, 0,
    0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0}
  local val = 0

  --Steps through the image, placing the array above
  --at the location specified by rshift and cshift
  for r = 0, 147 do 
    for c = 0, 146 do
      val = (7 * math.floor(r / 21)) + math.floor(c / 21) + 1
      local i = 255 * rows[val]
      img:at(r + rshift,c + cshift).rgb = {i, i, i}
    end
  end

  return img
end

--[[

  * * * * Add Formatting * * * *
  
Places the finder squares, rows, and dark module
within the QR code.  All of these are in the same location
for every Version 1 QR code, so they need not be dynamically
prepared.

Author:     Ryan
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image the barcode will appear on
Returns:    img - the generated UPC-A barcode image
--]]
local function addFormatting( img )
  --Generates the 3 finder squares
  sqrgen( img, 0, 0)
  sqrgen( img, 293, 0)
  sqrgen( img, 0, 294)

  --Generates the striped finder lines
  for i = 0,2 do
    qrPrint.printcube( img , 8 + 2 * i , 6 )
    qrPrint.printcube( img , 6 , 8 + 2 * i )
  end

  --Generates the dark module
  qrPrint.printcube( img, 13, 8)

  return img

end

--[[

  * * * * Generate Version 1 QR code * * * *
  
Generates the data table containing the bits to be printed
in the final QR code.  This function is the framework for the
entire generation algorithm, and calls the necessary functions
to interpret the input string, add necessary information, generate
error codes, and print the final dataset.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image the barcode will appear on
            input - the input string given by the user
            choice - whether the user chose numeric or alphanumeric
Returns:    img - the generated QR code
--]]
local function genQR( img, input, choice )
  --tables for the code numbers, data string and error codes
  local codenums = {}
  local qrdata = {}
  local errorcodes = {}

  --total size of the input string
  local tot = #input

  --variables to be used in genQR
  local place = 0
  local size = 0
  local term = 0

  --Generation of the new image
  img = image.flat( 442, 442, 255)

  if(choice == "Numeric") then
    --Error checking for string length
    if string.len(input) > 34 then
      viz.message("Error Message", "Maximum String Length is 34 Characters")
      return img
    end

    ---Begins filling data string with type
    qrdata[1] = 0
    qrdata[2] = 0
    qrdata[3] = 0
    qrdata[4] = 1

    --Converts data string length into binary
    qrGenFunctions.convert( 0, tot, qrdata, 5)

    --Turns input string into code numbers
    if( processNumstring( input, codenums ) == -1 ) then
      return img
    end

    --Walks through code numbers and converts them into binary
    while codenums[place] do
      qrGenFunctions.convert( 2 , codenums[place] , qrdata , (place - 1) * 11 + 14)
      place = place + 1
    end

  elseif(choice == "AlphaNumeric") then
    --Error checking for string length
    if string.len(input) > 20 then
      viz.message("Error Message", "Maximum String Length is 20 Characters")
      return img
    end

    ---Begins filling data string with type
    qrdata[1] = 0
    qrdata[2] = 0
    qrdata[3] = 1
    qrdata[4] = 0

    --Converts data string length into binary
    qrGenFunctions.convert( 1, tot, qrdata, 5 )

    --Turns input string into code numbers
    local stop = processAlphastring( input, codenums )

    --Walks through code numbers and converts them into binary
    while codenums[place] do
      if place == stop then
        qrGenFunctions.convert( 4, codenums[place], qrdata, place * 11 + 14)
      else
        qrGenFunctions.convert( 3, codenums[place], qrdata, place * 11 + 14)
      end
      
      place = place + 1
    end
  end

  size = #qrdata

  --Adds Null Terminating 0's, at most 4
  while size < 128 and term < 4 do
    qrdata[size + 1] = 0
    size = size + 1
    term = term + 1
  end

  --Adds 0's until the size is divisible by 8
  while size % 8 ~= 0 do
    qrdata[size + 1] = 0
    size = size + 1
  end

  --Resets term variable
  term = 0

  qrGenFunctions.add236_17(qrdata)

  --Calculates error codes using Reed Solomon method
  qrReedSolomon.reedSol( qrdata, errorcodes)

  --Converts the error codes into binary and places in
  --data table
  place = 1
  
  while errorcodes[place] do
    qrGenFunctions.convert( 5, errorcodes[place], qrdata, #qrdata + 1)
    place = place + 1
  end

  --Adds necessary formatting portions of the QR code
  addFormatting( img )

  --Begins the process of printing the QR code
  qrPrint.printqr( qrdata, img)

  return img
end


--Function names, to be used for cross-file operations
return {
  genQR = genQR,
}