--[[ * * * * qrInterpretationInit.lua * * * *

Initializes everything required for interpreting
QR codes.

Author: Joey Brown
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]



--[[

  * * * * Get Finder Width * * * *
  
  Moves right and returns the number
  of black pixels traversed as the 
  width of the box.

  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: img - image of the QR code
  Returns:    width - number of pixels contained in the box
  
--]]
function getFinderWidth( img )
  local white = 255
  local width = 0
  
  -- Move right until first white pixel
  for c = 0, img.width do
    if img:at(0,c).y == white then
      break 
    end
    width = width + 1
  end
  
  return width
end



--[[

  * * * * Get Finder Height * * * *

  Moves down and returns the number of black pixels traversed as the 
  height of the box.

  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: img - image of the QR code
  Returns:    height - number of black pixels 
                        in the box
--]]
local function getFinderHeight( img )
  local i_height = img.height
  local white = 255
  local h = 0
  
  -- Move down until first white pixel
  for r = 0, i_height do
    if img:at(r,0).y == white then
      break 
    end
    h = h + 1
  end

  return h
end



--[[

  * * * * Get Module Width * * * *
  
  Uses getFinderWidth to get the size of the module bits.
  
  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: img - image of the QR code
  Returns:    bHeight - number of black pixels 
                        in the module
--]]
function getModuleWidth( img )
  local mWidth = 0
  mWidth = math.floor( 0.5 + getFinderWidth( img ) / 7)
  return mWidth
end



--[[

  * * * * Get Module Height * * * *
  
  Uses getFinderHeight to get
  the size of the module bits.
  
  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: img - image of the QR code
  Returns:    bHeight - number of black pixels 
                        in the module
--]]
function getModuleHeight( img )
  local mHeight = 0
  
  mHeight = math.floor( 0.5 + getFinderHeight( img ) / 7 )
  
  return mHeight
end



--[[

  * * * * Get QR NumRows * * * *
  
  Divides the total number of pixels in the first row of the image by 
  21 (rounded down). Returns the result as the number of rows in the QR code.

  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: img - image of the QR code
  Returns:    rows - number of pixels in 
                  the first row of the 
                  image divided by 21.
--]]
local function getQRNumRows( img )
  return math.floor( 0.5 + img.height / 21 )
end



--[[

  * * * * Get QR NumCols * * * *
  
  Divides the total number of pixels in the first column of the image by 
  21 (rounded down). Returns the result as the number of columns in the QR code.

  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: img - image of the QR code
  Returns:    cols - number of pixels in 
                  the first row of the 
                  image divided by 21.
--]]
local function getQRNumCols( img )
  return math.floor( 0.5 + img.width / 21 )
end



--[[
  * * * * Parse Bits * * * *
  
  Receives a table of pixel values. The returned value is incremented
  by 1 for every pixel in the table that is > 0. The integer that is 
  returned is used to index a table with the type of error correction.

  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: b_Table - table of bit coordinate values
  Returns:    enc - integer of encoding
--]]
local function parseBits( b_Table )
  local x = 0
  
  -- for i = 0, table.getn(b_Table) do
  for i=0, #b_Table do
    if b_Table[i] > 0 then
      x = x + 1
    end
  end
  
  return x
end



--[[

  * * * * Get Mask * * * *
  
  Receives a table of pixel values. The returned value is incremented
  by 1 for every pixel in the table that is > 0. the integer returned
  use used to index a table with the mask that is needed to demask
  the QR code before parsing it.

  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: b_Table - table of bit coordinate values
  Returns:    enc - integer of encoding
--]]
local function getMask( )
  return parseBits()
end



--[[
  * * * * Get Message Length * * * *
  
  Receives a table of pixel values. The returned value is incremented
  by 1 for every pixel in the table that is > 0. The integer that is 
  returned is the length of the message.

  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: b_Table - table of bit coordinate values
  Returns:    enc - integer of encoding
--]]
local function getMsgLength( b_Table )
  local c = ""
  
  for j = 5, 13 do
    c = c .. b_Table[j]
  end
    
  return c
end


--[[

  * * * * Get Message Encoding * * * *
  
  Receives a table of pixel values. The returned value is incremented
  by 1 for every pixel in the table that is > 0. The integer that is 
  returned is used to index a table with the type of message encoding.

  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: b_Table - table of bit coordinate values
  Returns:    enc - integer of encoding
--]]
local function getMsgEncoding( b_Table )
  return parseBits(b_Table);
end



--[[

  * * * * Get Bit At * * * *
  
  Receives pixel coordinates as input. If input value is greater than 0, then 
  it returns a 1 bit. Otherwise, it returns a 0 bit. 
  Recommended to use as:
    btable = img:at(r,c)
    num = getBitAt( btable )

  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: b_Table - QR code image
  Returns:    bit - binary value of pixel value
--]]
local function getBitAt( img, img_x, img_y )
  local bit = 0

  if img:at(img_x, img_y).r > 0 then
    bit = 1
  end
  
  return bit
end



--[[

  * * * * Get All Bits At * * * *
  
  Receives a range of pixel coordinates as input.
  Returns binary 

  Author:     Joey Brown
  Class:      CSC442/542 Digital Image Processing
  Date:       Spring 2017
  Parameters: pix_arr - table of pixel coordinates
  Returns:    bit - binary value of pixel value
--]]
local function getAllBitsAt( pix_arr )
  local b_Table = {}
  
  for i = 0, #pix_arr do
    b_Table[i] = getBitAt( pix_arr )
  end
  
  return b_Table
end



return {
    getFinderWidth = getFinderWidth,
    getFinderHeight = getFinderHeight,
    getModuleWidth = getModuleWidth,
    getModuleHeight = getModuleHeight,
    getQRNumRows = getQRNumRows,
    getQRNumCols = getQRNumCols,
    getMask = getMask,
    getMsgEncoding = getMsgEncoding,
    getMsgLength = getMsgLength,
    getBitAt = getBitAt,
    getAllBitsAt = getAllBitsAt,
    parseBits = parseBits,
}