--[[

  * * * * logAntilogLookup.lua * * * *

File containing the lookup table for Reed Solomon error
codes.  

Author: Ryan Hinrichs
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

--[[

  * * * * Invert Lookup * * * *
  
Inverts the lookup table generated in lookupTab,
so conversions into either base can take place.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: table - lookup Table to be inverted
Returns:    invert - inverted table
--]]
local function invertLookup( table )
  local invert = {}
  for key, val in pairs(table) do
    invert[val] = key
  end
  return invert
end


--[[

  * * * * Lookup Table * * * *
  
The lookup table containing elements that makeup the Galois
field.  Generated by taking the original number, taking
2 to that power, and modding the value by 285, while performing
said modulus operation on the "2^n" value until the resulting value
is less that 256.  

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: num - the number to be converted
            mode - defines if the user is referencing 
              the original or inverted table
Returns:    number- the number after being converted
--]]
local function lookupTab( num , mode)
  local logantilog = {}
  local invert = {}
  logantilog[1] = 0
  logantilog[2] = 1
  logantilog[3] = 25
  logantilog[4] = 2
  logantilog[5] = 50
  logantilog[6] = 26
  logantilog[7] = 198
  logantilog[8] = 3
  logantilog[9] = 223
  logantilog[10] = 51
  logantilog[11] = 238
  logantilog[12] = 27
  logantilog[13] = 104
  logantilog[14] = 199
  logantilog[15] = 75
  logantilog[16] = 4
  logantilog[17] = 100
  logantilog[18] = 224
  logantilog[19] = 14
  logantilog[20] = 52
  logantilog[21] = 141
  logantilog[22] = 239
  logantilog[23] = 129
  logantilog[24] = 28
  logantilog[25] = 193
  logantilog[26] = 105
  logantilog[27] = 248
  logantilog[28] = 200
  logantilog[29] = 8
  logantilog[30] = 76
  logantilog[31] = 113
  logantilog[32] = 5
  logantilog[33] = 138
  logantilog[34] = 101
  logantilog[35] = 47
  logantilog[36] = 225
  logantilog[37] = 36
  logantilog[38] = 15
  logantilog[39] = 33
  logantilog[40] = 53
  logantilog[41] = 147
  logantilog[42] = 142
  logantilog[43] = 218
  logantilog[44] = 240
  logantilog[45] = 18
  logantilog[46] = 130
  logantilog[47] = 69
  logantilog[48] = 29
  logantilog[49] = 181
  logantilog[50] = 194
  logantilog[51] = 125
  logantilog[52] = 106
  logantilog[53] = 39
  logantilog[54] = 249
  logantilog[55] = 185
  logantilog[56] = 201
  logantilog[57] = 154
  logantilog[58] = 9
  logantilog[59] = 120
  logantilog[60] = 77
  logantilog[61] = 228
  logantilog[62] = 114
  logantilog[63] = 166
  logantilog[64] = 6
  logantilog[65] = 191
  logantilog[66] = 139
  logantilog[67] = 98
  logantilog[68] = 102
  logantilog[69] = 221
  logantilog[70] = 48
  logantilog[71] = 253
  logantilog[72] = 226
  logantilog[73] = 152
  logantilog[74] = 37
  logantilog[75] = 179
  logantilog[76] = 16
  logantilog[77] = 145
  logantilog[78] = 34
  logantilog[79] = 136
  logantilog[80] = 54
  logantilog[81] = 208
  logantilog[82] = 148
  logantilog[83] = 206
  logantilog[84] = 143
  logantilog[85] = 150
  logantilog[86] = 219
  logantilog[87] = 189
  logantilog[88] = 241
  logantilog[89] = 210
  logantilog[90] = 19
  logantilog[91] = 92
  logantilog[92] = 131
  logantilog[93] = 56
  logantilog[94] = 70
  logantilog[95] = 64
  logantilog[96] = 30
  logantilog[97] = 66
  logantilog[98] = 182
  logantilog[99] = 163
  logantilog[100] = 195
  logantilog[101] = 72
  logantilog[102] = 126
  logantilog[103] = 103
  logantilog[104] = 107
  logantilog[105] = 58
  logantilog[106] = 40
  logantilog[107] = 84
  logantilog[108] = 250
  logantilog[109] = 133
  logantilog[110] = 186
  logantilog[111] = 61
  logantilog[112] = 202
  logantilog[113] = 94
  logantilog[114] = 155
  logantilog[115] = 159
  logantilog[116] = 10
  logantilog[117] = 21
  logantilog[118] = 121
  logantilog[119] = 43
  logantilog[120] = 78
  logantilog[121] = 212
  logantilog[122] = 229
  logantilog[123] = 172
  logantilog[124] = 115
  logantilog[125] = 243
  logantilog[126] = 167
  logantilog[127] = 87
  logantilog[128] = 7
  logantilog[129] = 112
  logantilog[130] = 192
  logantilog[131] = 247
  logantilog[132] = 140
  logantilog[133] = 128
  logantilog[134] = 99
  logantilog[135] = 13
  logantilog[136] = 103
  logantilog[137] = 74
  logantilog[138] = 222
  logantilog[139] = 237
  logantilog[140] = 49
  logantilog[141] = 197
  logantilog[142] = 254
  logantilog[143] = 24
  logantilog[144] = 227
  logantilog[145] = 165
  logantilog[146] = 153
  logantilog[147] = 119
  logantilog[148] = 38
  logantilog[149] = 184
  logantilog[150] = 180
  logantilog[151] = 124
  logantilog[152] = 17
  logantilog[153] = 68
  logantilog[154] = 146
  logantilog[155] = 217
  logantilog[156] = 35
  logantilog[157] = 32
  logantilog[158] = 137
  logantilog[159] = 46
  logantilog[160] = 55
  logantilog[161] = 161
  logantilog[162] = 209
  logantilog[163] = 91
  logantilog[164] = 149
  logantilog[165] = 188
  logantilog[166] = 207
  logantilog[167] = 205
  logantilog[168] = 144
  logantilog[169] = 135
  logantilog[170] = 151
  logantilog[171] = 178
  logantilog[172] = 220
  logantilog[173] = 252
  logantilog[174] = 190
  logantilog[175] = 97
  logantilog[176] = 242
  logantilog[177] = 86
  logantilog[178] = 211
  logantilog[179] = 171
  logantilog[180] = 20
  logantilog[181] = 42
  logantilog[182] = 93
  logantilog[183] = 158
  logantilog[184] = 132
  logantilog[185] = 60
  logantilog[186] = 57
  logantilog[187] = 83
  logantilog[188] = 71
  logantilog[189] = 109
  logantilog[190] = 65
  logantilog[191] = 162
  logantilog[192] = 31
  logantilog[193] = 45
  logantilog[194] = 67
  logantilog[195] = 216
  logantilog[196] = 183
  logantilog[197] = 123
  logantilog[198] = 164
  logantilog[199] = 118
  logantilog[200] = 196
  logantilog[201] = 23
  logantilog[202] = 73
  logantilog[203] = 236
  logantilog[204] = 127
  logantilog[205] = 12
  logantilog[206] = 111
  logantilog[207] = 246
  logantilog[208] = 108
  logantilog[209] = 161
  logantilog[210] = 59
  logantilog[211] = 82
  logantilog[212] = 41
  logantilog[213] = 157
  logantilog[214] = 85
  logantilog[215] = 170
  logantilog[216] = 251
  logantilog[217] = 96
  logantilog[218] = 134
  logantilog[219] = 177
  logantilog[220] = 187
  logantilog[221] = 204
  logantilog[222] = 62
  logantilog[223] = 90
  logantilog[224] = 203
  logantilog[225] = 89
  logantilog[226] = 95
  logantilog[227] = 176
  logantilog[228] = 156
  logantilog[229] = 169
  logantilog[230] = 160
  logantilog[231] = 81
  logantilog[232] = 11
  logantilog[233] = 245
  logantilog[234] = 22
  logantilog[235] = 235
  logantilog[236] = 122
  logantilog[237] = 117
  logantilog[238] = 44
  logantilog[239] = 215
  logantilog[240] = 79
  logantilog[241] = 174
  logantilog[242] = 213
  logantilog[243] = 233
  logantilog[244] = 230
  logantilog[245] = 231
  logantilog[246] = 173
  logantilog[247] = 232
  logantilog[248] = 116
  logantilog[249] = 214
  logantilog[250] = 244
  logantilog[251] = 234
  logantilog[252] = 168
  logantilog[253] = 80
  logantilog[254] = 88
  logantilog[255] = 175
  
  --Creates inversion table
  invert = invertLookup( logantilog )
  
  --Returns appropriately converted value
  if mode == 0 then
    return logantilog[num]
  else 
    return invert[num]
  end
end

--Function names, to be used for cross-file operations
return {
  lookupTab = lookupTab,
}