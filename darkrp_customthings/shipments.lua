--[[---------------------------------------------------------------------------
DarkRP custom shipments and guns
---------------------------------------------------------------------------
 
This file contains your custom shipments and guns.
This file should also contain shipments and guns from DarkRP that you edited.
 
Note: If you want to edit a default DarkRP shipment, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the shipment to this file and edit it.
 
The default shipments and guns can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua
 
For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomShipmentFields
 
 
Add shipments and guns under the following line:
---------------------------------------------------------------------------]]
 
DarkRP.createShipment("Alcohol", { category = "Drug Dealer",
    model = "models/drug_mod/alcohol_can.mdl",
    entity = "durgz_alcohol",
    price = 150,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_DRUGDEALER},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Aspirin", { category = "Drug Dealer",
    model = "models/jaanus/aspbtl.mdl",
    entity = "durgz_aspirin",
    price = 456,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_DRUGDEALER},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Cigarette", { category = "Drug Dealer",
    model = "models/boxopencigshib.mdl",
    entity = "durgz_cigarette",
    price = 1278,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_DRUGDEALER},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Cocaine", { category = "Drug Dealer",
    model = "models/cocn.mdl",
    entity = "durgz_cocaine",
    price = 10000,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_DRUGDEALER},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Heroine", { category = "Drug Dealer",
    model = "models/katharsmodels/syringe_out/syringe_out.mdl",
    entity = "durgz_heroine",
    price = 9570,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_DRUGDEALER},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("LSD", { category = "Drug Dealer",
    model = "models/smile/smile.mdl",
    entity = "durgz_lsd",
    price = 4330,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_DRUGDEALER},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Marijuana/Weed", { category = "Drug Dealer",
    model = "models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl",
    entity = "durgz_weed",
    price = 6540,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_DRUGDEALER},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Methamphetamine", { category = "Drug Dealer",
    model = "models/katharsmodels/contraband/metasync/blue_sky.mdl",
    entity = "durgz_meth",
    price = 7540,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_DRUGDEALER},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Mushroom", { category = "Drug Dealer",
    model = "models/ipha/mushroom_small.mdl",
    entity = "durgz_mushroom",
    price = 3260,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_DRUGDEALER},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("PCP", { category = "Drug Dealer",
    model = "models/marioragdoll/super mario galaxy/star/star.mdl",
    entity = "durgz_pcp",
    price = 1320,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_DRUGDEALER},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Water", { category = "Drug Dealer",
    model = "models/drug_mod/the_bottle_of_water.mdl",
    entity = "durgz_water",
    price = 600,
    amount = 10,
    separate = false,
    pricesep = nil,
    noship = false,
    allowed = {TEAM_DRUGDEALER},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Grenade", {
    model = "models/weapons/w_eq_fraggrenade.mdl",
    entity = "cw_frag_grenade",
    price = 30000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Black Market Dealer",
    allowed = {TEAM_BMD},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Smoke Grenade", {
    model = "models/weapons/w_eq_smokegrenade.mdl",
    entity = "cw_smoke_grenade",
    price = 15000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Black Market Dealer",
    allowed = {TEAM_BMD},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Flash Grenade", {
    model = "models/weapons/w_eq_flashbang.mdl",
    entity = "cw_flash_grenade",
    price = 15000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Black Market Dealer",
    allowed = {TEAM_BMD},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Door Breaching Charge", {
    model = "models/weapons/w_slam.mdl",
    entity = "weapon_sh_doorcharge",
    price = 20000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Black Market Dealer",
    allowed = {TEAM_BMD},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Ak-74", {
    model = "models/weapons/w_rif_ak47.mdl",
    entity = "cw_ak74",
    price = 50000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Ar-15", {
    model = "models/weapons/w_rif_m4a1.mdl",
    entity = "cw_ar15",
    price = 50000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Five-Seven", {
    model = "models/weapons/w_pist_fiveseven.mdl",
    entity = "cw_fiveseven",
    price = 15000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Scar-H", {
    model = "models/cw2/rifles/w_scarh.mdl",
    entity = "cw_scarh",
    price = 50000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("G3A3", {
    model = "models/weapons/w_snip_g3sg1.mdl",
    entity = "cw_g3a3",
    price = 50000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("HK G36C", {
    model = "models/weapons/cw20_g36c.mdl",
    entity = "cw_g36c",
    price = 50000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("HK UMP 45", {
    model = "models/weapons/w_smg_ump45.mdl",
    entity = "cw_ump45",
    price = 30000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("HK MP5", {
    model = "models/weapons/w_smg_mp5.mdl",
    entity = "cw_mp5",
    price = 30000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Desert Eagle", {
    model = "models/weapons/w_pist_deagle.mdl",
    entity = "cw_deagle",
    price = 10000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN, TEAM_POLICE, TEAM_CHIEF, TEAM_DETECTIVE, TEAM_FBI},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("L115", {
    model = "models/weapons/w_cstm_l96.mdl",
    entity = "cw_l115",
    price = 50000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("L85A2", {
    model = "models/weapons/w_cw20_l85a2.mdl",
    entity = "cw_l85a2",
    price = 50000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("M14", {
    model = "models/weapons/w_cstm_m14.mdl",
    entity = "cw_m14",
    price = 50000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("M1911", {
    model = "models/weapons/cw_pist_m1911.mdl",
    entity = "cw_m1911",
    price = 10000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("M249", {
    model = "models/weapons/cw2_0_mach_para.mdl",
    entity = "cw_m249_official",
    price = 125000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("M3 Super 90", {
    model = "models/weapons/w_cstm_m3super90.mdl",
    entity = "cw_m3super90",
    price = 30000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Mac 11", {
    model = "models/weapons/w_cst_mac11.mdl",
    entity = "cw_mac11",
    price = 30000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN, TEAM_CHIEF},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("MR96", {
    model = "models/weapons/w_357.mdl",
    entity = "cw_mr96",
    price = 10000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("P99", {
    model = "models/weapons/w_pist_p228.mdl",
    entity = "cw_p99",
    price = 10000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("PM", {
    model = "models/cw2/pistols/w_makarov.mdl",
    entity = "cw_makarov",
    price = 10000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Serbu Shorty", {
    model = "models/weapons/cw2_super_shorty.mdl",
    entity = "cw_shorty",
    price = 15000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Vintorez", {
    model = "models/cw2/rifles/w_vss.mdl",
    entity = "cw_vss",
    price = 50000,
    amount = 10,
    separate = false,
    pricesep = 100,
    category = "Gun Dealer",
    allowed = {TEAM_GUN},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Lockpick", {
    model = "models/weapons/w_crowbar.mdl",
    entity = "lockpick",
    price = 5000,
    amount = 5,
    separate = false,
    pricesep = 100,
    category = "Black Market Dealer",
    allowed = {TEAM_BMD},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
 
DarkRP.createShipment("Keypad Cracker", {
    model = "models/weapons/w_c4.mdl",
    entity = "keypad_cracker",
    price = 5000,
    amount = 5,
    separate = false,
    pricesep = 100,
    category = "Black Market Dealer",
    allowed = {TEAM_BMD},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Pro Keypad Cracker", {
    model = "models/weapons/w_c4.mdl",
    entity = "prokeypadcracker",
    price = 7000,
    amount = 5,
    separate = false,
    pricesep = 100,
    category = "Black Market Dealer",
    allowed = {TEAM_BMD},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
DarkRP.createShipment("Taser", {
    model = "models/weapons/w_357.mdl",
    entity = "taser",
    price = 15000,
    amount = 5,
    separate = false,
    pricesep = 100,
    category = "Black Market Dealer",
    allowed = {TEAM_BMD},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
 
DarkRP.createShipment("Russian Roulette", {
    model = "models/weapons/w_357.mdl",
    entity = "weapon_roulette",
    price = 10000,
    amount = 2,
    separate = false,
    pricesep = 100,
    category = "Black Market Dealer",
    allowed = {TEAM_BMD},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
 
DarkRP.createShipment("Deployable Keypad Cracker", {
    model = "models/weapons/w_c4.mdl",
    entity = "weapon_sh_keypadcracker_deploy",
    price = 25000,
    amount = 5,
    separate = false,
    pricesep = 100,
    category = "Black Market Dealer",
    allowed = {TEAM_BMD},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})
 
 
DarkRP.createShipment("Unarrest Baton", {
    model = "models/weapons/w_stunbaton.mdl",
    entity = "unarrest_stick",
    price = 50000,
    amount = 5,
    separate = false,
    pricesep = 100,
    category = "Black Market Dealer",
    allowed = {TEAM_BMD},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})

DarkRP.createShipment("Graffiti Spray Can", {
    model = "models/props_c17/canister02a.mdl",
    entity = "weapon_spraymhs",
    price = 4620,
    amount = 5,
    separate = false,
    pricesep = 100,
    category = "Black Market Dealer",
    allowed = {TEAM_BMD},
    getPrice = function(ply, price) return ply:GetNWString("usergroup") == "vip" and price * 0.95 or price end,
})