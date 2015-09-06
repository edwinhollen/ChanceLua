local chance = {}
local symbols = {'!','@','#','$','%','^','&','*','(',')'}
local numbers = {0,1,2,3,4,5,6,7,8,9}
local letters = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
local consonants = {'b','c','d','f','g','h','j','k','l','m','n','p','r','s','t','v','w','z'}
local vowels = {'a','e','i','o','u'}
local names_male = {'Jacob','Michael','Joshua','Matthew','Daniel','Christopher','Andrew','Ethan','Joseph','William','Anthony','David','Alexander','Nicholas','Ryan','Tyler','James','John','Jonathan','Noah','Brandon','Christian','Dylan','Samuel','Benjamin','Nathan','Zachary','Logan','Justin','Gabriel','Jose','Austin','Kevin','Elijah','Caleb','Robert','Thomas','Jordan','Cameron','Jack','Hunter','Jackson','Angel','Isaiah','Evan','Isaac','Luke','Mason','Jason','Jayden'}
local names_female = {'Emily','Madison','Emma','Olivia','Hannah','Abigail','Isabella','Samantha','Elizabeth','Ashley','Alexis','Sarah','Sophia','Alyssa','Grace','Ava','Taylor','Brianna','Lauren','Chloe','Natalie','Kayla','Jessica','Anna','Victoria','Mia','Hailey','Sydney','Jasmine','Julia','Morgan','Destiny','Rachel','Ella','Kaitlyn','Megan','Katherine','Savannah','Jennifer','Alexandra','Allison','Haley','Maria','Kaylee','Lily','Makayla','Brooke','Nicole','Mackenzie','Addison'}
local names_last = {'Smith','Johnson','Williams','Jones','Brown','Davis','Miller','Wilson','Moore','Taylor','Anderson','Thomas','Jackson','White','Harris','Martin','Thompson','Garcia','Martinez','Robinson','Clark','Rodriguez','Lewis','Lee','Walker','Hall','Allen','Young','Hernandez','King','Wright','Lopez','Hill','Scott','Green','Adams','Baker','Gonzalez','Nelson','Carter','Mitchell','Perez','Roberts','Turner','Phillips','Campbell','Parker','Evans','Edwards','Collins','Stewart','Sanchez','Morris','Rogers','Reed','Cook','Morgan','Bell','Murphy','Bailey','Rivera','Cooper','Richardson','Cox','Howard','Ward','Torres','Peterson','Gray','Ramirez','James','Watson','Brooks','Kelly','Sanders','Price','Bennett','Wood','Barnes','Ross','Henderson','Coleman','Jenkins','Perry','Powell','Long','Patterson','Hughes','Flores','Washington','Butler','Simmons','Foster','Gonzales','Bryant','Alexander','Russell','Griffin','Diaz','Hayes'}
local street_suffixes = {'Avenue','Ave','Boulevard','Blvd','Center','Ctr','Circle','Cir','Court','Ct','Drive','Dr','Extension','Ext','Glen','Gln','Grove','Grv','Heights','Hts','Highway','Hwy','Junction','Jct','Key','Key','Lane','Ln','Loop','Manor','Mill','Park','Parkway','Pkwy','Pass','Path','Pike','Place','Pl','Plaza','Plz','Point','Pt','Ridge','Rdg','River','Riv','Road','Rd','Square','Sq','Street','St','Terrace','Ter','Trail','Trl','Tr','Turnpike','Tpke','View','Vw','Way'}

-- Helper functions (local)

local function tableToString(t)
	local str = ''
	for k,v in ipairs(t) do
		str = str .. v
	end
	return str
end

local function stringToTable(str)
	local t = {}
	for c in str:gmatch('.') do
		table.insert(t, c)
	end
	return t
end

local function contains(haystack, needle)
	for key, value in ipairs(haystack) do
		if value == needle then return true end
	end
	return false
end

local function firstToUpper(str)
	return str:sub(1, 1):upper()..str:sub(2)
end

local function joinTables(...)
	local t = {}
	for k,v in ipairs({...}) do
		for ik, iv in ipairs(v) do
			table.insert(t, iv)
		end
	end
	return t
end


-- Library functions 

function chance.seed(self, seed)
	math.randomseed(seed or (os.time()))
end

function chance.integer(self, a, b)
	if a == nil and b == nil then
		return math.random(0, 100)
	end
	if b == nil then
		return math.random(a)
	end
	return math.random(a, b)
