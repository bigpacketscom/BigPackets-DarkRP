AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local depcls = "weapon_sh_keypadcracker_deploy"

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetUseType(SIMPLE_USE)

	self:EmitSound("weapons/c4/c4_plant.wav", 75, 100, 0.5)
	self:SetStartTime(CurTime())
	self:SetCompletionTime(CurTime() + KEYPADCRACKER_SETTINGS.HackDuration)

	self.m_fNextBlip = CurTime() + KEYPADCRACKER_SETTINGS.BeepDelay
end

function ENT:BecomeWeapon()
	local wep = ents.Create(depcls)
	wep:SetPos(self:GetPos())
	wep:SetAngles(self:GetAngles())
	wep:Spawn()

	self:Remove()
end

function ENT:Think()
	local keypad = self:GetParent()
	if (!IsValid(keypad)) then
		self:BecomeWeapon()
		return
	end

	if (CurTime() >= self.m_fNextBlip) then
		self.m_fNextBlip = CurTime() + KEYPADCRACKER_SETTINGS.BeepDelay
		self:EmitSound(self.KeyCrackSound)
	end

	if (CurTime() >= self:GetCompletionTime()) then
		pcall(function()
			local winner = math.Rand(0, 1) > KEYPADCRACKER_SETTINGS.FailChance
			if (winner) then
				keypad:Process(true)
			elseif (KEYPADCRACKER_SETTINGS.TriggerDenyOnFail) then
				keypad:Process(false)
			end
		end)

		if (KEYPADCRACKER_SETTINGS.DestructOnUse) then
			self:Remove()
		else
			self:BecomeWeapon()
		end
	end
end

function ENT:Use(ply)
	if (KEYPADCRACKER_SETTINGS.RemoveOnUse) then
		self:BecomeWeapon()
	end
end

function ENT:OnTakeDamage(dmginfo)
	if (KEYPADCRACKER_SETTINGS.RemoveOnDamaged and dmginfo:IsBulletDamage()) then
		self:BecomeWeapon()
	end
end