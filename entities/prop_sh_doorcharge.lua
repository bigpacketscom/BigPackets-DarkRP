--------LEAKED BY Friendly Man--------
--------leakforums.net/user-1034794--------
AddCSLuaFile()

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.PrintName = "Breaching Charge"
ENT.Type = "anim"

ENT.IsDoorCharge = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "PlayerOwner")
end

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/weapons/w_c4.mdl")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		self:SetUseType(SIMPLE_USE)

		self:EmitSound("weapons/c4/c4_plant.wav", 75, 100, 0.5)
	end

	function ENT:Think()
		if (self.m_bExploded or self.m_bSpawnedItem) then
			return end

		local door = self:GetParent()
		local owner = self:GetPlayerOwner()
		if (!IsValid(door) or door:GetNoDraw() or !IsValid(owner) or !owner:Alive()) then
			local wep = ents.Create("weapon_sh_doorcharge")
			wep:SetPos(self:GetPos())
			wep:SetAngles(self:GetAngles())
			wep:Spawn()

			self:Remove()
		end
	end

	function ENT:OnRemove()
		local ply = self:GetPlayerOwner()
		if (IsValid(ply)) then
			local swep = ply:GetWeapon("weapon_sh_doorcharge_detonator")
			if (IsValid(swep)) then
				local valid = 0
				for _, v in pairs (swep.m_Charges) do
					if (v == self or !IsValid(v)) then
						continue end

					valid = valid + 1
				end

				if (valid == 0) then
					ply:StripWeapon("weapon_sh_doorcharge_detonator")
				end
			end
		end
	end

	function ENT:BustDoor(ent, slave)
		ent:SetNoDraw(true)
		ent:SetNotSolid(true)
		ent.m_bBusted = true

		local prop = ents.Create("prop_physics")
		prop:SetModel(ent:GetModel())
		prop:SetSkin(ent:GetSkin())
		prop:SetMaterial(ent:GetMaterial())
		prop:SetPos(ent:GetPos())
		prop:SetAngles(ent:GetAngles())
		if (DOORCHARGE_SETTINGS.DoorKillCredit) then
			prop:SetPhysicsAttacker(self:GetPlayerOwner())
		end
		prop:Spawn()
		local phys = prop:GetPhysicsObject()
		if (IsValid(phys)) then
			local force = -self:GetUp() * (8192 * 16)
			phys:SetMass(150)
			prop:SetPos(prop:GetPos() - self:GetUp() * 8)

			if (!DOORCHARGE_SETTINGS.UnhingeOnly) then
				prop:SetVelocity(force)
				phys:ApplyForceOffset(force, self:GetPos())
			end
		end

		for _, v in pairs (ent:GetChildren()) do
			v:SetNoDraw(true)
			v:SetNotSolid(true)
		end

		local t = DOORCHARGE_SETTINGS.RespawnTime
		if (t > 0) then
			SafeRemoveEntityDelayed(prop, DOORCHARGE_SETTINGS.RespawnTime)

			timer.Simple(DOORCHARGE_SETTINGS.RespawnTime, function()
				if (IsValid(ent)) then
					for _, v in pairs (ent:GetChildren()) do
						v:SetNoDraw(false)
						v:SetNotSolid(false)
					end

					ent:SetNoDraw(false)
					ent:SetNotSolid(false)
					ent.m_bBusted = false
				end
			end)
		end

		-- unfuck areaportals
		local name = ent:GetName()
		if (name ~= "") then
			for _, v in pairs (ents.FindByClass("func_areaportal")) do
				local tn = v:GetKeyValues()["target"]
				if (tn == name) then
					v:Fire("Open")
				end
			end
		end
	end

	function ENT:Use(ply)
		if (!ply:HasWeapon("weapon_sh_doorcharge") and ply:Give("weapon_sh_doorcharge")) then
			ply:SelectWeapon("weapon_sh_doorcharge")
			self:EmitSound("items/itempickup.wav")
			self:Remove()
		end
	end

	function ENT:Explode(atk)
		if (self.m_bExploded) then
			return end

		self.m_bExploded = true
		self:SetNoDraw(true)
		self:SetNotSolid(true)

		local pos = self:GetPos()

		if (DOORCHARGE_SETTINGS.BlastDamage) then
			local owner = IsValid(atk) and atk or self:GetPlayerOwner()
			util.BlastDamage(self, IsValid(owner) and owner or self, pos, 144, 90)
		end

		local eff = EffectData()
		eff:SetOrigin(pos)
		eff:SetFlags(0)
		util.Effect("Explosion", eff, true, true)

		local eff = EffectData()
		eff:SetOrigin(pos)
		util.Effect("explodesmoke", eff)

		local door = self:GetParent()
		if (IsValid(door)) then
			self:BustDoor(door)
		end

		SafeRemoveEntityDelayed(self, 5)
	end

	function ENT:OnTakeDamage(dmginfo)
		local atk = dmginfo:GetAttacker()
		if (DOORCHARGE_SETTINGS.Destroyable and dmginfo:IsBulletDamage()) then
			self:Explode(atk)
		end
	end

	hook.Add("PlayerUse", "DOORCHARGE_PlayerUse", function(ply, ent)
		if (ent.m_bBusted) then
			return false
		end
	end)
else
	local matDot = Material("sprites/light_glow02_add")
	local colDot = Color(0, 255, 0)

	function ENT:Draw()
		self:DrawModel()

		-- A green light indicates ownership
		if (self:GetPlayerOwner() == LocalPlayer()) then
			render.SetMaterial(matDot)
			render.DrawSprite(self:GetPos() + self:GetUp() * 5 + self:GetRight() + self:GetForward(), 8, 8, colDot)
		end
	end

	hook.Add("HUDPaint", "DOORCHARGE_HUDPaint", function()
		local tr = LocalPlayer():GetEyeTrace()
		if (tr.HitNonWorld and tr.Fraction <= 0.015625) then
			local ent = tr.Entity
			if (IsValid(ent) and ent.IsDoorCharge) then
				draw.SimpleTextOutlined("Door Charge", "HudSelectionText", ScrW() * 0.5, ScrH() * 0.55, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				draw.SimpleTextOutlined("USE to pick up", "HudSelectionText", ScrW() * 0.5, ScrH() * 0.55 + draw.GetFontHeight("HudSelectionText"), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			end
		end
	end)
end