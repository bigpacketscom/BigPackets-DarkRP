--[[---------------------------------------------------------------------------
DarkRP custom jobs
---------------------------------------------------------------------------

This file contains your custom jobs.
This file should also contain jobs from DarkRP that you edited.

Note: If you want to edit a default DarkRP job, first disable it in darkrp_config/disabled_defaults.lua
	Once you've done that, copy and paste the job to this file and edit it.

The default jobs can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/jobrelated.lua

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomJobFields


Add jobs under the following line:
---------------------------------------------------------------------------]]


TEAM_POLICE = DarkRP.createJob("Police", {
    color = Color(25, 25, 170, 255),
    model = {"models/player/police.mdl", "models/player/police_fem.mdl", "models/player/Combine_Super_Soldier.mdl", "models/player/Combine_Soldier_PrisonGuard.mdl", "models/player/Combine_Soldier.mdl" },
    description = [[The protector of every citizen that lives in the city.
        You have the power to arrest criminals and protect innocents.
        Hit a player with your arrest baton to put them in jail.
        Bash a player with a stunstick and they may learn to obey the law.
        The Battering Ram can break down the door of a criminal, with a warrant for their arrest.
        The Battering Ram can also unfreeze frozen props (if enabled).
        Type /wanted <name> to alert the public to the presence of a criminal.]],
    weapons = {"arrest_stick", "unarrest_stick", "taser", "stunstick", "cw_fiveseven", "door_ram", "weaponchecker"},
    command = "cp",
    max = 10,
    salary = GAMEMODE.Config.normalsalary * 1.70,
    admin = 0,
    vote = true,
    hasLicense = true,
    category = "Police",
})

TEAM_CHIEF = DarkRP.createJob("Police Chief", {
    color = Color(20, 20, 255, 255),
    model = {"models/player/police.mdl", "models/player/police_fem.mdl", "models/player/Combine_Super_Soldier.mdl", "models/player/Combine_Soldier_PrisonGuard.mdl", "models/player/Combine_Soldier.mdl" },
    description = [[The Chief is the leader of the Civil Protection unit.
        Coordinate the police force to enforce law in the city.
        Hit a player with arrest baton to put them in jail.
        Bash a player with a stunstick and they may learn to obey the law.
        The Battering Ram can break down the door of a criminal, with a warrant for his/her arrest.
        Type /wanted <name> to alert the public to the presence of a criminal.
        Type /jailpos to set the Jail Position]],
    weapons = {"arrest_stick", "unarrest_stick", "taser", "stunstick", "cw_ar15", "cw_fiveseven", "door_ram", "weaponchecker"},
    command = "chief",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 2.10,
    admin = 0,
    vote = false,
    hasLicense = true,
    chief = true,
    NeedToChangeFrom = TEAM_POLICE,
    category = "Police",
})

TEAM_MAYOR = DarkRP.createJob("Mayor", {
    color = Color(150, 20, 20, 255),
    model = "models/player/breen.mdl",
    description = [[The Mayor of the city creates laws to govern the city.
    If you are the mayor you may create and accept warrants.
    Type /wanted <name>  to warrant a player.
    Type /jailpos to set the Jail Position.
    Type /lockdown initiate a lockdown of the city.
    Everyone must be inside during a lockdown.
    The cops patrol the area.
    /unlockdown to end a lockdown]],
    weapons = { "cw_m1911" },
    command = "mayor",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 2.9,
    admin = 0,
    vote = true,
    hasLicense = false,
    mayor = true,
    category = "Police",
})

TEAM_COOK = DarkRP.createJob("Cook", {
        color = Color(238, 99, 99, 255),
        model = "models/player/mossman.mdl",
        description = [[As a cook, it is your responsibility to feed the other members of your city.
            You can spawn a microwave and sell the food you make:
            /buymicrowave
			Hunger mod activates serverwide after someone is Cook]],
        weapons = {},
        command = "cook",
        max = 2,
        salary = GAMEMODE.Config.normalsalary * 1.05,
        admin = 0,
        vote = false,
        hasLicense = false,
        cook = true,
		category = "Citizens"
})

--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CITIZEN


--[[---------------------------------------------------------------------------
Define which teams belong to Police
Police can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
	[TEAM_CHIEF] = true,
	[TEAM_MAYOR] = true,
	[TEAM_POLICE] = true,
}

--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]
DarkRP.addHitmanTeam(TEAM_MOB)

TEAM_HOBO2 = DarkRP.createJob("Hobo", {
    color = Color(80, 45, 0, 255),
    model = { "models/player/corpse1.mdl" },
    description = [[You control the hobos]],
    weapons = {"weapon_bugbait", "weapon_angryhobo2015"},
    command = "hobo",
    max = 0,
    salary = 6,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    hobo = true,
    category = "Citizens",
})

TEAM_HOBOBOSS = DarkRP.createJob("Hobo Boss", {
    color = Color(80, 45, 0, 255),
    model = { "models/player/corpse1.mdl" },
    description = [[No home, no money, controlled by Hobo Boss]],
    weapons = {"weapon_bugbait", "weapon_angryhobo2015", "weapon_zipties", "cw_mr96"},
    command = "hoboboss",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 0.2,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    hobo = true,
    category = "Citizens",
})

