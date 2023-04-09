--[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
	Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua#L111

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]
DarkRP.createEntity("Ammo Kit (10 Resupplies)", {
    ent = "cw_ammo_kit_regular",
    model = "models/Items/BoxMRounds.mdl",
    price = 2215,
    max = 10,
    cmd = "buyammokit",
	getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})

DarkRP.createEntity("Ammo Crate (36 Resupplies)", {
    ent = "cw_ammo_crate_regular",
    model = "models/Items/ammoCrate_Rockets.mdl",
    price = 6700,
    max = 10,
    cmd = "buyammocrate",
	getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})

DarkRP.createEntity("Printer Repair Kit", {
    ent = "printer_repairkit",
    model = "models/props_lab/reciever01d.mdl",
    price = 6800,
    max = 6,
    cmd = "buyrepairkit",
	getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})

DarkRP.createEntity("Old Bank Money Printer", {
    ent = "printer_oldbankprinter",
    model = "models/props_c17/consolebox01a.mdl",
    price = 6000,
    max = 5,
    cmd = "buyoldpacketprinter",
	getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})

DarkRP.createEntity("Bank Money Printer", {
    ent = "printer_bankprinter",
    model = "models/props_c17/consolebox01a.mdl",
    price = 23000,
    max = 5,
    cmd = "buypacketprinter",
	getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})

DarkRP.createEntity("Industiral Bank Money Printer", {
    ent = "printer_industrialbankprinter",
    model = "models/props_c17/consolebox01a.mdl",
    price = 80000,
    max = 5,
    cmd = "buyindustrialpacketprinter",
	getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})

DarkRP.createEntity("ULTRA Bank Money Printer", {
    ent = "printer_ultrabankprinter",
    model = "models/props_c17/consolebox01a.mdl",
    price = 390000,
    max = 5,
    cmd = "buyultrapacketprinter",
	getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})

DarkRP.createEntity("(Weed) Ceramic Pot", { 
ent = "ent_jack_job_potplant", 
model = "models/nater/weedplant_pot.mdl", 
price = 20, 
max = 4, 
cmd = "buyplantpot", 
	getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})

DarkRP.createEntity("(Weed) Potting Soil", { 
ent = "ent_jack_job_potsoil", 
model = "models/props_junk/garbage_bag001a.mdl", 
price = 10, 
max = 8, 
cmd = "buyplantsoil" ,
	getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})

DarkRP.createEntity("(Weed) Sun Lamp", { 
ent = "ent_jack_job_plantlamp", 
model = "models/props_interiors/Furniture_Lamp01a.mdl", 
price = 120, 
max = 1, 
cmd = "buyplantlamp" ,
	getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
}) 

DarkRP.createEntity("(Weed) Cannabis Seed", { 
ent = "ent_jack_job_weedseed", 
model = "models/props_junk/garbage_bag001a.mdl", 
price = 300, 
max = 8, 
cmd = "buyplantseed" ,
	getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
}) 

DarkRP.createEntity("(Weed) Watering Can", { 
ent = "wep_jack_job_watercan", 
model = "models/props_interiors/pot01a.mdl", 
price = 10, 
max = 5, 
cmd = "buyplantwater", 
	getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
}) 


DarkRP.createEntity("Drug lab", {
    ent = "drug_lab",
    model = "models/props_lab/crematorcase.mdl",
    price = 400,
    max = 6,
    cmd = "buydruglab",
	category = "Gangsters",
    allowed = {TEAM_GANG, TEAM_MOB},
	getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})


DarkRP.createEntity("Gun lab", {
    ent = "gunlab",
    model = "models/props_c17/TrapPropeller_Engine.mdl",
    price = 500,
    max = 6,
    cmd = "buygunlab",
	category = "Gun Dealer",

    allowed = TEAM_GUN,
	getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})


DarkRP.createEntity("Microwave", {
        ent = "microwave",
        model = "models/props/cs_office/microwave.mdl",
        price = 400,
        max = 5,
        cmd = "buymicrowave",
		category = "Cook",
        allowed = TEAM_COOK,
	getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})

