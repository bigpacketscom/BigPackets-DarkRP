--------LEAKED BY Friendly Man--------
--------leakforums.net/user-1034794--------
AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "Breaching Charge"
	SWEP.Purpose = "An explosive that can be used to open a door by force."
	SWEP.Instructions = "Aim at a door and deploy.\n<color=green>[LEFT MOUSE BUTTON]</color> Place\n<color=green>[RIGHT MOUSE BUTTON]</color> Rotate"
	SWEP.WepSelectIcon = surface.GetTextureID("weapons/weapon_sh_doorcharge")
	SWEP.BounceWeaponIcon = false
	SWEP.DrawAmmo = false
	SWEP.Slot = 5
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

SWEP.DeployableModel = Model("models/weapons/w_c4.mdl")
SWEP.CreateEntity = "prop_sh_doorcharge"

SWEP.m_fNextRotate = 0

function SWEP:Initialize()
	self:SetHoldType("slam")
	self:SetDeploySpeed(1)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "RotAng")
end

function SWEP:SecondaryAttack()
	self:Rotate(false)
end

function SWEP:Reload()
	self:Rotate(true)
end

function SWEP:Holster()
	if (CLIENT) then
		SafeRemoveEntity(self.m_eGhostModel)
	end

	return true
end

function SWEP:Rotate(inv)
	if (self.m_fNextRotate > CurTime() or !IsFirstTimePredicted()) then
		return end

	self:SetRotAng(self:GetRotAng() + 10 * (inv and -1 or 1))
	self.m_fNextRotate = CurTime() + 0.05

	if (self:GetRotAng() >= 360) then
		self:SetRotAng(self:GetRotAng() - 360)
	end

	if (CLIENT and self.Owner == LocalPlayer()) then
		surface.PlaySound("npc/headcrab_poison/ph_step4.wav")
	end
end

function SWEP:GetTargetPosition()
	local ply = self.Owner
	local sp = ply:GetShootPos()

	local t = {
		start = sp,
		endpos = sp + ply:GetAimVector() * 90,
		mask = MASK_NPCWORLDSTATIC,
	}

	local tr = util.TraceLine(t)

	if (tr.Hit) then
		return tr.HitPos, tr.HitNormal, math.abs(tr.HitNormal.z) > 0.75, tr
	else
		return t.endpos, vector_origin, false, tr
	end
end

function SWEP:AdjustAngles(norm)
	local ang = norm:Angle()
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)

	return ang
end

function SWEP:GetTargetPosition()
	local ply = self.Owner
	local sp = ply:GetShootPos()

	local t = {
		start = sp,
		endpos = sp + ply:GetAimVector() * 32,
		mask = MASK_SHOT,
		filter = ply
	}
	local tr = util.TraceLine(t)
	local ent = tr.Entity

	if (IsValid(ent) and ent:GetClass() == "prop_door_rotating") then
		return tr.HitPos, tr.HitNormal, true, tr
	else
		return t.endpos, vector_origin, false, tr
	end
end

if (SERVER) then
	local cls = "weapon_sh_doorcharge_detonator"

	function SWEP:PrimaryAttack()
		local pos, norm, ok, tr = self:GetTargetPosition()
		if (!ok) then
			return end

		if (!DOORCHARGE_SETTINGS.AllowMultipleCharges or engine.ActiveGamemode() == "terrortown") then
			local swep = self.Owner:GetWeapon("weapon_sh_doorcharge_detonator")
			if (IsValid(swep)) then
				for _, v in pairs (swep.m_Charges) do
					if (IsValid(v)) then
						self.Owner:ChatPrint("The server only allows one door charge at a time.")
						return end
				end
			end
		end

		local ang = self:AdjustAngles(norm)
		ang:RotateAroundAxis(ang:Up(), self:GetRotAng())

		local ent = ents.Create(self.CreateEntity)
		if (!IsValid(ent)) then
			return end

		self:DeployEntity(pos, ang, ent, tr)

		self:Remove()
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end

	function SWEP:DeployEntity(pos, ang, ent, tr)
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:SetPlayerOwner(self.Owner)
		ent:Spawn()
	end

	function SWEP:DeployEntity(pos, ang, ent, tr)
		local ply = self.Owner

		ent:SetPos(pos)
		ent:SetParent(tr.Entity)
		ent:SetAngles(ang)
		ent:SetPlayerOwner(ply)
		ent:Spawn()

		if (ply:HasWeapon(cls)) then
			local swep = ply:GetWeapon(cls)
			table.insert(swep.m_Charges, ent)
		else
			timer.Simple(0.1, function()
				if not (IsValid(ent) or IsValid(ply)) then
					return end

				local swep = ply:Give(cls)
				if (IsValid(swep)) then
					swep.m_Charges = {ent}
				end
			end)
		end
		ply:SelectWeapon(cls)
	end
else
	local matBeam = Material("Effects/laser1", "smooth")

	function SWEP:Precache()
		util.PrecacheSound("npc/headcrab_poison/ph_step4.wav")
		util.PrecacheModel(self.WorldModel)
	end

	function SWEP:PrimaryAttack()
		local pos, norm, ok = self:GetTargetPosition()
		if (!ok) then
			surface.PlaySound("common/wpn_denyselect.wav")
			return
		end
	end

	function SWEP:PreDrawViewModel()
		-- render.SetBlend(0)
	end

	function SWEP:PostDrawViewModel()
		-- render.SetBlend(1)

		if (!IsValid(self.m_eGhostModel)) then
			local mdl = ClientsideModel(self.DeployableModel, RENDERGROUP_VIEWMODEL)
			if (IsValid(mdl)) then
				mdl:SetNoDraw(true)
				mdl:SetMaterial("models/wireframe")
				self.m_eGhostModel = mdl
			end
		else
			local a = LocalPlayer():EyeAngles().y - 90

			local mdl = self.m_eGhostModel
			local pos, norm, ok = self:GetTargetPosition()

			local ang
			if (ok) then
				ang = self:AdjustAngles(norm)
			else
				ang = Angle(0, a, 0)
			end
			ang:RotateAroundAxis(ang:Up(), self:GetRotAng())

			mdl:SetRenderOrigin(pos)
			mdl:SetRenderAngles(ang)

			if (ok) then
				render.SetColorModulation(0, 1, 0)
			else
				render.SetColorModulation(1, 0, 0)
			end
			render.SuppressEngineLighting(true)

			mdl:DrawModel()

			render.SuppressEngineLighting(false)
			render.SetColorModulation(1, 1, 1)
		end
	end

	function SWEP:OnRemove()
		SafeRemoveEntity(self.m_eGhostModel)
	end

	function SWEP:DrawWorldModel()
		local owner = self.Owner
		if (IsValid(owner)) then
			local i = owner:LookupBone("ValveBiped.Bip01_R_Hand")
			if (i) then
				local pos, ang = owner:GetBonePosition(i)
				ang:RotateAroundAxis(ang:Right(), 180)
				ang:RotateAroundAxis(ang:Up(), 90)
				ang:RotateAroundAxis(ang:Forward(), 0)

				pos = pos + ang:Forward() * -5 + ang:Up() * -4 + ang:Right() * -3.5

				self:SetRenderOrigin(pos)
				self:SetRenderAngles(ang)
			end
		end

		self:SetModelScale(0.66, 0)
			self:DrawModel()
		self:SetModelScale(1, 0)
	end
end