TEAM_RAPIST = DarkRP.createJob("Rapist", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/player/Group01/Female_01.mdl",
        "models/player/Group01/Female_02.mdl",
        "models/player/Group01/Female_03.mdl",
        "models/player/Group01/Female_04.mdl",
        "models/player/Group01/Female_06.mdl",
        "models/player/group01/male_01.mdl",
        "models/player/Group01/Male_02.mdl",
        "models/player/Group01/male_03.mdl",
        "models/player/Group01/Male_04.mdl",
        "models/player/Group01/Male_05.mdl",
        "models/player/Group01/Male_06.mdl",
        "models/player/Group01/Male_07.mdl",
        "models/player/Group01/Male_08.mdl",
        "models/player/Group01/Male_09.mdl"
    },
    description = [[Same as citizen]],
    weapons = { "weapon_rape" },
    command = "rapist",
    max = 5,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens",
})

TEAM_BANKER = DarkRP.createJob("Banker", {
    color = Color(0, 79, 79, 255),
    model = "models/player/odessa.mdl",
    description = [[You control the bank, try to arm your self against police raids!]],
    weapons = {},
    command = "banker",
    max = 0,
    salary = GAMEMODE.Config.normalsalary * 1.1,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Citizens",
})

TEAM_BANKOWNER = DarkRP.createJob("Bank Owner", {
    color = Color(0, 79, 79, 255),
    model = "models/player/odessa.mdl",
    description = [[You control the bank, try to arm your self against raids!]],
    weapons = { "weapon_zipties" },
    command = "bankowner",
    max = 1,
    salary = GAMEMODE.Config.normalsalary * 2,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Citizens",
})

TEAM_DRUGDEALER = DarkRP.createJob("Drug Dealer", {
    color = Color(47, 100, 79, 255),
    model = "models/player/alyx.mdl",
    description = [[You sell drugs, Raided by police if illegal]],
    weapons = {},
    command = "drugdealer",
    max = 3,
    salary = GAMEMODE.Config.normalsalary * 0.4,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Citizens",
})

TEAM_BMD = DarkRP.createJob("Black Market Dealer", {
    color = Color(200, 100, 0, 255),
    model = "models/player/Eli.mdl",
    description = [[You sell illegal items, Shops get raided by police]],
    weapons = {},
    command = "blackmarketdealaer",
    max = 3,
    salary = GAMEMODE.Config.normalsalary * 0.7,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Citizens",
})

TEAM_THIEF = AddExtraTeam("Thief", {
    color = Color(200,160,225,255),
    model = {
        "models/player/Group01/Female_01.mdl",
        "models/player/Group01/Female_02.mdl",
        "models/player/Group01/Female_03.mdl",
        "models/player/Group01/Female_04.mdl",
        "models/player/Group01/Female_06.mdl",
        "models/player/group01/male_01.mdl",
        "models/player/Group01/Male_02.mdl",
        "models/player/Group01/male_03.mdl",
        "models/player/Group01/Male_04.mdl",
        "models/player/Group01/Male_05.mdl",
        "models/player/Group01/Male_06.mdl",
        "models/player/Group01/Male_07.mdl",
        "models/player/Group01/Male_08.mdl",
        "models/player/Group01/Male_09.mdl"
    },
    description = [[Break into people's
    house for money.
    ]],
    weapons = {"lockpick", "keypad_cracker"},
    command = "thief",
    max = 7,
    salary = GAMEMODE.Config.normalsalary * 0.3,
    admin = 0,
    vote = false,
    hasLicense = false,
 
})

TEAM_ZOMBIEKILLER = AddExtraTeam("Zombie Killer", {
    color = Color(255,100,100,255),
    model = {
        "models/player/Group01/Female_01.mdl",
        "models/player/Group01/Female_02.mdl",
        "models/player/Group01/Female_03.mdl",
        "models/player/Group01/Female_04.mdl",
        "models/player/Group01/Female_06.mdl",
        "models/player/group01/male_01.mdl",
        "models/player/Group01/Male_02.mdl",
        "models/player/Group01/male_03.mdl",
        "models/player/Group01/Male_04.mdl",
        "models/player/Group01/Male_05.mdl",
        "models/player/Group01/Male_06.mdl",
        "models/player/Group01/Male_07.mdl",
        "models/player/Group01/Male_08.mdl",
        "models/player/Group01/Male_09.mdl"
    },
    description = [[Kill zombies for protection]],
    weapons = {"cw_makarov", "cw_m1911"},
    command = "zombiekiller",
    max = 0,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = true,
    hasLicense = true,
   category = "Citizens",
})


TEAM_HOTEL = AddExtraTeam("Hotel Owner", {
    color = Color(0,127,255,255),
    model = {
        "models/player/Group01/Female_01.mdl",
        "models/player/Group01/Female_02.mdl",
        "models/player/Group01/Female_03.mdl",
        "models/player/Group01/Female_04.mdl",
        "models/player/Group01/Female_06.mdl",
        "models/player/group01/male_01.mdl",
        "models/player/Group01/Male_02.mdl",
        "models/player/Group01/male_03.mdl",
        "models/player/Group01/Male_04.mdl",
        "models/player/Group01/Male_05.mdl",
        "models/player/Group01/Male_06.mdl",
        "models/player/Group01/Male_07.mdl",
        "models/player/Group01/Male_08.mdl",
        "models/player/Group01/Male_09.mdl"
    },
    description = [[You own the hotels around the city]],
    weapons = {"cw_m1911"},
    command = "hotelowner",
    max = 0,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = true,
    hasLicense = false,
   category = "Citizens",
})



TEAM_ADMIN = AddExtraTeam("Admin on Duty", {
    color = Color(255,0,0,255),
    model = "models/player/combine_super_soldier.mdl",
    description = [[A server Admin on Duty]],
    weapons = {"arrest_stick", "unarrest_stick", "pocket", "door_ram", "keys"},
    command = "admin",
    max = 10,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    customCheck = function(ply)
        return ply:GetNWString("usergroup")=="admin" or ply:IsAdmin()
    end
})

