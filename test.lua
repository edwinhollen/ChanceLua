local chance = require("chance")

chance:seed(os.time())

print(chance:street())