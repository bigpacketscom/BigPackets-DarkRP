AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("JackaJobWeedHigh")
function ENT:Initialize()
    self:SetModel("models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local Phys=self:GetPhysicsObject()
    Phys:Wake()
    Phys:SetMass(4)
    self:SetUseType(SIMPLE_USE)
end
function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)
end
function ENT:Think()
    --
end
function ENT:Use(activator)
    if(activator.JackaHighOnWeed)then
        activator:PickupObject(self)
    else
        activator.JackaHighOnWeed=true
        net.Start("JackaJobWeedHigh")
        net.WriteBit(activator.JackaHighOnWeed)
        net.Send(activator)
        self:Remove()
        timer.Simple(60,function()
            if(IsValid(activator))then
                activator.JackaHighOnWeed=false
                net.Start("JackaJobWeedHigh")
                net.WriteBit(activator.JackaHighOnWeed)
                net.Send(activator)
            end
        end)
        activator:EmitSound("ambient/fire/ignite.wav",60,150)
        local Eff=EffectData()
        Eff:SetOrigin(activator:GetShootPos())
        util.Effect("eff_jack_job_potsmoke",Eff,true,true)
    end
    self.NoPlant=false
end
function ENT:OnRemove()
    --
end