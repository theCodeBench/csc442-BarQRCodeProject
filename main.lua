--[[


  * * * * main.lua * * * *

Lua image processing main file start the image processing
window. All menu options are defined here.

Author: Ryan Hinrichs, Joey Brown, and Zachery Crandall
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

require "ip"
local viz = require "visual"

-- Our routines
local upcGeneration = require "upcGeneration"
local upcInterpretation = require "upcInterpretation"
local qrGeneration = require "qrGeneration"
local q = require "qrInterpretation"


-- load images listed on command line
local imgs = {...}
for _, fname in ipairs(imgs) do loadImage(fname) end



--[[

  * * * * UPC-A Barcode and QR Code Generation and Interpretation * * * *

Program Description:
This program provides both the generation and interpretation of QR codes 
and UPC-A barcodes. Generation of these objects will entail encoding a given 
string or message as either a QR code or barcode and displaying the subsequent 
code as an image. Conversely, given a QR code or barcode, the encoded message 
will be decrypted through image interpretation and reported to the user.  

A UPC-A barcode is a form of 1D barcode, as it is a scannable strip of black 
bars and white spaces requiring a scan in only one dimension. The UPC-A barcode 
is used to encode a sequence of 12 numerical digits with a 1-1 correspondence 
between the 1D barcode and this sequence of digits. The UPC-A barcodes generated
by this software will be as close to the standard sizing as is allowed by 
pixels. The interpretation of a UPC-A barcode image requires there to be minimal
noise in the image, along with near perfect alignment of the barcode. Any skewing
or perspective distortion will cause an error in the interpretation. The decoded
barcode will be validated using the checksum digit, and reported both to the 
console and a message box.

QR codes are a type of 2D barcode which encode messages in four modes, alphanumeric,
numeric, bitwise, and kanji. Only the generation of alphanumeric and numeric type
QR codes will be covered in this project. [add specifics here]
In QR code interpretation, only alphanumeric type QR codes were considered.
[add more specifics]

Author(s):  Joey Brown, Zachery Crandall, and Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Libraries:  No external libraries used.
--]]



-- Menu and menu options for point processes required
viz.imageMenu( "UPC-A Barcode",
  {
    {"Generate Barcode\tCtrl-G", upcGeneration.genUPC,
      { {name = "Number System Digit:", type = "number", displaytype = "textbox", 
          default = 0},
        {name = "Manufacturer Code:", type = "number", displaytype = "textbox",
          default = "12345"},
        {name = "Product Code:", type = "number", displaytype = "textbox", 
          default = "67890"}}},
    {"Interpret Barcode\tCtrl-I", upcInterpretation.interpUPC, hotkey = "C-I"},
  }
)



-- Menu and menu options for neighborhood filters
viz.imageMenu( "QR Code",
  {
    {"Generate QR Code\tAlt-G", qrGeneration.genQR,
      { {name = "String to Encode:", type = "string", displaytype = "textbox", 
          default = "Hello World"},
        {name = "String Type:", type = "string", displaytype = "combo",
          choices = {"Numeric", "AlphaNumeric"}, default = "AlphaNumeric"}}, hotkey = "A-G"},
    {"Interpret QR Code\tAlt-I", q.show, hotkey = "A-I"},
  }
)



-- Menu and menu options for program help
viz.imageMenu( "Help",
  {
    {"About", viz.imageMessage( "PA3", "Authors: Ryan Hinrichs, Joey Brown, and Zachery Crandall\nClass: CSC442/542 Digital Image Processing\nDate: April 24, 2017" ) },
  }
)

-- Open window to begin
viz.start()