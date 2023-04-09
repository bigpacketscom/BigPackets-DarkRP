include("shared.lua")
function ENT:Initialize()
    --
end
local Leaf=surface.GetTextureID("mat_jack_job_potleaf")
function ENT:Draw()
    self:DrawModel()
    if(self:GetStage()>=20)then
        local OrigR,OrigG,OrigB=render.GetColorModulation()
        local SelfPos,Up,Right,Forward,Ang=self:GetPos(),self:GetUp(),self:GetRight(),self:GetForward(),self:GetAngles()
        Ang:RotateAroundAxis(Ang:Right(),45)
        cam.Start3D2D(SelfPos-Forward*10+Up*13+Right*-1.5,Ang,.01)
        draw.RoundedBox(50,0,0,800,500,Color(50,50,50,150))
        draw.RoundedBox(50,50,50,500*self:GetHydration()/100,150,Color(0,70,255,200))
        draw.RoundedBox(50,50,290,500*self:GetPlantHealth()/100,150,Color(255,50,0,200))
		if(self:GetStage()>=90)then
			surface.SetDrawColor(Color(255,255,255,100))
			surface.SetTexture(Leaf)
			surface.DrawTexturedRectRotated(660,240,256,256,-90)
		end
        cam.End3D2D()
    end
end
function ENT:Think()
    --
end
local JackaDrugDealer,RotateAng=ents.FindByClass("npc_*")[1],0
net.Receive("JackaJobWeedDealerID",function(length,ply)
	JackaDrugDealer=net.ReadEntity()
end)
hook.Add("PostDrawTranslucentRenderables","JackaJobWeedDealerID",function()
	if((JackaDrugDealer)and(IsValid(JackaDrugDealer)))then
		local self=JackaDrugDealer
		RotateAng=RotateAng+.5
		if(RotateAng>360)then RotateAng=0 end
		local SelfPos,Up,Right,Forward,Ang=self:GetPos(),self:GetUp(),self:GetRight(),self:GetForward(),Angle(-180,-180+RotateAng,-90)
		cam.Start3D2D(SelfPos+Up*80,Ang,.1)
		draw.SimpleTextOutlined("Drug Dealer","Trebuchet24",0,0,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		cam.End3D2D()
		Ang:RotateAroundAxis(vector_up,180)
		cam.Start3D2D(SelfPos+Up*80,Ang,.1)
		draw.SimpleTextOutlined("Drug Dealer","Trebuchet24",0,0,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		cam.End3D2D()
	end
end)