end

function chance.character(self, alpha)
	if alpha == nil then alpha = false end
	if alpha then return self:pick(letters) end
	return self:pick(joinTables(letters, numbers, symbols))
end

function chance.bool(self, likelihood)
	likelihood = likelihood or 50
	if likelihood <= 0 then
		return 0
	end
	if likelihood < 1 then
		likelihood = likelihood * 100
	end
	return chance.integer(0, 100) < (likelihood or 50)
end

function chance.pick(self, list)
	return list[math.random(1, #list)]
end

function chance.shuffle(self, list)
	local shuffled = {}
	-- duplicate the list
	for k,v in ipairs(list) do
		shuffled[k] = v
	end
	-- perform a Fisher-Yates shuffle
	for i=1, #shuffled do
		local j = self:integer(i, #list)
		local tmp_i = shuffled[i]
		local tmp_j = shuffled[j]
		shuffled[j] = tmp_i
		shuffled[i] = tmp_j
	end
	return shuffled
end

function chance.pickLineFromFile(self, f)
	local lines = {}	
	for line in io.lines(f) do
		table.insert(lines, line)
	end
	return self:pick(lines)
end

function chance.male(self, lastName)
	local n = self:pick(names_male)
	if lastName then
		return n .. ' ' .. self:last()
	end
	return n
end

function chance.female(self, lastName)
	local n = self:pick(names_female)
	if lastName then
		return n .. ' ' .. self:last()
	end
	return n
end

function chance.last(self)
	return self:pick(names_last)
end

function chance.name(self, lastName)
	if lastName == nil then lastName = false end
	if self:bool() then
		return self:male(lastName)
	else
		return self:female(lastName)
	end
end

function chance.syllable(self)
	local chars = {}
	table.insert(chars, self:letter())
	local length = math.random(2, 3)
	for i=1, length do
		local newChar
		if self:isVowel(chars[i]) then
			newChar = self:consonant()
		else
			newChar = self:vowel()
		end
		table.insert(chars, newChar)
	end
	return tableToString(chars)
end

function chance.letter(self)
	return self:pick(letters)
end

function chance.consonant(self)
	return self:pick(consonants)
end

function chance.isConsonant(self, char)
	return contains(consonants, char)
end

function chance.vowel(self)
	return self:pick(vowels)
end

function chance.isVowel(self, char)
	return contains(vowels, char)
end

function chance.word(self)
	local word = ''
	for i=1, math.random(1, 3) do
		word = word .. self:syllable()
	end
	return word
end

function chance.street(self)
	return firstToUpper(self:word()) .. ' ' .. self:pick(street_suffixes)
end

function chance.address(self)
	return self:integer(5, 2000) .. ' ' .. self:street()
end

function chance.phone(self)
	local str = ''
	for i=1,12 do
		local c
		if i == 4 or i == 8 then
			c = '-'
		else
			c = self:integer(0, 9)
		end
		str = str .. c
	end
	return str
end

function chance.ipv4(self)
	local str = ''
	for i=1, 4 do
		str = str .. self:integer(0, 255)
		if i ~= 4 then str = str .. '.' end
	end
	return str
end

function chance.ipv6(self)
	local str = ''
	for i=1,8 do
		str = str .. self:hash(4)
		if i ~= 8 then
			str = str .. ':'
		end
	end
	return str
end

function chance.ip(self)
	if self:bool() then
		return self:ipv4()
	else
		return self:ipv6()
	end
end

function chance.hash(self, length)
	local pool = {'a','b','c','d','e','f', 1, 2, 3, 4, 5, 6, 7, 8, 9}
	return self:string((length or 8), pool)
end

function chance.string(self, length, pool)
	length = length or 16
	pool = pool or letters
	local str = ''
	for i=1, length do
		str = str .. self:pick(pool)
	end
	return str
end

function chance.rgba(self)
	return self:integer(0, 255), self:integer(0, 255), self:integer(0, 255), self:integer(0, 255)
end

function chance.rgb(self)
	local r, g, b = self:rgba()
	return r, g, b
end

function chance.hsla(self)
	return self:integer(0, 360), ('%i%%'):format(self:integer(0, 100)), ('%i%%'):format(self:integer(0, 100)), self:integer(0, 100) / 100
end

function chance.hsl(self)
	local h, s, l = self:hsla()
	return h, s, l
end

return chance