AddCSLuaFile()

KEYPADCRACKER_SETTINGS = {
	-- Time (in seconds) it takes for the Keypad Cracker to do its job
	HackDuration = 60,
	
	-- Should the cracker trigger the Keypad's Denied action if the cracking fails?
	TriggerDenyOnFail = true,

	-- Chance for the Keypad Cracker to fail (0-1)
	-- 0: never fail
	-- 1: always fail
	FailChance = 0.2,
	
	-- Beeping interval in seconds
	-- Set to an absurdly high number if you don't want the thing to beep.
	BeepDelay = 1,
	
	-- Can the cracker be used once aka should it disappear when it's done hacking?
	DestructOnUse = false,

	-- Can the cracker be removed when a player presses USE on it?
	RemoveOnUse = true,
	
	-- Can the cracker be removed when taking damage?
	-- NOTE: The cracker is removed only when it takes BULLET damage.
	RemoveOnDamaged = true,
	
	-- Should the progress be shown when the cracker is doing its job?
	ShowProgress = true,

	-- Use Steam Workshop insteaad of FastDL for content?
	UseWorkshop = true,
}

if (SERVER) then
	if (KEYPADCRACKER_SETTINGS.UseWorkshop) then
		resource.AddWorkshop("685913625")
	else
		resource.AddSingleFile("materials/entities/weapon_sh_keypadcracker_deploy.png")
		resource.AddSingleFile("materials/weapons/weapon_sh_keypadcracker_deploy.vmt")
		resource.AddSingleFile("materials/weapons/weapon_sh_keypadcracker_deploy.vtf")
	end
end