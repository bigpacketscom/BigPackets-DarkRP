include("shared.lua")
function ENT:Initialize()
    --
end
function ENT:Draw()
    self:DrawModel()
end
function ENT:Think()
    --
end
net.Receive("JackaJobWeedHigh",function(length,ply)
    LocalPlayer().JackaHighOnWeed=tobool(net.ReadBit())
end)
hook.Add("RenderScreenspaceEffects","JackaJobWeedEffects",function()
    local Ply=LocalPlayer()
    if((Ply.JackaHighOnWeed)and(Ply:Alive()))then
        DrawBloom(.25,1,1,1,2,1,1,1,1)
        DrawMotionBlur(.03,1,.01)
    end
end)