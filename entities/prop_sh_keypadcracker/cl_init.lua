include("shared.lua")

ENT.m_fNextDot = 0
ENT.m_sDots = ""

function ENT:Think()
	if (CurTime() >= self.m_fNextDot) then
		self.m_fNextDot = CurTime() + 1
		self.m_sDots = self.m_sDots .. "."

		if (self.m_sDots:len() >= 4) then
			self.m_sDots = ""
		end
	end
end

local matDot = Material("sprites/light_glow02_add")
local colDot = Color(255, 0, 0)

function ENT:Draw()
	self:DrawModel()

	if (self.m_sDots:len() % 2 == 0) then
		render.SetMaterial(matDot)
		render.DrawSprite(self:GetPos() + self:GetUp() * 5 - self:GetRight() * 0.5 + self:GetForward() * 1.65, 4, 4, colDot)
	end

	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), -90)

	local timeleft = self:GetCompletionTime() - CurTime()
	local frac = math.Clamp(timeleft / (self:GetCompletionTime() - self:GetStartTime()), 0, 1)

	cam.Start3D2D(self:GetPos() + ang:Up() * 4.5 - ang:Right() * 1.9 + ang:Forward() * 2.3, ang, 0.004)
		draw.SimpleTextOutlined("Keypad Cracker", "SH_KEYPADCRACKER_LARGE", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, color_black)

		local wi, he = surface.GetTextSize("Keypad Cracker")

		if (KEYPADCRACKER_SETTINGS.ShowProgress) then
			surface.SetDrawColor(0, 0, 0, 100)
			surface.DrawRect(-wi * 0.5, he * 0.75, wi, he)
			surface.SetDrawColor(255 * frac, 255 * (1 - frac), 0, 100)
			surface.DrawRect(-wi * 0.5, he * 0.75, wi * (1 - frac), he)

			surface.SetDrawColor(color_black)

			for i = 0, 3 do
				surface.DrawOutlinedRect(-wi * 0.5 + i, he * 0.75 + i, wi - i * 2, he - i * 2)
			end

			local tl = math.Round(timeleft)
			draw.SimpleTextOutlined(tl .. " second" .. (tl ~= 1 and "s" or "") .. " left" .. self.m_sDots, "SH_KEYPADCRACKER_MEDIUM", 0, he * 2.25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, color_black)
		else
			draw.SimpleTextOutlined("Hacking" .. self.m_sDots, "SH_KEYPADCRACKER_LARGE", 0, he * 1.25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, color_black)
		end
	cam.End3D2D()
end