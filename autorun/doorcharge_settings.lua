--------LEAKED BY Friendly Man--------
--------leakforums.net/user-1034794--------
AddCSLuaFile()

DOORCHARGE_SETTINGS = {
	-- Should the shaped charge just unhinge the door, or make it boost forward?
	UnhingeOnly = false,

	-- Should the shaped charge explosion deal blast damage to the surroundings?
	BlastDamage = true,

	-- Should a player get kill credit for killing someone with a door?
	DoorKillCredit = true,
	
	-- Can the door charge be destroyed when taking damage?
	Destroyable = true,

	-- Time after which a busted door respawns (in seconds)
	-- Set to 0 to never respawn - ideal for TTT. (until map clean up)
	RespawnTime = 1 * 60, -- 1 minutes

	-- Allow players to deploy more than one door charge for a single detonator?
	-- Ideal for blasting double doors.
	-- This is always off on TTT!
	AllowMultipleCharges = true,

	-- Delay (in seconds) between 2 explosions by the same detonator
	SimultaneousDelay = 0.2,

	--- TTT-specific options!
	TTT = {
		-- Can Traitors get shaped charges?
		TraitorsGet = true,

		-- Can Detectives get shaped charges?
		DetectivesGet = false,

		-- Can they get it only once or not?
		LimitedStock = true,
	},

	-- Use Steam Workshop insteaad of FastDL for content?
	UseWorkshop = true,
}

if (SERVER) then
	if (DOORCHARGE_SETTINGS.UseWorkshop) then
		resource.AddWorkshop("684399836")
	else
		-- don't need the spawnmenu icon if we're playing TTT
		if (engine.ActiveGamemode() ~= "terrortown") then
			resource.AddSingleFile("materials/entities/weapon_sh_doorcharge.png")
			resource.AddSingleFile("materials/weapons/weapon_sh_doorcharge.vmt")
			resource.AddSingleFile("materials/weapons/weapon_sh_doorcharge.vtf")
		else -- TTT specific content
			resource.AddSingleFile("materials/vgui/ttt/icon_doorcharge.vmt")
			resource.AddSingleFile("materials/vgui/ttt/icon_doorcharge.vtf")
		end
	end
end