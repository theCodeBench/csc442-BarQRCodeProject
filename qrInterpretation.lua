--[[

  * * * * qrInterpretation.lua * * * *

Interprets QR codes.

Author: Joey Brown
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

local il = require "il"
local qrI = require "qrInterpretationInit"
local viz = require "visual"

--[[  * * * * Convert From Binary * * * *

  Accepts a string of binary and converts
  it to a nubmer.

  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: bin - binary string
  Returns:    sum - integer from binary string
--]]
local function convertFromBinary( bin )
  local sum = tonumber(bin, 2)
  return sum
end

--[[  * * * * Parse Bit String * * * *

  Receives an encoded binary string and 
  decodes the message to display to the user.
  Replaces any unknown characters with "~".


  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: bStr - 1D binary string array
  Returns:    msg - the decoded message
--]]
local function parseBitString( bStr )
  local msg = ""
  -- recieve input as a bit string
  local msgLUT = {
    "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "A","B","C","D","E","F","G","H","I","J","K",
    "L","M","N","O","P","Q","R","S","T","U","V",
    "W","X","Y","Z"," ","$","%","*","+","-",".",
    "/",":"
  }
  msgLUT[0] = "0"
  
  -- Check if bit string is passed in as a pair
  if #bStr == 11 then
    local num = convertFromBinary( bStr )
    local fNum = (math.floor(num / 45))
    local sNum = num - (fNum * 45)
    local f, s = "", ""
    -- Check if characters exist
    if msgLUT[fNum] then
      f = f .. msgLUT[fNum]
    else
      f = f .. "~"
    end
    if msgLUT[sNum] then
      s = s .. msgLUT[sNum]
    else
      s = s .. "~"
    end
    msg = msg .. f .. s
  end

  -- Check if bit string is passed in as single char
  if #bStr == 6 then
    local num = convertFromBinary( bStr )
    msg = msg .. msgLUT[num]
  end

  return msg
end



--[[  * * * * Get Message String * * * *

  Fills the string buffer with the encoded message until
  the End of Message pattern is located and the character
  length is reached.  

  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: img
  Returns:    output - the value(s) returned by the function
--]]
local function getMsgString( qrDS )
  local qr_msg = {}
  local len = #qrDS
  local returnMsg = ""
  local qr_indx = 1 -- index keeping track of writing to return element

  -- index the qr_msg with the encoded message length
  -- add conditions for the mask (if math.fmod(column, 3)==0 then flip bits)

  -- move up
  for i = 1, 12 do
    for j = 1, 2 do
      local z = 0
      z = qrDS[len - i + 1][len - j + 1]

      -- unmask odd columns
      if math.fmod(len - j + 1, 3) == 0 then
        if z == 1 then
          qr_msg[qr_indx] = 0
        else
          qr_msg[qr_indx] = 1
        end

      else
        qr_msg[qr_indx] = z
      end

      returnMsg = returnMsg .. qr_msg[qr_indx]
      qr_indx = qr_indx + 1
    end
  end

  -- move left then down (start = row , col - 1)
  -- same as moving up except the rows increment
  for k = 10, #qrDS do
    for l = 1, 2 do
      local z = 0
      
      z = qrDS[k][len - l - 1]
      
      -- unmask odd columns
      if math.fmod(len - l - 1, 3) == 0 then
        if z == 1 then
          qr_msg[qr_indx] = 0
        else
          qr_msg[qr_indx] = 1
        end
      else
        qr_msg[qr_indx] = z
      end
      
      returnMsg = returnMsg .. qr_msg[qr_indx]
      qr_indx = qr_indx + 1
    end
  end

  -- move left then up
  for m = 1, 12 do
    for n = 1, 2 do
      local z = 0
      z = qrDS[len - m + 1][len - n - 3]
      
      -- unmask odd columns
      if math.fmod(len - n - 3, 3) == 0 then
        if z == 1 then
          qr_msg[qr_indx] = 0
        else
          qr_msg[qr_indx] = 1
        end
      else
        qr_msg[qr_indx] = z
      end
      
      returnMsg = returnMsg .. qr_msg[m]
      qr_indx = qr_indx + 1
    end
  end

  -- move left then down
  for p = 10, #qrDS do
    for q = 1, 2 do
      local z = 0
      z = qrDS[p][len - q - 5]
      
      -- unmask odd columns
      if math.fmod(len - q - 5, 3) == 0 then
        if z == 1 then
          qr_msg[qr_indx] = 0
        else
          qr_msg[qr_indx] = 1
        end
      else
        qr_msg[qr_indx] = z
      end
      
      returnMsg = returnMsg .. qr_msg[p]
      qr_indx = qr_indx + 1
    end
  end

  -- move left then up (to end of message)
  for r = 1, 8 do
    for s = 1, 2 do
      local z = 0
      z = qrDS[len - r + 1][len - s - 7]
      
      -- unmask odd columns
      if math.fmod(len - s - 7, 3) == 0 then
        if z == 1 then
          qr_msg[qr_indx] = 0
        else
          qr_msg[qr_indx] = 1
        end
      else
        qr_msg[qr_indx] = z
      end
      
      returnMsg = returnMsg .. qr_msg[r]
      qr_indx = qr_indx + 1
    end
  end
  
  return qr_msg
end



--[[  * * * * Read Message * * * *

  Accepts a table of binary strings. and converts them
  to string values according to the look up table.

  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: bTable - table of bit strings
              len - character length
  Returns:    msg - message parsed from bits
--]]
local function readMsg( bTable )
  local m = ""
  local msg = ""
  local len = ""
  len = len .. qrI.getMsgLength( bTable )
  len = convertFromBinary( len )

  -- Check if the message length is even
  if( math.fmod( len, 2 ) == 0) then
    local l = len / 2 - 1
    for i = 0, l do
      m = ""
      for j = 0, 10 do
        m = m .. bTable[ ( i * 11 ) + j + 14 ]
      end
      msg = msg .. parseBitString( m )
    end
  -- If the message length is odd, parse only 
  -- 6 bits for the last character
  else
    local l = ( len - 1 ) / 2 - 1
    for i = 0, l do
      m = ""
      for j = 0, 10 do
        m = m .. bTable[ ( i * 11 ) + j + 14 ]
      end
      msg = msg .. parseBitString( m )
    end
    m = ""
    local l = ( len - 1 ) / 2 
    for i = 0, 5 do 
      m = m .. bTable[ l * 11 + 14 + i ]
    end
    msg = msg .. parseBitString( m )
  end
  
  return msg
end



--[[  * * * * Show * * * *

  Main function for decoding the image.
  Traverses through the image and creates a table from the 
  black and white modules of either one's or zero's. The
  code is unmasked as it is traversed. The bits are parsed
  and the message is displayed to the user. 

  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: img - image of the QR code
  Returns:    img - displays the unaltered image
--]]
local function show( img )
  img = il.RGB2YIQ( img )

  -- **build qr table with pixel coordinates**
  local r = qrI.getQRNumRows( img )
  local c = qrI.getQRNumCols( img )
  local bit_table = {} -- table for bit values

  -- **gets all the center of pixel bits from the entire QR image**
  -- **Black = 1, White = 0**
  for i = 1, r do
    bit_table[i] = {}
    for j = 1, c do
      if img:at( i * 21-10,j * 21 - 10 ).r < 128 then
        bit_table[i][j] = 1
      else
        bit_table[i][j] = 0
      end
    end
  end

  -- set up 1D array for bit string
  local bt = {}
  local windowMsg = ""
  bt = getMsgString( bit_table )

  -- extract encoding mode
  local e_Mode = ""
  
  for i = 1, 4 do
    e_Mode = e_Mode .. bt[ i ]
  end
  
  windowMsg = windowMsg .. "Encoding Mode: " .. e_Mode
  windowMsg = windowMsg .. " (" .. convertFromBinary( e_Mode ) .. ")" .. "\n"
  
  -- extract character length
  local c_Count = ""
  
  for j = 5, 13 do
    c_Count = c_Count .. bt[j]
  end
  
  windowMsg = windowMsg .. "Character Length: " .. c_Count
  windowMsg = windowMsg .. " (" .. convertFromBinary( c_Count ) .. ")" .. "\n"
  
  -- Extract decoded Message
  windowMsg = windowMsg .. "Message: [" .. readMsg( bt ) .. "]"

  -- Display message in popup window and return the original image
  viz.message( "QR Interpretation Message", windowMsg )
  img = il.YIQ2RGB( img )
  return img
end



--Function names, to be used for cross-file operations
return {
  show = show,
}