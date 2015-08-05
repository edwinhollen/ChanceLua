local chance = require("chance")

chance:seed(os.time())

print("address", chance:address())
print("ipv4", chance:ipv4())
print("ipv6", chance:ipv6())
print("hash", chance:hash())
print("name", chance:name())
print("female", chance:female())
print("male", chance:male())
print("phone", chance:phone())
print("street", chance:street())
