include("shared.lua")
function ENT:Initialize()
    --
end
local LightMat=Material("sprites/glow01")
LightMat:SetInt("$spriterendermode",7)
local SetYah=false
function ENT:Draw()
    if(self:GetActive())then
        if not(SetYeah)then LightMat:SetInt("$spriterendermode",7);SetYeah=true end
        local Pos=self:GetPos()+self:GetUp()*25
        render.SetMaterial(LightMat)
        render.DrawSprite(Pos,100,100,Color(255,230,175,50))
        render.SuppressEngineLighting(true)
        self:DrawModel()
        render.SuppressEngineLighting(false)
     else
        self:DrawModel()
     end
end
function ENT:Think()
    --
end