AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
ENT.JackyUprightCarry="y"
ENT.JackaJobNoPocket=true
function ENT:Initialize()
    self:SetModel("models/props_interiors/Furniture_Lamp01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local Phys=self:GetPhysicsObject()
    Phys:Wake()
    Phys:SetMass(40)
    self:SetUseType(SIMPLE_USE)
    -- wow, darkrp's item spawning interface is supremely shitty
    self:SetPos(self:GetPos()+Vector(0,0,25))
    -- gah the lamp is so unstable
    local Base=ents.Create("prop_physics")
    Base:SetPos(self:GetPos()-self:GetUp()*33)
    local Ang=self:GetAngles()
    Ang:RotateAroundAxis(Ang:Forward(),90)
    Base:SetModel("models/props_c17/streetsign004f.mdl")
    Base:SetAngles(Ang)
    Base:Spawn()
    Base:Activate()
    Base:GetPhysicsObject():SetMass(40)
    constraint.Weld(Base,self,0,0,0,true,true)
    Base:SetNoDraw(true)
end
function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)
end
function ENT:Think()
    if(self:GetUp().z>.5)then
        self:SetActive(true)
    else
        self:SetActive(false)
    end
    self:NextThink(CurTime()+2)
    return true
end
function ENT:Use(activator)
    activator:PickupObject(self)
end
function ENT:OnRemove()
    --
end