include("shared.lua")

function ENT:Initialize()

end

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	local ang = self:GetAngles()
	
	surface.SetFont("HUDNumber5")
	local TxtWidth = surface.GetTextSize("Hobo Dumpster")
	
	cam.Start3D2D(pos + Vector(0, 0, 30), ang + Angle(0, 90, 90), .50)
		draw.WordBox(2, TxtWidth*-.50, -40, "Hobo Dumpster", "HUDNumber5", Color(15, 20,25, 155), Color(255, 255, 255, 255))
	cam.End3D2D()
	
	if self:GetDTInt(0) > 0 then
		surface.SetFont("HUDNumber5")
		local TxtWidth2 = surface.GetTextSize(string.FormattedTime(self:GetDTInt(0), "%01i:%02i"))
	
		cam.Start3D2D(pos + Vector(0, 0, 60), ang + Angle(0, 90, 90), .5)
			draw.WordBox(2, TxtWidth2*-.50, -40, string.FormattedTime(self:GetDTInt(0), "%01i:%02i"), "HUDNumber5", Color(15, 20,25, 155), Color(255, 255, 255, 255))
		cam.End3D2D()
	end
end

function ENT:Think()
end
