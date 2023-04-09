--------LEAKED BY Friendly Man--------
--------leakforums.net/user-1034794--------
-- Allows the door charge to be used in TTT.
AddCSLuaFile()

hook.Add("Initialize", "SH_DOORCHARGE_TTTSUPPORT", function()
	if not (engine.ActiveGamemode() == "terrortown") then
		return end

	AMMO_DOORCHARGE = 202

	local function AddSupport()
		local SWEP = weapons.GetStored("weapon_sh_doorcharge")

		SWEP.Icon = "vgui/ttt/icon_doorcharge"
		SWEP.IconLetter = "P"

		SWEP.WeaponID = AMMO_DOORCHARGE
		SWEP.Kind = WEAPON_EQUIP
		SWEP.ViewModelFlip = false

		SWEP.AutoSpawnable = false

		local allow = {}
		if (DOORCHARGE_SETTINGS.TTT.TraitorsGet) then table.insert(allow, ROLE_TRAITOR) end
		if (DOORCHARGE_SETTINGS.TTT.DetectivesGet) then table.insert(allow, ROLE_DETECTIVE) end

		if (#allow > 0) then
			SWEP.EquipMenuData = {
				type = "item_weapon",
				desc = [[An explosive that can be used to open a
door by force.]],
			}

			SWEP.CanBuy = allow
			SWEP.LimitedStock = DOORCHARGE_SETTINGS.TTT.LimitedStock
			SWEP.Icon = "vgui/ttt/icon_doorcharge"
		end

		function SWEP:IsEquipment() return true end

		local SWEP = weapons.GetStored("weapon_sh_doorcharge_detonator")

		SWEP.WeaponID = AMMO_DOORCHARGE
		SWEP.Kind = WEAPON_EQUIP
		SWEP.ViewModelFlip = false

		SWEP.AutoSpawnable = false
		SWEP.AllowDrop = false

		function SWEP:IsEquipment() return true end

		if (CLIENT) then
			SWEP.DrawCrosshair = false
		end
	end

	AddSupport()
end)