# ChanceLua

A random _____ generator written in pure Lua. Based on the glorious Javascript library, [ChanceJS](https://github.com/victorquinn/chancejs). 

## Usage

1. Include [chance.lua](https://github.com/edwinhollen/ChanceLua/blob/master/chance.lua) in your Lua project.

2. Add a require: `local chance = require('chance')`

3. Use it! Be sure to call functions with a colon. See examples below.

### Examples

	local chance = require('chance')
	chance:seed(os.time())
	
	local name = chance:name()			-- Lauren Powell
	local address = chance:address()	-- 1279 Baserew Lane
	local phone = chance:phone()		-- 914-586-3281

	local coinFlip = chance:bool()		-- true
	local diceRoll = chance:integer(1,6)-- 2