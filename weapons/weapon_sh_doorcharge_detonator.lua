--------LEAKED BY Friendly Man--------
--------leakforums.net/user-1034794--------
AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "Breaching Charge Detonator"
	SWEP.WepSelectIcon = surface.GetTextureID("weapons/weapon_sh_doorcharge")
	SWEP.BounceWeaponIcon = false
	SWEP.DrawWeaponInfoBox = false
	SWEP.Slot = 5
end

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.ViewModelFOV = 54
SWEP.WorldModel = "models/weapons/w_slam.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.IsDoorCharge = true
SWEP.m_Charges = {}

function SWEP:Initialize()
	self:SetHoldType("slam")
end

function SWEP:Deploy()
	local vm = self.Owner:GetViewModel(0)
	if (IsValid(vm)) then
		vm:SetWeaponModel(self.ViewModel, self)
	end
	
	self:SendWeaponAnim(ACT_SLAM_DETONATOR_DRAW)
end

function SWEP:PrimaryAttack()
	if (self.m_bUsed) then
		return end

	self.m_bUsed = true

	self:EmitSound("buttons/button9.wav")

	if (SERVER) then
		local charges = self.m_Charges
		local time = 0.2

		for _, v in ipairs (charges) do
			if (IsValid(v)) then
				time = time + 0.2

				v:EmitSound("weapons/c4/c4_beep1.wav")

				timer.Simple(time, function()
					if (IsValid(v)) then
						v.m_DetonatorWeapon = self
						v:Explode()
					end
				end)
			end
		end
		self.Owner:StripWeapon(self:GetClass())
	end
end

function SWEP:SecondaryAttack()
end

if (SERVER) then
	hook.Add("canDropWeapon", "DOORCHARGE_canDropWeapon", function(ply, ent)
		if (ent.IsDoorCharge) then
			return false
		end
	end)
end