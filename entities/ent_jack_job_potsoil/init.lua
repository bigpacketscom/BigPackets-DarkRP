AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
ENT.JackaJobNoPocket=true
function ENT:Initialize()
    self:SetModel("models/props_junk/garbage_bag001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local Phys=self:GetPhysicsObject()
    Phys:Wake()
    Phys:SetMass(10)
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
end
function ENT:OnRemove()
    --
end