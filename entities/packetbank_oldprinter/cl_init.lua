include("shared.lua")

function ENT:Initialize()
    self:initVars()
end

function ENT:Draw()
    self:DrawModel()

    local Pos = self:GetPos()
    local Ang = self:GetAngles()

    local owner = self:Getowning_ent()
    owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

    surface.SetFont("HUDNumber5")
    local text = "Old Bank Printer"
    local TextWidth = surface.GetTextSize(text)
    local TextWidth2 = surface.GetTextSize(owner)

    Ang:RotateAroundAxis(Ang:Up(), 90)

    cam.Start3D2D(Pos + Ang:Up() * 11.5, Ang, 0.11)
        draw.WordBox(2, -TextWidth * 0.5, -30, text, "HUDNumber5", Color(15, 20,25, 155), Color(255, 255, 255, 255))
        draw.WordBox(2, -TextWidth2 * 0.5, 18, owner, "HUDNumber5", Color(15, 20,25, 100), Color(255, 255, 255, 255))
    cam.End3D2D()
end

function ENT:Think()
end
