AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "Deployable Keypad Cracker"
	SWEP.Instructions = "Stick on Keypad."
	SWEP.Purpose = "A deployable tool which can be attached to a Keypad. This tool will attempt to crack the Keypad, granting access."
	SWEP.WepSelectIcon = surface.GetTextureID("weapons/weapon_sh_keypadcracker_deploy")
	SWEP.BounceWeaponIcon = false
	SWEP.DrawWeaponInfoBox = true
	SWEP.Slot = 5
	SWEP.SlotPos = 4
end

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.ViewModelFOV = 54
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetHoldType("slam")
	self:SetDeploySpeed(1)
end

function SWEP:Holster()
	self:OnDrop()
	return true
end

function SWEP:OwnerChanged()
	self:OnDrop()
end

function SWEP:Deploy()
	self:OnDrop()
end

function SWEP:OnDrop()
	if (SERVER and self.m_bUsed) then
		self:Remove()
		return
	end

	self.m_eTargetKeypad = nil
	self.m_fDeploying = nil
	self.m_iDeployStage = nil
end

function SWEP:CancelPlanting()
	self:OnDrop()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:Think()
	if (self.m_fDeploying) then
		local ply = self.Owner
		if (!IsValid(ply)) then
			return end

		local ent = self.m_eTargetKeypad
		local sp = ply:GetShootPos()

		if (!IsValid(ent)) then
			self:CancelPlanting()
			return
		end

		local t = {
			start = sp,
			endpos = sp + ply:GetAimVector() * 48,
			mask = MASK_SHOT,
			filter = ply
		}
		local tr = util.TraceLine(t)

		if (tr.Entity ~= ent) then
			self:CancelPlanting()
			return
		end

		if (CurTime() >= self.m_fDeploying) then
			if (self.m_iDeployStage == 1) then
				self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
				self.m_iDeployStage = 2
				self.m_fDeploying = CurTime() + 0.7
			elseif (self.m_iDeployStage == 2) then
				if (SERVER) then
					self:CreateCracker(ply, ent)
					self:Remove()
				end
			end
		end
	end
end

function SWEP:PrimaryAttack()
	if (self.m_fDeploying) then
		return end

	local ply = self.Owner
	local sp = ply:GetShootPos()

	local t = {
		start = sp,
		endpos = sp + ply:GetAimVector() * 48,
		mask = MASK_SHOT,
		filter = ply
	}
	local tr = util.TraceLine(t)
	local ent = tr.Entity

	if (IsValid(ent) and (ent.IsKeypad or ent:GetClass():lower() == "keypad") and !IsValid(ent:GetNWEntity("KEYPADCRACKER", NULL))) then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

		self.m_eTargetKeypad = ent
		self.m_iDeployStage = 1
		self.m_fDeploying = CurTime() + 2.55
	else
		if (CLIENT) then
			self:PlayDenySound()
		end
	end
end

function SWEP:SecondaryAttack()
end

if (SERVER) then
	function SWEP:CreateCracker(ply, keypad)
		local ang = keypad:GetForward():Angle()
		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), -90)

		local ent = ents.Create("prop_sh_keypadcracker")
		ent:SetModelScale(0.5, 0)
		ent:SetPos(keypad:GetPos() - ang:Right() - ang:Forward() * 0.75)
		ent:SetParent(keypad)
		ent:SetAngles(ang)
		ent:Spawn()
		keypad:SetNWEntity("KEYPADCRACKER", ent)
	end
else
	surface.CreateFont("SH_KEYPADCRACKER_LARGE", {font = "roboto", size = 100, weight = 1000})
	surface.CreateFont("SH_KEYPADCRACKER_MEDIUM", {font = "roboto", size = 75, weight = 1000})

	function SWEP:PostDrawViewModel(vm)
		if (!IsValid(vm)) then
			return end

		local bone = vm:LookupBone("v_weapon.c4")
		if (!bone) then
			return end

		local pos, ang = vm:GetBonePosition(bone)
		if (!pos) then
			return end

		ang:RotateAroundAxis(ang:Right(), 180)
		ang:RotateAroundAxis(ang:Forward(), -90)

		cam.Start3D2D(pos - ang:Right() * 0.75 + ang:Up() * 3.6 + ang:Forward() * 4.33, ang, 0.005)
			draw.SimpleTextOutlined("Deployable", "SH_KEYPADCRACKER_LARGE", 0, -100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, color_black)
			draw.SimpleTextOutlined("Keypad Cracker", "SH_KEYPADCRACKER_LARGE", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, color_black)
			draw.SimpleTextOutlined(self.m_fDeploying and "Deploying..." or "Deploy on Keypad", "SH_KEYPADCRACKER_MEDIUM", 0, 100, Color(125, 125, 125), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, color_black)
		cam.End3D2D()
	end

	function SWEP:PlayDenySound()
		surface.PlaySound("common/wpn_denyselect.wav")
	end
end