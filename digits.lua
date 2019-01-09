--[[

  * * * * digits.lua * * * *

File containing the get functions for 7 x 13 tables of
the digits 0-9.

Author: Zachery Crandall
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

--[[

  * * * * Get Zero * * * *
  
Returns an 7 x 13 array representing the number zero.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Returns:    number - 7 x 13 table of the number zero
--]]
local function getZero() --0
  local zero = { 
    -- Zero
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 0, 1, 1, 0}, 
    {1, 1, 0, 0, 0, 1, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 1, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 1, 0, 0, 0, 1, 1},
    {0, 1, 1, 0, 1, 1, 0}, 
    {0, 0, 1, 1, 1, 0, 0}, }

  return zero
end



--[[

  * * * * Get One * * * *
  
Returns an 7 x 13 array representing the number one.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Returns:    number - 7 x 13 table of the number one
--]]
local function getOne() --1
  local one = { {0, 1, 1, 1, 0, 0, 0},
    {1, 1, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {1, 1, 1, 1, 1, 1, 1}, }

  return one
end



--[[

  * * * * Get Two * * * *
  
Returns an 7 x 13 array representing the number two.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Returns:    number - 7 x 13 table of the number two
--]]
local function getTwo() --2
  local two = { {0, 1, 1, 1, 1, 0, 0},
    {1, 1, 0, 0, 1, 1, 0},
    {0, 0, 0, 0, 0, 1, 1},
    {0, 0, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 0, 1, 1},
    {0, 0, 0, 0, 1, 1, 0},
    {0, 0, 0, 1, 1, 0, 0},
    {0, 0, 1, 1, 0, 0, 0},
    {0, 1, 1, 0, 0, 0, 0},
    {1, 1, 0, 0, 0, 0, 0},
    {1, 1, 1, 1, 1, 1, 1}, }

  return two
end



--[[

  * * * * Get Three * * * *
  
Returns an 7 x 13 array representing the number three.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Returns:    number - 7 x 13 table of the number three
--]]
local function getThree() --3
  local three = { {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 0, 0, 0, 1, 1},
    {0, 0, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 0, 1, 1},
    {0, 0, 0, 1, 1, 1, 0},
    {0, 0, 0, 0, 0, 1, 1},
    {0, 0, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 0, 0, 1},
    {1, 1, 0, 0, 0, 1, 1},
    {0, 1, 1, 1, 1, 1, 0}, }

  return three
end



--[[

  * * * * Get Four * * * *
  
Returns an 7 x 13 array representing the number four.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Returns:    number - 7 x 13 table of the number four
--]]
local function getFour() --4
  local four = { {0, 0, 0, 0, 1, 1, 0},
    {0, 0, 0, 0, 1, 1, 0},
    {0, 0, 0, 1, 0, 1, 0},
    {0, 0, 0, 1, 0, 1, 0},
    {0, 0, 1, 0, 0, 1, 0},
    {0, 0, 1, 0, 0, 1, 0},
    {0, 1, 0, 0, 0, 1, 0},
    {1, 0, 0, 0, 0, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 0, 0, 0, 0, 1, 0},
    {0, 0, 0, 0, 0, 1, 0},
    {0, 0, 0, 0, 0, 1, 0},
    {0, 0, 0, 0, 0, 1, 0},}

  return four
end



--[[

  * * * * Get Five * * * *
  
Returns an 7 x 13 array representing the number five.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Returns:    number - 7 x 13 table of the number five
--]]
local function getFive() --5
  local five = { {1, 1, 1, 1, 1, 1, 0},
    {1, 0, 0, 0, 0, 0, 0},
    {1, 0, 0, 0, 0, 0, 0},
    {1, 0, 0, 0, 0, 0, 0},
    {1, 0, 0, 0, 0, 0, 0},
    {1, 0, 0, 0, 0, 0, 0},
    {1, 1, 1, 1, 1, 1, 0},
    {0, 0, 0, 0, 0, 1, 1},
    {0, 0, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 0, 0, 1},
    {1, 1, 0, 0, 0, 1, 1},
    {0, 1, 1, 1, 1, 1, 0}, }

  return five
end



--[[

  * * * * Get Six * * * *
  
Returns an 7 x 13 array representing the number six.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Returns:    number - 7 x 13 table of the number six
--]]
local function getSix() --6
  local six = { {0, 0, 1, 1, 1, 1, 0},
    {0, 1, 1, 0, 0, 1, 1},
    {1, 1, 0, 0, 0, 0, 0},
    {1, 0, 0, 0, 0, 0, 0},
    {1, 0, 0, 0, 0, 0, 0},
    {1, 0, 1, 1, 1, 1, 0},
    {1, 1, 0, 0, 0, 1, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 1, 0, 0, 0, 1, 1},
    {0, 1, 1, 1, 1, 1, 0}, }

  return six
end



--[[

  * * * * Get Seven * * * *
  
Returns an 7 x 13 array representing the number seven.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Returns:    number - 7 x 13 table of the number seven
--]]
local function getSeven() --7
  local seven = { {1, 1, 1, 1, 1, 1, 1},
    {0, 0, 0, 0, 0, 1, 1},
    {0, 0, 0, 0, 0, 1, 0},
    {0, 0, 0, 0, 1, 1, 0},
    {0, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 1, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 0},
    {0, 1, 1, 0, 0, 0, 0},
    {0, 1, 0, 0, 0, 0, 0},
    {1, 1, 0, 0, 0, 0, 0},
    {1, 0, 0, 0, 0, 0, 0}, }

  return seven
end



--[[

  * * * * Get Eight * * * *
  
Returns an 7 x 13 array representing the number eight.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Returns:    number - 7 x 13 table of the number eight
--]]
local function getEight() --8
  local eight = { {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 0, 0, 0, 1, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 1, 0, 0, 0, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 0, 0, 0, 1, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 1, 0, 0, 0, 1, 1},
    {0, 1, 1, 1, 1, 1, 0}, }

  return eight
end



--[[

  * * * * Get Nine * * * *
  
Returns an 7 x 13 array representing the number nine.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Returns:    number - 7 x 13 table of the number nine
--]]
local function getNine() --9
  local nine = { {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 0, 0, 0, 1, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 1, 0, 0, 0, 1, 1},
    {0, 1, 1, 1, 1, 0, 1},
    {0, 0, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 0, 0, 1},
    {0, 0, 0, 0, 0, 1, 1},
    {1, 1, 0, 0, 1, 1, 0},    
    {0, 1, 1, 1, 1, 0, 0}, }

  return nine
end



--[[

  * * * * Get a Number * * * *

Retrieves a 7 x 13 array representing the requested digit.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: digit - the digit to retrieve
Returns:    number - 7 x 13 table of the requested digit
                   - if not found, nil will be returned
--]]
local function getNumber( digit )
  local number = {}

  -- Check for valid digit
  if digit < 0 or digit > 9 then
    return
  end

  -- Get the correct number
  if digit == 0 then
    number = getZero()
  elseif digit == 1 then
    number = getOne()
  elseif digit == 2 then
    number = getTwo()
  elseif digit == 3 then
    number = getThree()
  elseif digit == 4 then
    number = getFour()
  elseif digit == 5 then
    number = getFive()
  elseif digit == 6 then
    number = getSix()
  elseif digit == 7 then
    number = getSeven()
  elseif digit == 8 then
    number = getEight()
  else
    number = getNine()
  end

  return number
end



--Function names, to be used for cross-file operations
return {
  getNumber = getNumber,
}