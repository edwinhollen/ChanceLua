# ChanceLua

A random "everything" generator, written in pure Lua. ChanceLua is based on the lovely Javascript library, [ChanceJS](http://chancejs.com/). 

## At a glance

ChanceLua can generate integers, characters (even whole words), pick a random item from a list, output a boolean given a likelihood. It can also generate names, addresses, telephone numbers, IP addresses (v4 and v6), colors, and more!

ChanceLua is licensed under the [MIT license](http://opensource.org/licenses/MIT).

## Usage

1. Include [chance.lua](https://github.com/edwinhollen/ChanceLua/blob/master/chance.lua) in your Lua project.

2. Add a require: `local chance = require('chance')`

3. Use it! Be sure to call functions with a colon. See examples and documentation below.

### Examples

	local chance = require('chance')
	chance:seed(os.time())
	
	local name = chance:name()			-- Lauren Powell
	local address = chance:address()	-- 1279 Baserew Lane
	local phone = chance:phone()		-- 914-586-3281

	local coinFlip = chance:bool()		-- true
	local diceRoll = chance:integer(1,6)-- 2

---

## Functions

[Seed][#Seed]

[Basics][#Basics]

[Lists][#Lists]

[Names][#Names]

[Words][#Words]

[Locations][#Locations]

[Technology][#Technology]

[Colors][#Colors]

[Miscellaneous][#Miscellaneous]

### Seed
	
	chance:seed()
	chance:seed(1337)
	chance:seed(os.time())

Applying a seed is optional. By default, no seed is set; this means chance will return the same results each time the program is run. 

Running `chance:seed()` (with no arguments) will set the seed to the current time, `os.time()`. 

### Basics

**bool**

	chance:bool()     -- 50% likelihood
	chance:bool(0.97) -- 97% likelihood
	chance:bool(1/8)	-- 1/8 = 12.5% likelihood

Returns a random value `true` or `false`. Default likelihood is 50% (like a coin flip). 

**integer**

	chance:integer()
	chance:integer(20)
	chance:integer(-5, 5)

Returns a random number. Can optionally specify a max (0 to max), or a min and max (min to max). Ranges are *inclusive*, meaning `chance:integer(-5, 5)` can return either `-5` or `5`. 

**character**

	chance:character()		-- letters, numbers, and symbols
	chance:character(true)	-- letters

Returns a random character. Can optionally specify to only return a letter (alpha). 

**string**

	chance:string()
	chance:string(6)
	chance:string(6, {'a', 'b', 'c', '1'})

Returns a random string. By default, returns a 16 character string of letters. Optionally specify a length or a pool of characters.

### Lists

**pick**

	chance:pick({'apple', 'banana', 'cabbage'})

Returns a random item from a table.

**shuffle**

	chance:shuffle({'a', 'b', 'c', 'd'})	-- returns {'c','a','b','d'}

Returns a new list. Shuffles the values (like shuffling a deck of cards). Does not modify the provided list.

### Names

*Note: chance.lua comes pre-loaded with 50 male first names, 50 female first names, and 100 last names. Data gathered from 2000 US Census.*

**name**

	chance:name()
	chance:name(true)	-- also return a last name
	
Returns a random first name as a string, male or female. Format is `first last`. Optionally return a last name.

**male**
	
	chance:male()
	chance:male(true)	-- with a last name

Returns a random male first name. Optionally return with a last name.

**female**

	chance:female()
	chance:female(true)	-- with a last name

Returns a random female first name. Optionally return with a last name.

**last**
	
	chance:last()
	
Returns a random last name. 


### Words

**word**

	chance:word()

Returns a random word (not English or language-specific). A short collection of vowels and consonants arranged in a pronounceable way. 

**syllable**

	chance:syllable()

Returns a random syllable.

**vowel**

	chance:vowel()

Returns a random vowel.

**consonant**

	chance:consonant()

Returns a random consonant.


### Locations

**street**

	chance:street()

Returns a random name with a random street suffix.

**address**

	chance:address()

Returns a random address with a random street.


### Technology

**phone**

	chance:phone()

Returns a random phone number in US ###-###-#### format. 

**ip**

	chance:ip()

Returns a random IP address, either IPv4 or IPv6.

**ipv4**

	chance:ipv4()

Returns a random IPv4 address.

**ipv6**

	chance:ipv6()

Returns a random IPv6 address.

**hash**
	
	chance:hash()
	chance:hash(32)

Returns a random hash. Can optionally specify the number of characters.

### Colors

**hsl**

	local h, s, l = chance:hsl()
	print(h,s,l) 	--	253	19%	34%

Returns *(multiple values)* a random color with HSL values.

**hsla**
	
	local h, s, l, a = chance:hsla()
	print(h,s,l,a)	--	272	23%	37%	0.84

Returns *(multiple values)* a random color with HSLa values.

**rgb**

	local r, g, b = chance:rgb()
	print(r,g,b)	--	148	71	253

Returns *(multiple values)* a random color with RGB values.

**rgba**

	local r, g, b, a = chance:rgba()
	print(r,g,b,a)	--	198	91	109	103

Returns *(multiple values)* a random color with RGBa values.

### Miscellaneous

**pickLineFromFile**

    local randomItem = chance:pickLineFromFile('items.txt')
    
Returns a random line (as a string) from a text file.

*Note: I have only tested this with .txt files (UTF-8).*