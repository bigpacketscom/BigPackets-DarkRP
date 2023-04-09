SMUG_CONFIG_PlayersRequired = 1 -- Amount of players required in the server before one can smuggle. [Default = 10]
SMUG_CONFIG_DefaultSmuggleDelay = 3600 -- Amount of seconds before being able to smuggle when you first join. [Default = 3600 (1 hour)]

SMUG_CONFIG_VehicleScript = "scripts/vehicles/mule.txt" -- The vehicle script to give to the smuggle truck. [Default = "scripts/vehicles/mule.txt"]
SMUG_CONFIG_VehicleModel = "models/sickness/muledr.mdl" -- The vehicle model to give to the smuggle truck. [Default = "models/sickness/muledr.mdl"]

SMUG_CONFIG_NPCBuyModel = "models/odessa.mdl" -- The model of the NPC that buys YOUR smuggle goods.
SMUG_CONFIG_NPCSellModel = "models/Eli.mdl" -- The model of the NPC that YOU buy your smuggle goods from.

SMUG_CONFIG_ConfiscateReward = 900 -- Amount of money the officer gets when he confiscates smuggle items from a vehicle.

SMUG_CONFIG_ConfiscateTeams = { -- These are the names of the jobs that are allowed to confiscate smuggle items from vehicles!
	"Police",
	"Police Chief" -- THE LAST LINE SHOULD NOT HAVE A COMMA AT THE END. BE AWARE OF THIS WHEN EDITING THIS!
}

SMUG_CONFIG_SmuggleTeams = { -- These are the names of the jobs that are allowed to smuggle.
	"Citizen",
	"Gangster",
	"Mob boss"
}