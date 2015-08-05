local chance = {}
local letters = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
local consonants = {'b','c','d','f','g','h','j','k','l','m','n','p','r','s','t','v','w','z'}
local vowels = {'a','e','i','o','u'}


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

function chance.bool(self, likelihood)
	return chance.integer() < (likelihood or 50)
end

function chance.pick(self, list)
	return list[math.random(1, #list)]
end

function chance.pickLineFromFile(self, f)
	local lines = {}
	for line in love.filesystem.lines(f) do
		table.insert(lines, line)
	end
	return self:pick(lines)
end

function chance.male(self)
	return self:pickLineFromFile("names_male.txt"), self:last()
end

function chance.female(self)
	return self:pickLineFromFile("names_female.txt"), self:last()
end

function chance.last(self)
	return self:pickLineFromFile("names_last.txt")
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
	return firstToUpper(self:word()) .. ' ' .. self:pickLineFromFile('street_suffixes.txt')
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
	return 
end

function chance.hash(self, length)
	local str = ''
	for i=1, (length or 8) do
		if self:bool() then
			str = str .. self:pick({'a','b','c','d','e','f'})
		else
			str = str .. self:integer(0, 9)
		end
	end
	return str
end

return chance