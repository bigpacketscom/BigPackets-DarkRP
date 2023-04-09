AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
    self:SetModel("models/props_junk/garbage_bag001a.mdl")
    self:SetModelScale(.5)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local Phys=self:GetPhysicsObject()
    Phys:Wake()
    Phys:SetMass(2)
    self:SetModelScale(.5)
    self:SetUseType(SIMPLE_USE)
end
function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)
end
function ENT:Think()
    --
end
function ENT:Use(activator)
    activator:PickupObject(self)
    self.NoPlant=false
end
function ENT:OnRemove()
    --
end